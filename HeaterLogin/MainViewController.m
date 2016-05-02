//  MainViewController.m
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GlobalHolder.h"
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController (){
    
    NSString *currentID;
    NSString *currentName;
    NSString *currentTemperature;
}

@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UIView *cylinderView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cylinderViewHeight;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [self getThermometerParameter];
    [super viewDidLoad];
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
  //  [self getThermometerParameter];
   // currentTemperature = [user objectForKey:@"temperature"];
 
   
   
    //   [self startCaptureVideo];
}

-(void)viewDidApper{
    [self getThermometerParameter];
}


- (void)viewWillAppear:(BOOL)animated {
    [self getThermometerParameter];
    [super viewWillAppear:animated];
 //   [self getThermometerParameter];
    /*
    self.activityIndicator.hidden = NO;
    CGFloat temperature = [currentTemperature floatValue];
    if (true) {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°", (long)temperature];
        if (temperature < -30) {
            temperature = -30;
        } else if (temperature > 50) {
            temperature = 50;
        }
        CGFloat height = 3.3 * (temperature + 30) + 22;
        [UIView animateWithDuration:0.6 animations:^{
            self.cylinderView.frame = CGRectMake(self.cylinderView.frame.origin.x, self.ballImageView.frame.origin.y - height + 22, self.cylinderView.frame.size.width, height);
            self.cylinderViewHeight.constant = height;
        }];
        UIColor *backgroundColor = [GlobalHolder sharedSingleton].backgroundColdColor;
        UIColor *cylinderColor = [GlobalHolder sharedSingleton].ballColdColor;
        if (temperature > 15) {
            backgroundColor = [GlobalHolder sharedSingleton].backgroundWarmColor;
            cylinderColor = [GlobalHolder sharedSingleton].ballWarmColor;
            [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallWarm"]];
        } else {
            [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallCold"]];
        }
        self.backgroundView.backgroundColor = backgroundColor;
        self.cylinderView.backgroundColor = cylinderColor;
        self.activityIndicator.hidden = YES;
    }
     */
}


- (IBAction)onWindToMain:(UIStoryboardSegue *)segue
{
    
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
       
        NSString *temperature2 = [dic objectForKey:@"temperature"];
        NSLog(@"当前code为%@",code);
        NSLog(@"当前温度为%@",temperature2);
        currentTemperature = temperature2;
        self.activityIndicator.hidden = NO;
        CGFloat temperature = [currentTemperature floatValue];
        if (true) {
            self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°", (long)temperature];
            if (temperature < -30) {
                temperature = -30;
            } else if (temperature > 50) {
                temperature = 50;
            }
            CGFloat height = 3.3 * (temperature + 30) + 22;
            [UIView animateWithDuration:0.6 animations:^{
                self.cylinderView.frame = CGRectMake(self.cylinderView.frame.origin.x, self.ballImageView.frame.origin.y - height + 22, self.cylinderView.frame.size.width, height);
                self.cylinderViewHeight.constant = height;
            }];
            UIColor *backgroundColor = [GlobalHolder sharedSingleton].backgroundColdColor;
            UIColor *cylinderColor = [GlobalHolder sharedSingleton].ballColdColor;
            if (temperature > 15) {
                backgroundColor = [GlobalHolder sharedSingleton].backgroundWarmColor;
                cylinderColor = [GlobalHolder sharedSingleton].ballWarmColor;
                [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallWarm"]];
            } else {
                [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallCold"]];
            }
            self.backgroundView.backgroundColor = backgroundColor;
            self.cylinderView.backgroundColor = cylinderColor;
            self.activityIndicator.hidden = YES;
        }

        
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
