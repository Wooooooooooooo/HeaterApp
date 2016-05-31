//
//  NewSetStatueController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/5/26.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import "NewSetStatueController.h"

@interface NewSetStatueController (){
    
    NSArray* timeArray1;
    NSArray* timeArray2;
    NSArray* temperatureArray;
}

@end

@implementation NewSetStatueController

- (void)viewDidLoad {
    timeArray1 = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                  @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    timeArray2 = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                  @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    temperatureArray = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                        @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",
                        @"25",@"26",@"27",@"28",@"29",@"30",nil];
    _setLastTimeView.delegate = self;
    _setDelayTimeView.delegate = self;
    _setTemperatureView.delegate = self;
    _setLastTimeView.dataSource = self;
    _setDelayTimeView.dataSource = self;
    _setTemperatureView.dataSource = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return [timeArray1 count];
            break;
        case 2:
            return [timeArray2 count];
            break;
        case 3:
            return [temperatureArray count];
            break;
        default:
            break;
    }
    return 0;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    switch (pickerView.tag) {
        case 1:
            return [timeArray1 objectAtIndex:row];
            break;
        case 2:
            return [timeArray2 objectAtIndex:row];
            break;
        case 3:
            return [temperatureArray objectAtIndex:row];
            break;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
