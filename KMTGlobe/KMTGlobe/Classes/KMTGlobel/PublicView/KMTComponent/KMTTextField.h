//
//  KMTTextField.h
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMTView.h"

@class KMTTextField;

typedef void(^countDownCallback) (KMTTextField *);
typedef BOOL(^clickableTFCallback) (KMTTextField *);
typedef void(^normalCallback) (void);

@interface KMTTextField : KMTView

/**
 内容
 */
@property(nonatomic, copy) NSString *content;

@property(nonatomic, assign) UIKeyboardType keyboardType;

@property(nonatomic, assign) NSInteger maxLength;


/**
 输出没有倒计时和没有icon的TextField
 默认高度是根据font的高度 + 上下Margin, margin为15个pixel
 TF字体默认黑色

 @param font 字体大小
 @param placeHolder 提示语
 @return 实例对象
 */
+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder;


/**
 输出有倒计时, 没有icon的TextField
 默认高度是根据font的高度 + 上下Margin, margin为15个pixel
 TF字体默认黑色

 @param font 字体大小
 @param placeHolder 提示语
 @param color 倒计时的Color
 @param sec 倒计时初始秒数
 @param beginStr 初始文案
 @param workingStr 倒数中的文案( secS+工作文案)
 @param callback 点击回调
 @return 实例对象
 */
+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
               countDownTextColor:(UIColor *)color
                           second:(NSInteger)sec
                         beginStr:(NSString *)beginStr
                       workingStr:(NSString *)workingStr
                didClickCountDown:(countDownCallback)callback;

/**
 同上, 多了icon
 */
+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
                             icon:(UIImage *)icon;

/**
 同上, 多了icon
 */
+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
                             icon:(UIImage *)icon
               countDownTextColor:(UIColor *)color
                           second:(NSInteger)sec
                         beginStr:(NSString *)beginStr
                       workingStr:(NSString *)workingStr
                didClickCountDown:(countDownCallback)callback;


/**
 开始倒数(只有当生成倒数组件才能使用)
 */
- (void)startCountDown;


/**
 设置倒计时能否点击

 @param block 在回调里面写上逻辑, YES为可点, false不可点, 注意同时带上你的提示语
 */
- (void)setClickable:(clickableTFCallback)block;

@end
