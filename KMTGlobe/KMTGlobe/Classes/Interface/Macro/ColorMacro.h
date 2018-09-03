//
//  ColorMacro.h
//  KMDeparture
//
//  Created by 康美通 on 2018/5/31.
//  Copyright © 2018年 KMT. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

//常用颜色
#define WHITECOLOR [UIColor whiteColor]
#define BLACKCOLOR [UIColor blackColor]
#define GREENCOLOR [UIColor greenColor]
#define GRAYCOLOR  [UIColor grayColor]
#define ORANGECOLOR [UIColor orangeColor]

//随机色
#define YBLColor(r,g,b,a) [UIColor colorWithRed:(r)/256.0f green:(r)/256.0f blue:(r)/256.0f alpha:(a)]
#define YBLRandomColor YBLColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1)

#define YMRGBValue(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#pragma mark - 各种常见的颜色
#define kButtonEnableColor           RGB(252, 207, 55)
#define kButtonDisableColor          YMRGBValue(0xc8c8c8)
#define kCellTextColor               YMRGBValue(0x515151)
#define kMainTextColor               YMRGBValue(0x515151)
#define kViewBackgroundColor         YMRGBValue(0xf5f5f2)
#define kPromptLabelTextColor        YMRGBValue(0x9d9d9d)
#define LightBule                    YMRGBValue(0x40c0fa)
#define SeparatorColor               YMRGBValue(0xe6e6e6)


#define kAccountTextColor            YMRGBValue(0x646464)
#define kPlaceHoldTextColor          YMRGBValue(0xc8c8c8)
#define kOrangeTextColor             YMRGBValue(0xffb450)
#define kLightGaryColor              YMRGBValue(0x969696)
#define kBlueTextColor               YMRGBValue(0x5caafd)
#define DarkGray                     YMRGBValue(0x969696)
#define SpringRedColor               YMRGBValue(0xfb3a2b)

#define kThemeColor                 kMainYellow

#pragma mark - 字体大小设置
//整体字体名称
#define CustomFontName @"Helvetica"
#define YMFontSize(fontSize)  ([UIFont fontWithName:CustomFontName size:fontSize])
#pragma mark - 各种cell中字体大小
#define kCellTextLabelFont           YMFontSize(17)


#endif /* ColorMacro_h */
