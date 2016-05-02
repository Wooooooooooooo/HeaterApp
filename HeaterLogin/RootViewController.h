//
//  RootViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#ifndef RootViewController_h
#define RootViewController_h

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SetThermometerViewController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end


#endif /* RootViewController_h */
