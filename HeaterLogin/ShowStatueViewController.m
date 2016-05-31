//
//  ModifyHeaterViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//

/*
 
 本类实现查看设备状态的功能
 */


#import <Foundation/Foundation.h>
#import "ShowStatueViewController.h"

@interface ShowStatueViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *heaterArray;    //存放heater的数组
    NSMutableArray *dataArray;  //储存转化为NSData数据类型的heater数组
    NSMutableArray *IDDataArray;
    NSMutableArray *haha;
    NSArray *IDArray; //储存所有id的数组
    BOOL flag;
}

@end



@implementation ShowStatueViewController

-(void)viewDidLoad{
    heaterArray = [NSMutableArray array];
    [super viewDidLoad];
    
    [self getHeaterList];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //tableView显示的行数
    return [heaterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //实现自定义的cell
    static NSString *simpleIdentify = @"CellForShowStatueView";
    
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellForShowStatueView"
                                                 owner:self options:nil];
    
    if ([nib count]>0) {
        
        self.heaterCell = [nib objectAtIndex:0];
        cell = self.heaterCell;
    }
    
    //获取数据源中的heaterArray数组的元素,对应每个cell
    Heater *heater = [heaterArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *IDLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UIWebView *webView = (UIWebView *)[cell.contentView viewWithTag:3];
    nameLabel.text = heater.name;
    IDLabel.text = heater.temperature;
    NSLog(@"%d",heater.state);
    if ([heater.state isEqualToString:@"1"]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"on" ofType:@"gif"];
        //将图片转为NSData
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        //创建一个webView，添加到界面
        //自动调整尺寸
        webView.scalesPageToFit = YES;
        //禁止滚动
        webView.scrollView.scrollEnabled = NO;
        //设置透明效果
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = 0;
        //加载数据
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        
    }else if ([heater.state isEqualToString:@"0"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"off" ofType:@"gif"];
        //将图片转为NSData
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        //创建一个webView，添加到界面
        //自动调整尺寸
        webView.scalesPageToFit = YES;
        //禁止滚动
        webView.scrollView.scrollEnabled = NO;
        //设置透明效果
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = 0;
        //加载数据
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }else if([heater.state isEqualToString:@"2"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"warning" ofType:@"gif"];
        //将图片转为NSData
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        //创建一个webView，添加到界面
        //自动调整尺寸
        webView.scalesPageToFit = YES;
        //禁止滚动
        webView.scrollView.scrollEnabled = NO;
        //设置透明效果
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = 0;
        //加载数据
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }
    
    

    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Heater *heater = [heaterArray objectAtIndex:indexPath.row];
    NSString *ID = heater.ID;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ID forKey:@"code"];
    [self performSegueWithIdentifier:@"SetThermometerViewController" sender:self];
    
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
    [manager GET:@"getList2.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返回值为%@",responseObject);
        NSDictionary* dictArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *string = [dictArr objectForKey:@"item"];
        NSArray *array = [dictArr objectForKey:@"item"];
        if (![string isEqual:[NSNull null]]) {
            for(NSInteger i=0;i<[array count];i++){
                NSDictionary *tempDict = [array objectAtIndex:i];
                NSString *code = [tempDict objectForKey:@"code"];
                NSString *name = [tempDict objectForKey:@"name"];
                NSString *temperature = [tempDict objectForKey:@"temperature"];
                NSString *state = [tempDict objectForKey:@"state"];
                NSLog(@"%@ %@",name,code);
                Heater *heater = [[Heater alloc] init];
                heater.name = name;
                heater.ID = code;
                heater.temperature = temperature;
                heater.state = state;
                [heaterArray addObject:heater];
            }
        }
        [activity stopAnimating];
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"连接服务器出错" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
        [activity stopAnimating];
    }];
    
    
}
@end