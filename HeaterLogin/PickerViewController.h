//
//  PickerViewController.h
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#ifndef PickerViewController_h
#define PickerViewController_h

#import <UIKit/UIKit.h>
#import "Heater.h"
#import "AFNetworking.h"


@interface PickerViewController : UIViewController<UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource>{
    
    
}


@property (strong,nonatomic) IBOutlet UIButton *button;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;

@end



#endif /* PickerViewController_h */
