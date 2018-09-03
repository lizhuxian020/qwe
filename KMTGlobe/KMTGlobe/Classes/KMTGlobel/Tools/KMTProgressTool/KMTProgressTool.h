//
//  KMTProgressTool.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/1.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseTool.h"

typedef void(^progreCcompletionBlock)(void);
@interface KMTProgressTool : KMTBaseTool
+(instancetype)shareProgressTool;
+ (void)show;
+ (void)showWithIsProgressHUDMaskTypeBlack:(BOOL)isProgressHUDMaskTypeBlack;//是否使用黑色半透明背景并且禁止用户操作
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status isProgressHUDMaskTypeBlack:(BOOL)isProgressHUDMaskTypeBlack;//是否使用黑色半透明背景并且禁止用户操作
+ (void)showInfoWithStatus:(NSString *)status;// 有个感叹号标志
+ (void)showInfoWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion;
+ (void)dismiss;
+ (void)dismissWithCompletion:(progreCcompletionBlock)completion;
+ (void)showError;
+ (void)showErrorWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion;
+ (void)showSuccess;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion;
+ (BOOL)isVisible;

+(void)showHUDWithTost:(NSString *)string;
+(void)showHUDWithTost:(NSString *)string onSpecialView:(UIView *)view;
@end
