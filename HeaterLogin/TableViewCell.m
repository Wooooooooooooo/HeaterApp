//
//  TableViewCell.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/7.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewCell.h"

@interface TableViewCell()

@end

UITextField *textField;

NSString *message;

@implementation TableViewCell


-(NSString*)getText:(NSInteger)index{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];//获取cell的位置

    
    return message;
}


@end