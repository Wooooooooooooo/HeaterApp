//
//  ThermometerViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import "ThermometerViewController.h"
#import "wendu_fang.h"
@interface ThermometerViewController ()

@end

@implementation ThermometerViewController{
    
    float currentTime; //当前的剩余加热小时数
    float currentTemperature;//当前的温度
    float newTime;//新设定的加热小时数
    float newTemperature;//新设定的温度
    UILabel *showHours;
    UILabel *showTemperature;
    NSString *currentID;
    NSString *currentName;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self csh];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    currentID = [user objectForKey:@"currentID"];
    currentName = [user objectForKey:@"currentName"];
    NSString *temperature = [user objectForKey:@"currentTemperature"];
    NSString *time = [user objectForKey:@"currentHeatTime"];
    currentTemperature = [temperature floatValue];
    currentTime = [time floatValue];
    newTime = currentTime;
    newTemperature = currentTemperature;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)csh{ //网上下的温度计模版的初始化
    
    NSArray * colors = [NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor],[UIColor blueColor], nil];
    for(int i=0;i<1;i++){
        UIView * view_01 = [[UIView alloc]initWithFrame:CGRectMake(((self.view.bounds.size.width-300)/4)*(i+1)+(i*100), self.view.bounds.size.height/3, 100, 2*self.view.bounds.size.height/3-120)];
        view_01.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"buttonHighted"]];
        view_01.layer.cornerRadius=10;
        view_01.tag = (i+1)*10;
        view_01.backgroundColor = colors[i];
        wendu_fang * fang = [[wendu_fang alloc]initWithFrame:CGRectMake(0, 30,view_01.bounds.size.width, view_01.bounds.size.height-40)];
        fang.backgroundColor=[UIColor clearColor];
        fang.fw = 40*(i+1);
        fang.tag = (i+1)*10+1;
        [view_01 addSubview:fang];
        [self.view addSubview:view_01];
    }

  
    //创建导航栏   //导航栏的标题就是该设备的名字
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItemForTitle = [[UINavigationItem alloc] initWithTitle:currentName];
    NSArray *array = [NSArray arrayWithObjects:navigationItemForTitle, nil];
    [navigationBar setItems:array];
    [navigationBar sizeToFit];
    [self.view addSubview:navigationBar];
    //创建返回按钮
    UIButton *returnButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 27, 50, 30)];
    [returnButton setTitle:@"返回" forState:normal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [returnButton setTitleColor:[UIColor blueColor] forState:normal];
    [returnButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    
    //创建显示“现在的温度”的label
    UILabel *nowTemperatrue = [[UILabel alloc]initWithFrame:CGRectMake(25, self.view.bounds.size.height-500,100, 50)];
    nowTemperatrue.text = @"现在的温度";
    nowTemperatrue.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nowTemperatrue];
    
    //显示新设定的时间
    showHours = [[UILabel alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-250,
                                                              100, 50)];
    NSString *stringTime = [NSString stringWithFormat:@"%3.1f",newTime];//格式化浮点数
    NSString *string1 = [stringTime stringByAppendingString:@" h"];//数字结尾拼接上h字符
    showHours.text = string1;
    showHours.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showHours];
    
    //显示剩余加热时间的label
    UILabel *leftLabelForHours = [[UILabel alloc]initWithFrame:CGRectMake(105, self.view.bounds.size.height-300,120, 50)];
    leftLabelForHours.text = @"剩余时间";
    leftLabelForHours.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leftLabelForHours];
    
    //显示的当前剩余的加热时间
    UILabel *showCurrentHeatHours = [[UILabel alloc]initWithFrame:CGRectMake(105,self.view.bounds.size.height-250 ,100, 50)];
    NSString *leftHeatTime = [NSString stringWithFormat:@"%3.1f",currentTime];//格式化浮点数
    NSString *string2 = [leftHeatTime stringByAppendingString:@" h"];//数字结尾拼上h字符
    showCurrentHeatHours.text = string2;
    showCurrentHeatHours.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showCurrentHeatHours];
    
    
    
    //描述加热时长的label
    UILabel *descriptionLabelForHours = [[UILabel alloc]initWithFrame:CGRectMake(200, self.view.bounds.size.height-300,120, 50)];
    descriptionLabelForHours.text = @"设置加热时间";
    descriptionLabelForHours.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptionLabelForHours];
    
    
    //显示调节到的温度
    showTemperature = [[UILabel alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-400                ,100, 50)];
    NSString *stringTemperature = [NSString stringWithFormat:@"%3.1f",newTemperature];
    NSString *string3 = [stringTemperature stringByAppendingString:@" ℃"];
    showTemperature.text = string3;
    showTemperature.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showTemperature];
    
    //描述当前温度的label
    UILabel *descriptionLabelForTemperature = [[UILabel alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-450,100, 50)];
    descriptionLabelForTemperature.text = @"设定温度";
    descriptionLabelForTemperature.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptionLabelForTemperature];
    
    
    //调节时间的stepper
    UIStepper * timeStepper = [[UIStepper alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-200, 100, 50)];
    [timeStepper addTarget:self action:@selector(setCurrentHours:) forControlEvents:UIControlEventTouchDown];
    timeStepper.minimumValue = 0; //能调节的最小时间
    timeStepper.maximumValue = 24;   //能调节的最大时间
    timeStepper.value = currentTime;
    timeStepper.stepValue = 0.5f;    //每1次调节的变化幅度
    [self.view addSubview:timeStepper];
    
    
    //调节温度的stepper
    UIStepper * temperatureStepper = [[UIStepper alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-350, 100, 50)];
    [temperatureStepper addTarget:self action:@selector(setCurrentTemperature:) forControlEvents:UIControlEventTouchDown];
    temperatureStepper.minimumValue = 15; //能调节的最低温度
    temperatureStepper.maximumValue = 30;   //能调节的最高温度
    temperatureStepper.value = currentTemperature;
    temperatureStepper.stepValue = 1.0f;    //每1次调节的变化幅度
    [self.view addSubview:temperatureStepper];
    
    
    //发送状态信息的按钮
    UIButton *sendButton= [[UIButton alloc]initWithFrame:CGRectMake(220, self.view.bounds.size.height-150, 100, 50)];
    [sendButton setTitle:@"设置" forState:normal];
    [sendButton setTitleColor:[UIColor blueColor] forState:normal];
    [sendButton addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    int i=1;
    UIView * view01  = (UIView*)[self.view viewWithTag:i*10] ;
    wendu_fang * fang01 = (wendu_fang*)[view01 viewWithTag:i*10+1];
    [fang01 sz_cs:currentTemperature*2];    //传入的数值乘以2 才会在温度计上显示正确的温度
    
    
    //专门显示摄氏度符号的label
    UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(-100, 140,50, 50)];
    NSString *sign = @"℃";
    signLabel.text = sign;
    signLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:signLabel];
    
    //用于显示从服务器获取的当前设备的温度
    UILabel *labelTemperatrue = [[UILabel alloc]initWithFrame:CGRectMake(25, self.view.bounds.size.height-470 ,100, 50)];
    NSString *stringFormattedTemperature = [NSString stringWithFormat:@"%3.1f",currentTemperature];
    NSString *string4 = [stringFormattedTemperature stringByAppendingString:@" ℃"];
    labelTemperatrue.text = string4;
    labelTemperatrue.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelTemperatrue];
    
    
    
}

-(void)kaishi:(UIStepper*)sender{
    for(int i=1;i<2;i++){
        UIView * view01  = (UIView*)[self.view viewWithTag:i*10] ;
        wendu_fang * fang01 = (wendu_fang*)[view01 viewWithTag:i*10+1];
        [fang01 sz_cs:sender.value];
        
    }
}

-(void)setCurrentHours:(UIStepper*)sender{
    
    newTime = sender.value;
    NSString *stringTime = [NSString stringWithFormat:@"%3.1f",newTime];
    NSString *string5 = [stringTime stringByAppendingString:@" h"];
    showHours.text = string5;
}

-(void)setCurrentTemperature:(UIStepper*)sender{
    
    newTemperature = sender.value;
    NSString *stringTemperature = [NSString stringWithFormat:@"%3.1f",newTemperature];
    NSString *string6 = [stringTemperature stringByAppendingString:@" ℃"];
    showTemperature.text = string6;
}

-(void) onButtonClick:(id)sender{
    
    [self.view removeFromSuperview];
}

-(void) sendRequest:(id)sender{
   
    UIAlertController *newAlertController = [UIAlertController alertControllerWithTitle:@"确认" message:@"确认更改为新的设置吗" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *newCancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *newOkAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //新的温度 newTemerature 新的时间 newTime
        
        
        //以下是发给服务器的HTTP请求报文
        
         // 这里发送HTTP请求,获取设备的温度信息
         NSURL *serverURL = [NSURL URLWithString:@"http://123.184.30.117:8887/"]; //短信验证码服务器url
         
         //AFHTTPSessionManager 创建一个网络请求
         AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:serverURL];
         
         // Requests 请求Header参数
         manager.requestSerializer = [AFHTTPRequestSerializer serializer];
         //系统参数 申明返回的结果是json
         //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
         
         //Responses 响应Header参数
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
         //系统参数
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
         
         //参数urlParam 可以设置多个参数
              NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        
     
   
        
        [params setValue:@"10" forKey:@"Order"];
     //   [params setValue:currentID forKey:@"id"]; //发送ID
        [params setValue:@"732C78D5494B6C63985A4419D6105115" forKey:@"id"];
           NSString * stringTemperature = [NSString stringWithFormat:@"%3.1f",newTemperature];
      //  [params setValue:stringTemperature forKey:@"temperature"];
         [params setValue:@"22.5" forKey:@"temperature"];
        NSString * stringCurrentTime = [NSString stringWithFormat:@"%3.1f",currentTime];
      //  [params setValue:stringCurrentTime forKey:@"delayTime"];
        [params setValue:@"5.0" forKey:@"delayTime"];
         NSString * stringHeatTime = [NSString stringWithFormat:@"%3.1f",newTime];
      //  [params setValue:stringHeatTime forKey:@"heatTime"];
        [params setValue:@"4.0" forKey:@"heatTime"];
         [manager GET:@"index.html" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"成功 HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
             NSLog(@"chenggon");
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"失败 visit error: %@",error);
         }];
         
         
        
    
        if(true){ //判断，如果发送成功
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
        
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失败"  message:@"设置失败,可能是连接服务器失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:true completion:nil];
        
        }
    }];
    [newAlertController addAction:newCancelAction];
    [newAlertController addAction:newOkAction];
     [self presentViewController:newAlertController animated:YES completion:nil];
    
}


@end
