//
//  Heater.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/7.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//电暖器的类
@interface Heater : NSObject <NSCoding> //归档,将Heater类型变成NSData
    
   @property (nonatomic,strong) NSString *ID;   //ID号码，唯一
   @property (nonatomic,strong) NSString *name;//用户定义的名称
   @property (nonatomic,strong) NSString *captcha;  //验证码
   @property (nonatomic,strong) NSString *state;
   @property (nonatomic,strong) NSString *temperature;

@end
