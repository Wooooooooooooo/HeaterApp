//
//  ModifyHeaterViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/8.
//  Copyright © 2016年 lmr. All rights reserved.
//
/*
 
    本类实现增添删除设备的界面
 */



#import <UIKit/UIKit.h>
#import "Heater.h"
#import "AFNetworking.h"

@interface ModifyHeaterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableViewCell *heaterCell;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end




