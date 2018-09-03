//
//  KMTDatePickView.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/25.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTDatePickView : UIPickerView
-(instancetype)initWithFrame:(CGRect)frame DissMissBlock:(void(^)(NSString *dateString,NSString *dayString))selectDateBlock;

-(void)show;
@end
