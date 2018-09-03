//
//  PayPresentView.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/9.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPresentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *kangmeiPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;

@end
