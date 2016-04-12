//
//  HeaterTableViewControll.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/6.
//  Copyright © 2016年 lmr. All rights reserved.
//

#ifndef HeaterTableViewControll_h
#define HeaterTableViewControll_h

#import <UIKit/UIKit.h>

@interface HeaterTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableViewCell *heaterCell;


@end



#endif /* HeaterTableViewControll_h */


