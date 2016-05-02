//
//  PickerViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickerViewController.h"

@interface PickerViewController(){
    NSMutableArray *heaterArray;    //存放heater的数组
    NSMutableArray *dataArray;
    NSMutableArray *IDDataArray;
    NSArray *IDArray; //储存所有id的数组
    NSMutableArray *textArray;
    NSInteger currentRow;
}

@end

@implementation PickerViewController


-(void)viewDidLoad{
   
    textArray = [NSMutableArray array];
    heaterArray = [NSMutableArray array];
    [super viewDidLoad];
     [self getList];
    _selectPicker.delegate = self;
    _selectPicker.dataSource = self;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //可选取的数量
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [heaterArray count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 
    currentRow = row;
    Heater *heater = [heaterArray objectAtIndex:row];
    return heater.name;
    
}
- (IBAction)setThermometer:(UIButton *)sender {
    
    Heater *heater = [heaterArray objectAtIndex:currentRow];
    NSString *ID = heater.ID;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ID forKey:@"code"];
    [self performSegueWithIdentifier:@"showTemperature" sender:self];
  }




/*
-(void)getThermometerParameter{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *code = [user objectForKey:@"code"];
    NSLog(@"选中的code %@",code);
    NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];//很重要
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:code forKey:@"code"]; //发送ID
    [manager GET:@"getState.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:
            NSJSONReadingMutableLeaves error:nil];
        NSString *name = [dic objectForKey:@"name"];
        NSString *time = [dic objectForKey:@"time"];
        NSString *temperature = [dic objectForKey:@"temperature"];
        NSString *state = [dic objectForKey:@"state"];
      
        NSLog(@"%@",time);
        NSLog(@"PickViewController ok");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取设备信息失败失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
    }];
}
*/

-(void)getList{
    
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
        NSDictionary* dictArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *string = [dictArr objectForKey:@"item"];
        NSArray *array = [dictArr objectForKey:@"item"];
        if (![string isEqual:[NSNull null]]) {
            for(NSInteger i=0;i<[array count];i++){
                NSDictionary *tempDict = [array objectAtIndex:i];
                NSString *code = [tempDict objectForKey:@"code"];
                NSString *name = [tempDict objectForKey:@"name"];
                Heater *heater = [[Heater alloc] init];
                heater.name = name;
                heater.ID = code;
                [textArray addObject:name];
                [heaterArray addObject:heater];
            }
        }
        [_selectPicker reloadAllComponents];
       [activity stopAnimating];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"连接服务器" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
        [activity stopAnimating];
    }];
    
    

}

@end