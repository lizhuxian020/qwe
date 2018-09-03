//
//  KMTCustomCalloutView.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *textLabel;


-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title click:(void(^)(NSString *title))completed;

@end


