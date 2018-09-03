//
//  XFAlertView.h
//  SCPay
//
//  Created by weihongfang on 2017/6/28.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CANCELCOLOR [UIColor colorWithRed:35/255.f green:135/255.f blue:255/255.f alpha:1]
#define OKCOLOR [UIColor colorWithRed:108/255.f green:217/255.f blue:105/255.f alpha:1]

typedef void(^sureBtnClicked)(UIButton *sender);
typedef void(^BackGroundViewClickedBlock)(id ges);

typedef enum : NSUInteger {
    AleartViewType_message_cancelBtn,//只有取消按钮
    AleartViewType_message_noCancelBtn,//无按钮
    AleartViewType_message_verficationSuccess,//实名认证提交成功
    AleartViewType_message_sureAndCancel,//有取消和确定按钮
} AleartViewType;

@class XFAlertView;

@protocol XFAlertViewDelegate <NSObject>

- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title;

@end

@interface XFAlertView : UIView

@property (nonatomic, assign)id<XFAlertViewDelegate> delegate;
@property(nonatomic,copy)sureBtnClicked sureClicked;
@property(nonatomic,copy) BackGroundViewClickedBlock  backBlock ;

- (instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile andType:(AleartViewType)type;
- (instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile andType:(AleartViewType)type andTitle:(NSString *)title;
-(instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile andType:(AleartViewType)type andTitle:(NSString *)title andIcon:(NSString *)iconName andSureBtnTitle:(NSString *)sureTitle;
- (void)show;

@end
