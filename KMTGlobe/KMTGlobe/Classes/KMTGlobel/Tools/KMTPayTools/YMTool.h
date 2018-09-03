//
//  YMTool.h
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//判断当前网络是否可用的头文件
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>
#import "YMAlertView.h"
typedef void(^verifiedBlock)( NSDictionary *data, BOOL isVerified);

@protocol YMAlertViewDelegate;
@protocol YMActionSheetDelegate;

@interface YMTool : NSObject

// 提示框
+ (YMAlertView *)alertMessageWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate;
//当前控制器在显示状态才弹框
+ (YMAlertView *)alertMessageWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate  showViewController:(UIViewController *)showViewController;


//绘制虚线
+ (void)drawDashLineInView:(UIView *)superView startPoint:(CGPoint)startP endPoint:(CGPoint)endP;

// 定时器倒计时
+ (void)timerCountDownWith:(NSInteger)time titleChangedButton:(UIButton *)sender;



// 正则表达式判断手机号码是否有效
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum;

// 正则表达式判断邮箱是否有效
+ (BOOL)isValidEmail:(NSString *)email;

// 正则表达式判断是否输入的是数字
+ (BOOL)isNumber:(NSString *)number;

// 正则表达式判断密码是否由数字与字母构成,并长度大于等于6位
+ (BOOL)isValidPassword:(NSString *)password;

//判断是否为有效的个人银行卡账号
+ (BOOL) isValidPersonalBankCardNum:(NSString *)bankCardNum;

//判断姓名是否只由中文组成
+ (BOOL)validateName:(NSString *)name;

//判断身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

//替换字符串的*
+ (NSString *)getStarWithStinng:(NSString *)string Number:(NSInteger)number;

//将邮箱第1位至@符号前全部置换为字符串**
+(NSString *)veilEmail:(NSString *)emailStr;

//限制金额的格式
+ (BOOL)formartInputMoney:(NSString *)inputMoney inputCharacter:(NSString *)inputCharacter;

//把金额从以分为单位转换为xx元xx角xx分的形式
+ (NSString *)convertFenBalanceToYuanJiaoFenWithBalance:(NSString *)balance;

//把金额从以元为单位转换为xx分的形式
+ (NSInteger)convertYuanBalanceToFenWithBalance:(NSString *)balance;

//给一串字符串按每单位长度添加指定的字符
+ (NSString *)appendCharacters:(NSString *)addedStr WithUnitLength:(NSInteger)unitLength inAppendingStr:(NSString *)appendingStr;

//去掉字符串中的空格
+ (NSString *)trimBankCard:(NSString *)bankCardNum;

//根据交易类型的英文转换为中文
+ (NSString *)convertTradingTypeToChieseFromEnglishTradingType:(NSString *)tradingType;

//将银行卡类型转化为中文
+(NSString *)changeChineseTypeWithCardType:(NSString *)cardType;
//安全转换类型
+(NSDictionary *)safeDictionaryWithDic:(NSDictionary *)dic;

//输入是否包含拼音
+ (BOOL)isIncludeChineseInString:(NSString*)str;

//时间戳转换成日期
+(NSString *)getTime:(NSString *)time;

//时间戳转成汉字时间
+(NSString *)getHanziTime:(NSString *)time;

//年月日的时间
+(NSString *)getHanziYearMonthTime:(NSString *)time;

/**
 *  获取当前标准时间（例子：2015年02月03日）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTime;

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentTime;

+ (NSString*)weekdayStringFromDateString:(NSString*)dateString;

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTimeWithxiegang;

//阿拉伯数字转汉字
+(NSString *)arabicNumeralsToChinese:(int)number;

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//联系客服
+(void)customerService;



/**
 * 数字转罗马
 */
+ (NSString *)toRoman:(int)num;

//切换label关键字颜色
+(void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color;







//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


//当大于1000M时，将流量中M转化为G，小于时，不变(如  [YMTool transformGwithM:1000]--》1G )
+ (NSString *)transformGwithM:(NSString *)m;

//校验车牌号
+ (BOOL )validateCarNo:(NSString *)carNo;

//判断输入的时间是否合法
+(BOOL)checkDateIsUsed:(NSString *)dateString;

//身份证号
+ (BOOL)checkIsIdentityCard: (NSString *)identityCard;

//是否含空格
+ (BOOL) checkEmptyString:(NSString *) string;

//是否是中文姓名
+ (BOOL)isVaildRealName:(NSString *)realName;

//根据传入的字符串格式判断，来用****隐藏信息
+ (NSString *)veilString:(NSString *)string;

//身份证号码检查（包含x）
+(BOOL)inputShouldLetterOrNum:(NSString *)inputString;

//输入字符是否为有效字符（不包含特殊符号）
+ (BOOL)isInputRuleNotBlank:(NSString *)str;

//属性字符串
+(NSAttributedString *)getAttStrWithStr:(NSString *)str  attributedSubStrings:(NSArray *)attributedSubStrings attributedStyles:(NSArray *)attributedStyles;

//改变图片透明度
+ (UIImage *)changeAlphaOfImageWith:(CGFloat)alpha withImage:(UIImage*)image;

//登录状态判断
+ (BOOL)loginStatus;

//获取当前窗口的UINavigationController
+(UIViewController *)theTopviewControler;

//字符串url编码
+ (NSString *)urlInURLEncoding:(NSString *)str;

+ (NSString *)getRSASignWithParas:(NSDictionary *)dic;

@end


