//
//  NewSetStatueController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/5/26.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSetStatueController : UIViewController<UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIPickerView* setLastTimeView;
@property (nonatomic, strong) IBOutlet UIPickerView* setDelayTimeView;
@property (nonatomic, strong) IBOutlet UIPickerView* setTemperatureView;


@end
