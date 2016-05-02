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


@interface SetThermometerViewController : UIViewController

@property NSInteger pageIndex;
@property IBOutlet UITextField *heatTimeTextField;
@property IBOutlet UITextField *delayTimeTextField;
@property IBOutlet UITextField *heatTemperatureTextField;
@property IBOutlet UITextField *delayHeatTemperatureTextField;
@property IBOutlet UILabel *currentTemperatureLabel;
@property IBOutlet UITextField *lastModifiedTime;
@property IBOutlet UIStepper *heatTimeStepper;
@property IBOutlet UIStepper *delayTimeStepper;
@property IBOutlet UIStepper *heatTemperatureStepper;
@property IBOutlet UIStepper *delayHeatTemperatureStepper;
@property IBOutlet UIButton *sendButton;
@property IBOutlet UIWebView *webView;

@end


#endif /* SetThermometerViewController_h */
