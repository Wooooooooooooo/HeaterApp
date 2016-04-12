//
//  ViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/6.
//  Copyright © 2016年 lmr. All rights reserved.
//



//登录界面的ViewController
#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController{
    
    NSInteger secondCountDown;  //倒计时的秒数
    NSTimer *countDownTimer;//倒计时计时器
    BOOL checkTelFlag;//是否通过本地手机号格式验证
    BOOL sendAgain; //再次发送获取验证码请求
}

- (void)viewDidLoad {
    [super viewDidLoad];        //装载时调用
    checkTelFlag = false;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SendCaptchaRequest:(id)sender {         //发送获取验证码请求
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:1000];//获取验证码的字符串 对应的textfield的tag为1000
    NSString *telNumber = textField.text;//储存电话号
    NSLog(@"发送的手机号码: %@",telNumber);//打印到控制台
    NSString *MOBILE = @"^1[3-9]\\d{9}$"; //利用正则表达式初步验证手机号
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        if([regextestmobile evaluateWithObject:telNumber]){
            checkTelFlag = true;    //验证成功，flag设置为true
            secondCountDown = 10;         //发送验证码后再次发送的倒计时
            _sendButton.enabled = NO;   //设置按钮为不可选
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];//开启计时器，每一秒响应一次。
            
        
        }else{ //如果手机号格式不正确则弹出错误提示
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
    //以下是发送验证码的HTTP请求报文
    /*
     / 这里发送HTTP请求,获取设备的温度信息
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
   
}

- (IBAction)checkPassword:(id)sender {
    if (checkTelFlag) { //如果检验过手机号，执行
        if(true){//根据HTTP响应消息进行验证。如果验证码正确(服务器端判断是否正确),进入到主界面
            [self performSegueWithIdentifier:@"second" sender:self];
            NSLog(@"end");
        }else{//如果验证码错误，弹出错误提示。
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"没有点击“发送”按钮" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:true completion:nil];
        
    }
    
}

-(void)timeFireMethod{
    
    secondCountDown--;
    dispatch_async(dispatch_get_main_queue(), ^{
        //通知主线程刷新UI，
        NSString *stringInt = [NSString stringWithFormat:@"%ld",(long)secondCountDown];
        _sendButton.titleLabel.text = stringInt;
    });
    
    if(secondCountDown==0){ //如果倒计时为0 计时器实效,按钮可以点击
        
        [countDownTimer invalidate];
        countDownTimer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
          
            _sendButton.titleLabel.text = @"发送";//讲按钮title设为发送
            _sendButton.enabled = YES;//按钮变为可选状态
        });
    }
    
    
}




@end
