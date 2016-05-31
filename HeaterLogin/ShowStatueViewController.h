//
//  ShowStatueViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/5/14.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heater.h"
#import "AFNetworking.h"

@interface ShowStatueViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableViewCell *heaterCell;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
