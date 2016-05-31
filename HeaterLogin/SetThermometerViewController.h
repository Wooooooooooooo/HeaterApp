//
//  SetThermometerViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#ifndef SetThermometerViewController_h
#define SetThermometerViewController_h

#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@interface SetThermometerViewController : UIViewController<UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource>


@property NSInteger pageIndex;
@property IBOutlet UILabel *currentTemperatureLabel;
@property IBOutlet UITextField *lastModifiedTime;
@property IBOutlet UIButton *sendButton;
@property IBOutlet UIWebView *webView;

@property (nonatomic, strong) IBOutlet UIPickerView* setLastTimeView;
@property (nonatomic, strong) IBOutlet UIPickerView* setDelayTimeView;
@property (nonatomic, strong) IBOutlet UIPickerView* setTemperatureView;

@end


#endif /* SetThermometerViewController_h */
