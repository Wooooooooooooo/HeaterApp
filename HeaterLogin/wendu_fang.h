//
//  wendu_fang.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//


/*
    code4app上下的温度计的类
 
*/

#ifndef wendu_fang_h
#define wendu_fang_h

#import <UIKit/UIKit.h>

@interface wendu_fang : UIView
//底圆宽度,底图长度，底图宽度
@property(nonatomic)float dy_kd,dt_gd,dt_kd;
//需要动态的改变
@property(nonatomic)UIView * view_dt;
//传入的参数
@property(nonatomic)float cs;
//默认位置
@property(nonatomic)float cd;
//范围
@property(nonatomic)float fw;
//
@property(nonatomic)UILabel * labelleaf ,*labelright;


-(void)sz_cs:(float)z;
@end

#endif /* wendu_fang_h */
