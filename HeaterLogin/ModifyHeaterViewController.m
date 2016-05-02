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
    NSMutableArray *haha;
    NSArray *IDArray; //储存所有id的数组
    BOOL flag;
}

@end



@implementation ModifyHeaterViewController

-(void)viewDidLoad{
    heaterArray = [NSMutableArray array];
    [super viewDidLoad]; 
   
    [self getHeaterList];
  
    
}
-(void)viewWillAppear{
    
   
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
        
        Heater *heater = [[Heater alloc] init];
        heater = [heaterArray objectAtIndex:[indexPath row]];
        
        NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString* mobile = [user objectForKey:@"mobile"];
        [params setValue:mobile forKey:@"mobile"]; //发送ID

        [params setValue:heater.ID forKey:@"code"];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
        
        [activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
        
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        
        [self.view addSubview:activity];
        [activity startAnimating];
        [manager GET:@"deleteEquipment.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *result = [dic objectForKey:@"result"];
             NSLog(@"收到删除响应");
           
            if([result isEqualToString:@"1"]){
                [self->heaterArray removeObjectAtIndex:[indexPath row]];
                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObjects:indexPath, nil]
                                 withRowAnimation:UITableViewRowAnimationTop];
                
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:true completion:nil];
                [activity stopAnimating];
                
                
            }
            [activity stopAnimating];
            
            [self.tableView reloadData];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"服务器连接错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
            [activity stopAnimating];
        }];
        
       
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
        
        
        if ([IDField.text isEqualToString:@""] ||[captchaField.text isEqualToString:@""] || [nameField.text isEqualToString:@""]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"输入框不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
            
        }else{
        
        
        
        //此处应该向服务器发送验证设备ID于验证码是否相符的请求。
        
        NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
        
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
        NSLog(@"%@",IDField.text);
          NSLog(@"%@",captchaField.text);
          NSLog(@"%@",nameField.text);
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:IDField.text forKey:@"code"];
        [params setValue:captchaField.text forKey:@"password"];
        [params setValue:nameField.text forKey:@"name"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *mobile = [user objectForKey:@"mobile"];
        [params setValue:mobile forKey:@"mobile"];
        [manager GET:@"addEquipment.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //    NSLog(@"json为%@",responseObject);
       //     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"json转化成功");
            NSString *result = [responseObject objectForKey:@"result"];
            if ([result isEqualToString:@"1"]) {
                
                Heater *heater = [[Heater alloc] init];
                NSLog(@"创建累成功");
                heater.ID = IDField.text;
                heater.captcha = captchaField.text;
                heater.name = nameField.text;
                
                    [heaterArray addObject:heater];     //HeaterArray数组中添加Heater
                    [self.tableView reloadData];
                
            /*
                else{//如果ID存在，证明设备已经添加，弹出错误提示框
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"该设备已添加" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:true completion:nil];
                }
            */
            }else if ([result isEqualToString:@"2"]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"该设备已添加" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:true completion:nil];
                
            }else if([result isEqualToString:@"0"]){
                //如果添加的设备ID与验证码不符，则弹出错误提示
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"ID与验证码不符" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:true completion:nil];
            }
        }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"无法连接到服务器" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                 [alertController addAction:cancelAction];
                 [self presentViewController:alertController animated:true completion:nil];
                 
             }];
    
        }}];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil]; //显示AlertController
    
}
-(void)getHeaterList{
  //  heaterArray = [[NSMutableArray alloc] initWithCapacity:100];
    
    
    NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString* mobile = [user objectForKey:@"mobile"];
    [params setValue:mobile forKey:@"mobile"]; //发送ID
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
    [self.view addSubview:activity];
    [activity startAnimating];
    [manager GET:@"getList.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返回值为%@",responseObject);
        NSDictionary* dictArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *string = [dictArr objectForKey:@"item"];
        NSArray *array = [dictArr objectForKey:@"item"];
        if (![string isEqual:[NSNull null]]) {
            for(NSInteger i=0;i<[array count];i++){
                NSDictionary *tempDict = [array objectAtIndex:i];
                NSString *code = [tempDict objectForKey:@"code"];
                NSString *name = [tempDict objectForKey:@"name"];
                NSLog(@"%@ %@",name,code);
                Heater *heater = [[Heater alloc] init];
                heater.name = name;
                heater.ID = code;
                [heaterArray addObject:heater];
            }
        }
            [activity stopAnimating];
            [self.tableView reloadData];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"连接服务器" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
      [activity stopAnimating];
    }];
   
   
}

-(void)deleteEquipment{
    
    
    
    NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString* mobile = [user objectForKey:@"mobile"];
    [params setValue:mobile forKey:@"mobile"]; //发送ID
    NSString *code = [user objectForKey:@"code"];
    [params setValue:code forKey:@"code"];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
    [self.view addSubview:activity];
    [activity startAnimating];
    [manager GET:@"deleteEquipment.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"hehe");
        NSString *result = [responseObject objectForKey:@"result"];
        if([result isEqualToString:@"1"]){
            
            
        }else{
            
           
        }
        [activity stopAnimating];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"连接服务器" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
        [activity stopAnimating];
    }];
    
    
}

@end