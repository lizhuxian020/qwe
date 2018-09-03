//
//  LYSDateBaseViewController.m
//  LYSDatePickerController
//
//  Created by HENAN on 2018/5/5.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSDateBaseViewController.h"

NSString *const LYSDatePickerWillAppearNotifition = @"LYSDatePickerWillAppearNotifition";
NSString *const LYSDatePickerDidAppearNotifition = @"LYSDatePickerDidAppearNotifition";
NSString *const LYSDatePickerWillDisAppearNotifition = @"LYSDatePickerWillDisAppearNotifition";
NSString *const LYSDatePickerDidDisAppearNotifition = @"LYSDatePickerDidDisAppearNotifition";

NSString *const LYSDatePickerDidCancelNotifition = @"LYSDatePickerDidCancelNotifition";
NSString *const LYSDatePickerDidSelectDateNotifition = @"LYSDatePickerDidSelectDateNotifition";

@interface LYSDateBaseViewController ()

@end

static id datePicker = nil;

@implementation LYSDateBaseViewController

+ (instancetype)shareInstance
{
    if (!datePicker) {
        datePicker = [[[self class] alloc] init];
    }
    return datePicker;
}

+ (void)shareRelease
{
    datePicker = nil;
}

- (void)commitDatePicker
{
    
    if (self.startTime && !self.endTime&&self.timeType != TimeType_start) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [format stringFromDate:self.date];
        int result = [NSDate compareOneDay:self.startTime withAnotherDay:dateString];
        if (result >= 0) {
            ShowToast(@"开始时间要小于结束时间");
            return;
        }
        
    }
    
    if (self.endTime && !self.startTime && self.timeType != TimeType_end) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [format stringFromDate:self.date];
        int result = [NSDate compareOneDay:dateString withAnotherDay:self.endTime];
        if (result >= 0) {
            ShowToast(@"开始时间要小于结束时间");
            return;
        }
    }
    
    if (self.endTime && self.startTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [format stringFromDate:self.date];

        int result3 = [NSDate compareOneDay:self.startTime withAnotherDay:self.endTime];
        int result1 = [NSDate compareOneDay:dateString withAnotherDay:self.startTime];
        int resulte2 = [NSDate compareOneDay:dateString withAnotherDay:self.endTime];
        
        //resulte2 == 1 && result3 <= 0
        //result1 < 0 && resulte2 < 0
        
        switch (self.timeType) {
            case TimeType_start:
            {
                if (resulte2 >= 0 && result3 <= 0 ) {
                    ShowToast(@"开始时间要小于结束时间");
                    return;
                }
            }
                break;
             case TimeType_end:
            {
                if (result1 <= 0 && resulte2 <= 0) {
                    ShowToast(@"开始时间要小于结束时间");
                    return;
                }
            }
                break;
            default:
                break;
        }
                
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LYSDatePickerDidSelectDateNotifition
                                                        object:nil
                                                      userInfo:@{@"date":self.date}];
    if (self.didSelectDatePicker)
    {
        self.didSelectDatePicker(self.date);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewController:didSelectDate:)])
    {
        [self.delegate pickerViewController:(LYSDatePickerController *)self didSelectDate:self.date];
    }
    
}

- (void)cancelDatePicker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewControllerDidCancel:)]) {
        [self.delegate pickerViewControllerDidCancel:(LYSDatePickerController *)self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LYSDatePickerDidCancelNotifition object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
