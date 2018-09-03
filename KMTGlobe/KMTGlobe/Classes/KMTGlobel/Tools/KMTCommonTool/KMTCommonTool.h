//
//  KMTCommonTool.h
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTBaseTool.h"

#define CommonTool [KMTCommonTool shareTool]
#define kIsEmpty(obj) [CommonTool isEmpty:obj]

@interface KMTCommonTool : KMTBaseTool


/**
 返回单例对象
 */
+ (instancetype)shareTool;


/**
 返回MainBundle中的图片路径, 根据机型寻找指定的图片

 @param imgName 图片名称(不带@2x等后缀)
 @return 图片路径
 */
- (NSString *)findImage:(NSString *)imgName;


/**
 输入时间戳, 返回按时间格式的时间

 @param formate 时间格式
 @param interval 时间戳
 @return 返回时间字符串
 */
- (NSString *)getDateString:(NSString *)formate interval:(id)interval;


/**
 传入格式和符合这个格式的时间, 返回时间戳

 @param formate 格式
 @param dateStr 时间
 @return 时间戳
 */
- (NSString *)getTimeStampWithFormate:(NSString *)formate dateStr:(NSString *)dateStr;


/**
 输入文本和正则文本, 返回第一个符合正则的文本range, 没找到返回range(0,0)
 PS:时间格式yyyy-MM-dd HH:mm
 @param text 待测文本
 @param regexStr 正则文本
 @return range
 */
- (NSRange)validateString:(NSString *)text regex:(NSString *)regexStr;


/**
 检查是否为空

 @param obj NSString, NSArray, NSDictionary
 @return result
 */
- (BOOL)isEmpty:(id)obj;


/**
 打电话!

 @param phoneNum 电话号码
 */
- (void)callPhone:(NSString *)phoneNum;


/**
 获取一行文字高度

 @param font 输入文字字体大小
 @return 返回高度
 */
- (CGFloat)getOneFontHeight:(UIFont *)font;


/**
 返回可伸缩图片, 输入上下左右的比例, 使得top+bottom = 1, left+right = 1

 @param image 传入图片
 @return 返回图片
 */
- (UIImage *)resizableImage:(UIImage *)image
                        top:(CGFloat)top
                     bottom:(CGFloat)bottom
                       left:(CGFloat)left
                      right:(CGFloat)right;


/**
 复制文案
 */
- (void)pasteString:(NSString *)str;

/**
 Debug用=.=
 */
- (id)convertJSONFile:(NSString *)fileName;

/**
 返回JSON字符串

 @param obj Foundation对象
 @return <#return value description#>
 */
- (NSString *)getJSONStr:(id)obj;

@end
