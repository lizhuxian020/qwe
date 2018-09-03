//
//  KMTBottomPopView.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KMTBottomPopViewType) {
    KMTBottomPopViewType_sexchnage,//性别选择
    KMTBottomPopViewType_birthday,//生日选择
    KMTBottomPopViewType_packageategory,//包裹品类
    KMTBottomPopViewType_remarksInformation,//备注信息
    KMTBottomPopViewType_receiptTime,//收件时间
    KMTBottomPopViewType_askAdd,//议价
    KMTBottomPopViewType_otherProblem,//其他问题采集
    KMTBottomPopViewType_cancelPickup,//取消取件
    KMTBottomPopViewType_Pay,//支付方式选择
};

typedef NS_ENUM(NSUInteger, KMTBottomBtnAskType) {
    KMTBottomBtnAskType_normal,//未议价
    KMTBottomBtnAskType_alreadyAskd,//已经议价过
};

typedef enum : NSUInteger {
    PayType_ALIPAY,//支付宝支付
    PayType_WXPAY,//微信支付
    PayType_KMPAY,//康美支付
    PayType_YEP,//余额支付
} PayType;

typedef void(^BtnClicked)(id sender,BOOL isSureBtn);
typedef void(^dismissBlock)(UIButton *sender,BOOL isSureBtnClicked);
typedef void (^askAddBlock)(NSString *timeText,NSString *orderText);
typedef void(^sureCancelBlock)(NSMutableArray *senderArray,NSString *text);
typedef void(^selectPayBlock)(PayType type);

@interface KMTBottomPopView : UIView
@property(nonatomic,copy)BtnClicked btnBlock;
@property(nonatomic,copy)askAddBlock askBlock;
@property(nonatomic,copy)sureCancelBlock sureCancleBlock;
@property(nonatomic,copy) selectPayBlock  selectPayBlock ;

-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type andTimetext:(NSString *)time andOrderAmount:(NSString *)amount andProblemArray:(NSArray *)problem andIsAskeType:(KMTBottomBtnAskType)askType andBalance:(NSString *)balance;
-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type andTimetext:(NSString *)time andOrderAmount:(NSString *)amount andIsAskeType:(KMTBottomBtnAskType)askType;
-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type;
-(instancetype)initWithPopViewProblemArray:(NSArray *)contentArray popViewType:(KMTBottomPopViewType)type;
-(instancetype)initWithPopViewProblemArray:(NSArray *)contentArray popViewType:(KMTBottomPopViewType)type andText:(NSString *)text;

-(void)showViewWithdismissBlock:(dismissBlock)block;
-(void)showViewWithaskAddBlock:(askAddBlock)block;
-(void)showViewSureCancel:(sureCancelBlock)block;
-(void)showViewSelectPayCancel:(selectPayBlock)block;
-(void)dissmiss;
@end
