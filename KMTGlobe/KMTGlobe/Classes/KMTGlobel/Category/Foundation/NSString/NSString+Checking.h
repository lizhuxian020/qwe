//
//  NSString+Checking.h
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-22.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Checking)

//字符串判断是否为空
- (BOOL)checkEmpty;

//验证手机号码
-(BOOL)checkMobileNumber;

#pragma mark -
#pragma mark -  ztx add start

/**
 *  检测邮箱是否合法
 *
 */
- (BOOL)isValidateEmail;

/**
 *
 *
 */
+ (NSString *)stringContainsEmoji:(NSString *)string;

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize;
#pragma mark -
#pragma mark -  ztx add  end

/**
 *  判断一串数字是不是电话号码
 *
 *  @return YES 是合法的  NO 不是
 */
- (BOOL)isMobileOrTelphoneNumber;

/**
 *  检测是否只包含字母数字
 */
-(BOOL)isAlphanumeric;
/**银行卡号验证*/
+ (BOOL)isBankCardNumber:(NSString *)cardNum;
/**luhn算法校验银行卡号*/
+ (BOOL)luhnCheckBankCardNum:(NSString *)cardNum;
/** 身份证验证*/
+ (BOOL)verifyIDCardNumber:(NSString *)value;
- (NSString *)stringFromDate:(NSDate *)date;

/// 校验是否是中文、英文或数字
- (BOOL)stringShouldAcceptable;
//数组转json
+ (NSString *)objArrayToJSON:(NSArray *)array;
//字典json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 获取某个Bundle下的文件的路径
 
 @param fileName 文件的名字，可以带后缀名
 @param podName pod组件的名字
 @param ext 文件的后缀名
 @return 文件的路径
 */
//+ (nullable NSString *)pathWithFileName:(nonnull NSString *)fileName podName:(nonnull NSString *)podName ofType:(nullable NSString *)ext;

@end
