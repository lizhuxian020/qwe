//
//  KMTLabel.h
//  Test
//
//  Created by mac on 18/7/2018.
//  Copyright © 2018 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTLabel : UIView

/**
 一个bufferMargin, 只处理一行能显示的时候, 他却给了换行高度的情况
 */
@property(nonatomic, assign) CGFloat bufferMargin;


/**
 返回富文本, 需要指定宽度, 高度会根据FONT和TEXT来适配

 @param width 指定宽度
 @param text 显示的文本
 @param textColor 点击部分的TEXTCOLOR
 @param font 点击部分的FONT
 @param regex 匹配正则
 @param params 点击时可带的入参
 @param didClick 点击回调
 @return 返回实例
 */
- (instancetype)initWithWidth:(CGFloat)width
                         text:(NSAttributedString *)text
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                        regex:(NSString *)regex
                       params:(id)params
                     didClick:(CJLabelLinkModelBlock)didClick;


/**
 同上, 这里使用正则数组, 暂时通过判断match的字符串来执行你的block逻辑
 */
- (instancetype)initWithWidth:(CGFloat)width
                         text:(NSAttributedString *)text
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                       regexs:(NSArray<NSString *> *)regexs
                       params:(id)params
                     didClick:(CJLabelLinkModelBlock)didClick;


/**
 在原KMTLabel基础上添加click事件

 @param regex 匹配正则
 @param textColor 点击文本TEXTCOLOR
 @param font 点击文本FONT
 @param params 点击入参
 @param didClick 点击block
 */
- (void)addRegex:(NSString *)regex
       textColor:(UIColor *)textColor
            font:(UIFont *)font
          params:(id)params
        didClick:(CJLabelLinkModelBlock)didClick;

@end
