//
//  UILabel+UILabel_ChangeLineSpaceAndWordSpace.h
//  KMTPay
//
//  Created by 张雷 on 2017/11/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


/**
 改变特定文字颜色
 */
+(void)changSpecialLabel:(UILabel *)label TextColor:(UIColor *)color range:(NSRange)range;

@end


