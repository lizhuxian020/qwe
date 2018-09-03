//
//  ShowPayMoneyPWDView.h
//  KMMerchant
//
//  Created by 康美通 on 17/2/8.
//  Copyright © 2017年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TXTradePasswordView.h"

@interface ShowPayMoneyPWDView : UIView
@property (nonatomic, copy) NSString *encStr;//输出密文
@property (nonatomic, assign) BOOL  isMax;//输入的密码是否为6位

@property (nonatomic,copy) void (^completeBlock)(NSString  *encStr);//输完回调


@property (nonatomic, strong) TXTradePasswordView   *inputView;

@property (nonatomic, copy) void (^clickCloseBlock)(void);//点击了close按钮

//amount、fee 单位 分
-(instancetype)initWithPayAmount:(NSString *)amount fee:(NSString *)fee;
-(void)show;
-(void)dismiss;
@end
