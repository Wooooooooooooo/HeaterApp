//
//  StatueViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/7.
//  Copyright © 2016年 lmr. All rights reserved.
//

/*
 
    本类实现查看设备状态的界面
*/


#import <UIKit/UIKit.h>
#import "Heater.h"
#import "ThermometerViewController.h"
#import "AFNetworking.h"

@interface StatueViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableViewCell *heaterCell;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end


