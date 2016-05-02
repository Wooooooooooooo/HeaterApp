//
//  Heater.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/7.
//  Copyright © 2016年 lmr. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Heater.h"


@interface Heater()

@end



@implementation Heater

-(void)encodeWithCoder:(NSCoder *)aCoder{       //NSCoding协议必须实现的方法,将Heater类型转化为NSData
    
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.captcha forKey:@"captcha"];
    [aCoder encodeObject:self.name forKey:@"name"];
   
}

-(id)initWithCoder:(NSCoder *)aDecoder{     //NSCoding协议必须实现的方法,将Heater类型转化为NSData
    
    if(self = [super init]){
        
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.captcha = [aDecoder decodeObjectForKey:@"captcha"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return  self;
}


@end
