//
//  wendu_fang.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wendu_fang.h"

@implementation wendu_fang
@synthesize cs = cs;
@synthesize labelleaf = labelleaf;
@synthesize labelright = labelright;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self cshcs];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

-(void)cshcs{
    //初始化参数
    _dy_kd = 30;
    _dt_kd = 5;
    _dt_gd = self.frame.size.height-_dy_kd;
    _cd = _dt_gd-_dt_gd/30*10;
    _fw = 60;
    
    //初始化底图
    UIView * view_df = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-_dt_kd/2, 0, _dt_kd, _dt_gd)];
    view_df.backgroundColor = [UIColor redColor];
    [self addSubview:view_df];
    
    
    //初始化萌版
    _view_dt = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view_df.bounds.size.width, _cd)];
    _view_dt.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.99];
    _view_dt.layer.cornerRadius = 1.5;
    [view_df addSubview:_view_dt];
    
    //初始化红色圆点
    UIBezierPath * path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(self.bounds.size.width/2, _dt_gd+_dy_kd/2) radius:_dy_kd/2 startAngle:0    endAngle:2*M_PI clockwise:YES];
    CAShapeLayer * shaplayer = [CAShapeLayer layer];
    shaplayer.strokeColor = [[UIColor redColor]CGColor];
    shaplayer.fillColor = [[UIColor redColor]CGColor];
    shaplayer.path = path1.CGPath;
    [self.layer addSublayer:shaplayer];
    
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    CAShapeLayer * shaplayer2 = [CAShapeLayer layer];
    
    
    for(int i=0;i<26;i++){
        
        if(i%5==0 && i!=30){
            //右
            [path2 moveToPoint:CGPointMake(self.bounds.size.width/2+_dt_kd/2+2, _dt_gd/30*i)];
            [path2 addLineToPoint:CGPointMake(self.bounds.size.width/2+_dt_kd/2+20, _dt_gd/30*i)];
            
            
            //左
            [path2 moveToPoint:CGPointMake(self.bounds.size.width/2-_dt_kd/2-2, _dt_gd/30*i)];
            [path2 addLineToPoint:CGPointMake(self.bounds.size.width/2-_dt_kd/2-20, _dt_gd/30*i)];
            
            
        }else{
            //右
            [path2 moveToPoint:CGPointMake(self.bounds.size.width/2+_dt_kd/2+2, _dt_gd/30*i)];
            [path2 addLineToPoint:CGPointMake(self.bounds.size.width/2+_dt_kd/2+10, _dt_gd/30*i)];
            
            //左
            [path2 moveToPoint:CGPointMake(self.bounds.size.width/2-_dt_kd/2-2, _dt_gd/30*i)];
            [path2 addLineToPoint:CGPointMake(self.bounds.size.width/2-_dt_kd/2-10, _dt_gd/30*i)];
        }
        
        
        
    }
    shaplayer2.strokeColor = [[UIColor blackColor]CGColor];
    shaplayer2.path = path2.CGPath;
    [self.layer addSublayer:shaplayer2];
}

-(void)sz_cs:(float)z{
    if(z<=2*_fw){
        float zz = z/(_fw+_fw/2)/2;
        
        [UIView animateWithDuration:1 animations:^(void){
            _view_dt.frame = CGRectMake(0, 0, _dt_kd, _cd -_dt_gd*zz);
        }];
    }
}


-(void)kedu{
    for(int i=0;i<26;i++){
        if(i%5==0 && i!=30){
            labelleaf = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+_dt_kd/2+10, _dt_gd/30*i ,20, 15)];
            NSString *z = [NSString stringWithFormat:@"%.0f",_fw-i/5*_fw/4];
            if(_fw-i/5*_fw/4 == 0){
                labelleaf.textColor = [UIColor redColor];
            }
            labelleaf.text = z;
            labelleaf.font =[UIFont fontWithName:nil size:10];
            labelleaf.textAlignment = 1;
            [self addSubview:labelleaf];
            
            labelright = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-_dt_kd/2-30, _dt_gd/30*i ,20, 15)];
            if(_fw-i/5*_fw/4 == 0){
                labelright.textColor = [UIColor redColor];
            }
            labelright.text = z;
            labelright.font =[UIFont fontWithName:nil size:10];
            labelright.textAlignment = 1;
            [self addSubview:labelright];
        }
    }
}

-(void)setFw:(float)fw{
    _fw = fw;
    [self kedu];
}
@end
