//
//  StatueViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/7.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatueViewController.h"

@interface StatueViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *heaterArray;    //存放heater的数组
    NSMutableArray *dataArray;
    NSMutableArray *IDDataArray;
    NSArray *IDArray; //储存所有id的数组
}


@end

@implementation StatueViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    heaterArray = [[NSMutableArray alloc] initWithCapacity:100];
    dataArray = [[NSMutableArray alloc] initWithCapacity:100];
    IDDataArray = [[NSMutableArray alloc] initWithCapacity:100];
    IDArray = [[NSArray alloc]init];
    IDArray = [NSArray arrayWithArray:IDDataArray];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    // IDArray= [user objectForKey:@"IDArray"];
    //IDDataArray = [IDArray mutableCopy];
    IDDataArray = [NSMutableArray arrayWithArray:[user objectForKey:@"IDArray"]];
    
    for (int i=0; i<IDDataArray.count; i++) {
        
        NSData *heaterData = [user objectForKey:[IDDataArray objectAtIndex:i]];
        
        Heater *heater = [NSKeyedUnarchiver unarchiveObjectWithData:heaterData];
        [heaterArray addObject: heater];
    }
    \
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [heaterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleIdentifier = @"Identify2";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellForStatueViewController"
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //当选择某个cell时触发
    
    Heater *heater = [heaterArray objectAtIndex:indexPath.row];
    NSString *ID = heater.ID;
    NSString *name = heater.name;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ID forKey:@"currentHeater"];
    [userDefaults setObject:name forKey:@"currentName"];
    [userDefaults synchronize];
    /*
    // 这里发送HTTP请求,获取设备的温度信息
     NSURL *serverURL = [NSURL URLWithString:@"https://www.baidu.com/"]; //短信验证码服务器url
     
     //AFHTTPSessionManager 创建一个网络请求
     AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
     
     // Requests 请求Header参数
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     //系统参数 申明返回的结果是json
 //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
     
     //Responses 响应Header参数
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     //系统参数
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     
     //参数urlParam 可以设置多个参数
//     NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
 //    [params setValue:ID forKey:@"ID"]; //发送ID
     [manager GET:@"index.html" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     NSLog(@"成功 HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     NSLog(@"失败 visit error: %@",error);
     }];
     */
    
    
    
    
    /*
    
    这里假设服务器返回一个字符串 格式为 当前温度(摄氏度)_剩余加热时间(小时)
   
    */
    NSString *tempString = @"24.5_5"; //假设返回的温度为24.5度，剩余加热时间为5小时
    NSArray *array = [tempString componentsSeparatedByString:@"_"];
    NSString *temperature = [array objectAtIndex:0];
    NSString *heatTime =  [array objectAtIndex:1];
    [userDefaults setObject:temperature forKey:@"currentTemperature"];
    [userDefaults setObject:heatTime forKey:@"currentHeatTime"];
    //页面跳转
    ThermometerViewController  *viewController = [[ThermometerViewController alloc]init];//跳转到温度计状态画面
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
 //   [viewController didMoveToParentViewController:self];
    
}


- (IBAction)ReturnMainVIewController:(id)sender {
    // 返回上一级viewController
    [self.navigationController popViewControllerAnimated:YES];
}





@end