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
    
    NSArray* timeArray1;
    NSArray* timeArray2;
    NSArray* temperatureArray;
    
    
    float floatHeatTime;
    float floatDelayTime;
    float floatHeatTemperature;
    float floatDelayHeatTemperature;
}

@end

@implementation SetThermometerViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    timeArray1 = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                  @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    timeArray2 = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                  @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    temperatureArray = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                        @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",
                        @"25",@"26",@"27",@"28",@"29",@"30",nil];
    _setLastTimeView.delegate = self;
    _setDelayTimeView.delegate = self;
    _setTemperatureView.delegate = self;
    _setLastTimeView.dataSource = self;
    _setDelayTimeView.dataSource = self;
    _setTemperatureView.dataSource = self;
    
    _setLastTimeView.layer.cornerRadius = _setDelayTimeView.bounds.size.width/2;
    _setLastTimeView.layer.masksToBounds = YES;
    _setLastTimeView.layer.borderWidth = 0.5;
    _setLastTimeView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _setTemperatureView.layer.cornerRadius = _setTemperatureView.bounds.size.width/2;
    _setTemperatureView.layer.masksToBounds = YES;
    _setTemperatureView.layer.borderWidth = 0.5;
    _setTemperatureView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _setDelayTimeView.layer.cornerRadius = _setDelayTimeView.bounds.size.width/2;
    _setDelayTimeView.layer.masksToBounds = YES;
    _setDelayTimeView.layer.borderWidth =0.5;
    _setDelayTimeView.layer.borderColor = [UIColor whiteColor].CGColor;
    
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




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return [timeArray1 count];
            break;
        case 2:
            return [timeArray2 count];
            break;
        case 3:
            return [temperatureArray count];
            break;
        default:
            break;
    }
    return 0;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    switch (pickerView.tag) {
        case 1:
            return [timeArray1 objectAtIndex:row];
            break;
        case 2:
            return [timeArray2 objectAtIndex:row];
            break;
        case 3:
            return [temperatureArray objectAtIndex:row];
            break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES; //label自适应大小
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.layer.borderWidth = 0.0f;
    
    //隐藏掉pickerview中间两条线
    [pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    [pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    
    
    return label;
}

- (IBAction)setTemperature:(id)sender {
    
    NSInteger lastTimeViewRow = [_setLastTimeView selectedRowInComponent:0];
    NSInteger delayTimeViewRow = [_setDelayTimeView selectedRowInComponent:0];
    NSInteger temperatureViewRow = [_setTemperatureView selectedRowInComponent:0];
    NSString *lastTimeString = [timeArray1 objectAtIndex:lastTimeViewRow];
    NSString *delayTimeString = [timeArray2 objectAtIndex:delayTimeViewRow];
    NSString *temperatureString = [temperatureArray objectAtIndex:temperatureViewRow];
    
    NSLog(@"持续时间%@",lastTimeString);
    NSLog(@"延时事件%@",delayTimeString);
    NSLog(@"温度%@",temperatureString);
    
    
    NSURL *serverURL = [NSURL URLWithString:@"http://182.200.65.183:8887/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];//很重要
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"10" forKey:@"Order"];
    [params setValue:@"732C78D5494B6C63985A4419D6105115" forKey:@"id"];
    [params setValue:delayTimeString forKey:@"delayTime"]; //发送ID
    [params setValue:lastTimeString forKey:@"heatTime"];
    [params setValue:temperatureString forKey:@"temperature"];
    
    NSLog(@"loooooooooooooo");
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
    [self.view addSubview:activity];
    [activity startAnimating];
    [manager GET:@"index.html" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"受到的无论啥数据%@",responseObject);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:
                             NSJSONReadingMutableLeaves error:nil];
       
        NSString *state = [dic objectForKey:@"state"];
        
        NSLog(@"张哥那里受到的state     %@",state);
        NSLog(@"PickViewController ok");
        [activity stopAnimating];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取设备信息失败失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
        [activity stopAnimating];
    }];

}



@end