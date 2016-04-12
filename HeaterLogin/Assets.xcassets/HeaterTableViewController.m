//
//  HeaterTableViewControll.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/6.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaterTableViewController.h"
#import "Heater.h"

@interface HeaterTableViewController(){
    
    NSMutableArray *heaterArray;    //存放heater的数组
}

@end

@implementation HeaterTableViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    Heater *h1 = [[Heater alloc]init];
    h1.ID = @"id1";
    h1.name = @"电暖器一号";
    h1.captcha = @"1001";
    Heater *h2 = [[Heater alloc]init];
    h2.ID = @"id2";
    h2.name = @"电暖器二号";
    h2.captcha = @"1002";
    Heater *h3 = [[Heater alloc]init];
    h3.ID = @"id3";
    h3.name = @"电暖器三号";
    h3.captcha = @"1003";
    heaterArray = [NSMutableArray arrayWithObjects:h1,h2,h3, nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [heaterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleIdentifier = @"Identify";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
    
    if ([nib count]>0) {
        
        self.heaterCell = [nib objectAtIndex:0];
        cell = self.heaterCell;
    }
    //获取数据源中的heaterArray数组的元素,对应每个cell
    Heater *heater = [heaterArray objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *IDLabel = (UILabel *)[cell.contentView viewWithTag:2];
    nameLabel.text = heater.name;
    IDLabel.text = heater.ID;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左滑删除
    if(editingStyle == UITableViewCellEditingStyleDelete){
    
        [self->heaterArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationTop];
    }
    
}


- (IBAction)AddNewHeater:(id)sender {   //点击添加按钮
    
    NSLog(@"点击成功！！！");
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加设备" message:@"请填写设备的ID,验证码,和名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"ID";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"验证码";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"名称";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //    UITextField *ID = alertController.textFields.firstObject;
     //   UITextField *password = alertController.textFields.lastObject;
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil]; //显示AlertController

}



@end


