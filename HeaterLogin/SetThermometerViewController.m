//
//  SetThermometerViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetThermometerViewController.h"

@interface SetThermometerViewController(){
    
    NSString *heatTime;
    NSString *delayTime;
    NSString *heatTemperature;
    NSString *delayHeatTemperature;
    NSString *state;
    NSString *currentTemperature;
    NSString *lastModifiedTime;
    float floatHeatTime;
    float floatDelayTime;
    float floatHeatTemperature;
    float floatDelayHeatTemperature;
}

@end

@implementation SetThermometerViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self getThermometerParameter];
    
    
}


- (void)viewWillAppear{
    [super viewWillAppear:true];
    [self getThermometerParameter];
 

}

- (void)loadView
{
    [super loadView];
     [self getThermometerParameter];
    
}

- (IBAction)setHeatTime:(UIStepper *)sender {
    floatHeatTime = sender.value;
    NSString *stringTime = [NSString stringWithFormat:@"%3.1f",floatHeatTime];
    NSString *string = [stringTime stringByAppendingString:@" h"];
    _heatTimeTextField.text = string;

}

- (IBAction)setDelayTime:(UIStepper *)sender {
    
    floatDelayTime = sender.value;
    NSString *stringTime = [NSString stringWithFormat:@"%3.1f",floatDelayTime];
    NSString *string = [stringTime stringByAppendingString:@" h"];
    _delayTimeTextField.text = string;
}

- (IBAction)sendHeatTemperature:(UIStepper *)sender {
    
    floatHeatTemperature = sender.value;
    NSString *stringTemperature = [NSString stringWithFormat:@"%3.1f",floatHeatTemperature];
    NSString *string = [stringTemperature stringByAppendingString:@" ℃"];
    _heatTemperatureTextField.text = string;
}

- (IBAction)sendDelayHeatTemperature:(UIStepper *)sender {
    
    floatDelayHeatTemperature = sender.value;
    NSString *stringTemperature = [NSString stringWithFormat:@"%3.1f",floatDelayHeatTemperature];
    NSString *string = [stringTemperature stringByAppendingString:@" ℃"];
    _delayHeatTemperatureTextField.text = string;
}



-(void)getThermometerParameter{
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
    [self.view addSubview:activity];
    [activity startAnimating];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *code = [user objectForKey:@"code"];
    NSURL *serverURL = [NSURL URLWithString:@"http://nuanyun.applinzi.com/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];//很重要
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:code forKey:@"code"]; //发送ID
    [manager GET:@"getState.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
      //  NSArray *keys = [dic allKeys];
      //  NSLog(@"%@",keys);
        
        NSString *name = [dic objectForKey:@"name"];
        NSString *time = [dic objectForKey:@"time"];
        NSString *temperature = [dic objectForKey:@"temperature"];
        NSString *gettedState = [dic objectForKey:@"state"];
        
        //   heatTemperature = [user objectForKey:@"heatTemperature"];
        currentTemperature = temperature;
        state = gettedState;
        lastModifiedTime = time;
        //   delayTime = [user objectForKey:@"delayTime"];
        //   state = [user objectForKey:@"state"];
        //  heatTime = [user objectForKey:@"heatTime"];
        //  lastModifiedTime = [user objectForKey:@"time"];
        
   //     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:temperature forKey:@"temperature"];
    //    [userDefaults setObject:name forKey:@"name"];
    //    [userDefaults setObject:time forKey:@"time"];
    //    [userDefaults setObject:state forKey:@"state"];
     
        _lastModifiedTime.text = lastModifiedTime;
        _currentTemperatureLabel.text = [currentTemperature stringByAppendingString:@"℃"];
        _heatTemperatureTextField.text = heatTemperature;
        _heatTimeTextField.text = heatTime;
        _delayTimeTextField.text = delayTime;
        //得到图片的路径
        if ([state isEqualToString:@"1"]) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"on" ofType:@"gif"];
            //将图片转为NSData
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            //创建一个webView，添加到界面
            //自动调整尺寸
            _webView.scalesPageToFit = YES;
            //禁止滚动
            _webView.scrollView.scrollEnabled = NO;
            //设置透明效果
            _webView.backgroundColor = [UIColor clearColor];
            _webView.opaque = 0;
            //加载数据
            [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            
        }else if ([state isEqualToString:@"0"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"off" ofType:@"gif"];
            //将图片转为NSData
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            //创建一个webView，添加到界面
            //自动调整尺寸
            _webView.scalesPageToFit = YES;
            //禁止滚动
            _webView.scrollView.scrollEnabled = NO;
            //设置透明效果
            _webView.backgroundColor = [UIColor clearColor];
            _webView.opaque = 0;
            //加载数据
            [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        }else if([state isEqualToString:@"2"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"warning" ofType:@"gif"];
            //将图片转为NSData
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            //创建一个webView，添加到界面
            //自动调整尺寸
            _webView.scalesPageToFit = YES;
            //禁止滚动
            _webView.scrollView.scrollEnabled = NO;
            //设置透明效果
            _webView.backgroundColor = [UIColor clearColor];
            _webView.opaque = 0;
            //加载数据
            [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        }
        

        
        [activity stopAnimating];
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取设备信息失败失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
          }];
    
    
    [activity stopAnimating];
    
}






@end