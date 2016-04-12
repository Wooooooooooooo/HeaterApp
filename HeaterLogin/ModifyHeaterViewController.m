//
//  ModifyHeaterViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//

/*
 
    本类实现添加或删除设备的功能
*/


#import <Foundation/Foundation.h>
#import "ModifyHeaterViewController.h"

@interface ModifyHeaterViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *heaterArray;    //存放heater的数组
    NSMutableArray *dataArray;  //储存转化为NSData数据类型的heater数组
    NSMutableArray *IDDataArray;
    NSArray *IDArray; //储存所有id的数组
    
}

@end



@implementation ModifyHeaterViewController

-(void)viewDidLoad{
    
    [super viewDidLoad]; 
    heaterArray = [[NSMutableArray alloc] initWithCapacity:100];//初始化存放Heater对象的数组
    dataArray = [[NSMutableArray alloc] initWithCapacity:100];
    //初始化存放NSData类型的Heater对象的数组,便于使用NSUserDefaults
    IDDataArray = [[NSMutableArray alloc] initWithCapacity:100];//初始化存放已添加设备ID的动态数组
    IDArray = [[NSArray alloc]init];    //初始化存放已添加设备ID的静态数组
    IDArray = [NSArray arrayWithArray:IDDataArray];
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    IDDataArray = [NSMutableArray arrayWithArray:[user objectForKey:@"IDArray"]];//读取文件中的数据到数组中
  
    for (int i=0; i<IDDataArray.count; i++) {   //扫描获得所有的ID，用于获取ID对应的Heater对象的数据
        
        NSData *heaterData = [user objectForKey:[IDDataArray objectAtIndex:i]];
        
        Heater *heater = [NSKeyedUnarchiver unarchiveObjectWithData:heaterData];
        [heaterArray addObject: heater];//heater对象的数组中加入heater对象
    }
     \
    [self.tableView reloadData];//重新装载tableView
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //tableView显示的行数
    return [heaterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //实现自定义的cell
    static NSString *simpleIdentify = @"TableViewCellForModifyHeaterVIewController";
    
     
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellForModifyHeaterVIewController"
                                                 owner:self options:nil];
    
    if ([nib count]>0) {
        
        self.heaterCell = [nib objectAtIndex:0];
        cell = self.heaterCell;
    }
    
    //获取数据源中的heaterArray数组的元素,对应每个cell
    Heater *heater = [heaterArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *IDLabel = (UILabel *)[cell.contentView viewWithTag:2];
    nameLabel.text = heater.name;
    IDLabel.text = heater.ID;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //本方法实现左滑删除电暖器
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Heater *heater = [heaterArray objectAtIndex:indexPath.row];//从数组中删除该ID对应的Heater对象
        NSString *ID = heater.ID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ID];  //从文件中删除该ID对应的数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        [IDDataArray removeObject:ID];
        IDArray = [IDDataArray copy];                       //动态数组转化为静态数组
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:IDArray forKey:@"IDArray"];
        [self->heaterArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationTop];
    }
    
}

- (IBAction)addNewHeater:(id)sender {//添加新的设备 "添加"按钮的响应方法
    //通过AlertController添加设备信息
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加设备" message:@"请填写设备的ID,验证码,和名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"ID";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"验证码";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"名称";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
            UITextField *IDField = alertController.textFields[0];
            UITextField *captchaField = alertController.textFields[1];
            UITextField *nameField = alertController.textFields[2];
        
        //此处应该向服务器发送验证设备ID于验证码是否相符的请求。
        /*
        NSURL *serverURL = [NSURL URLWithString:@"服务器url"];
        
        //AFHTTPSessionManager 创建一个网络请求
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
        
        // Requests 请求Header参数
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //系统参数
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
        //Responses 响应Header参数
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //系统参数
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //参数urlParam 可以设置多个参数
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:IDField.text forKey:@"ID"];
        [params setValue:captchaField.text forKey:@"catcha"];
      
        
        [manager GET:@"sms.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"成功 HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"失败 visit error: %@",error);
        }];

        */
        
        
        //此处接受HTTP响应消息
        /*
        
        
        
        */
        if(true){       //如果请求通过
            Heater *heater = [[Heater alloc] init];
            heater.ID = IDField.text;
            heater.captcha = captchaField.text;
            heater.name = nameField.text;
            NSString *ID = IDField.text;
            if([[NSUserDefaults standardUserDefaults] objectForKey:IDField.text]==nil){
                //如果ID不存在则添加该设备到tableView和文件中
                NSData *heaterData = [NSKeyedArchiver archivedDataWithRootObject:heater];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:heaterData forKey:IDField.text]; //存入Heater对象
                [heaterArray addObject:heater];     //HeaterArray数组中添加Heater
                [IDDataArray addObject:ID]; //ID数组中添加ID
                IDArray = [IDDataArray copy];                       //动态数组转化为静态数组
                [user setObject:IDArray forKey:@"IDArray"];
                [user synchronize];
                [self.tableView reloadData];
             
            }
            else{//如果ID存在，证明设备已经添加，弹出错误提示框
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"该设备已添加" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:true completion:nil];
            }
            
           
        }else{//如果添加的设备ID与验证码不符，则弹出错误提示
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"ID与验证码不符" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil]; //显示AlertController
}



@end