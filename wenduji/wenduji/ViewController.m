//
//  ViewController.m
//  wenduji
//
//  Created by 孔凡群 on 14-7-21.
//  Copyright (c) 2014年 孔凡群. All rights reserved.
//

#import "ViewController.h"
#import "wendu_yuan2.h"
@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _wendu = [[wendu_yuan2 alloc]initWithFrame:self.view.bounds];
        _wendu.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_wendu];
        
        UIStepper * stepper = [[UIStepper alloc]initWithFrame:CGRectMake(110, self.view.bounds.size.height-100, 100, 50)];
        [stepper addTarget:self action:@selector(kaishi:) forControlEvents:UIControlEventTouchDown];
        stepper.minimumValue = 0.0f;
        stepper.maximumValue = 52.0f;
        stepper.value = 0.0f;
        stepper.stepValue = 1.0f;
        [self.view addSubview:stepper];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//改变状态
-(void)kaishi:(UIStepper*)stepper{
    _wendu.z =stepper.value/50;
}

@end
