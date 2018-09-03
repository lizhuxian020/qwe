//
//  AppMacro.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/1.
//  Copyright © 2018年 KMT. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

//KMTProgressTool遮罩背景（SVProgressHUDMaskTypeClear || SVProgressHUDMaskTypeBlack）
#define KMTProgressToolBackgroundIsBlack  SVProgressHUDMaskTypeBlack
//通用
#define kBackgroundColor RGB(244,244,244)
#define kLineColor  RGB(204,204,204)
#define kTextColorAleartView RGB(51,51,51)
#define kMainYellow RGB(255,174,0)
#define kLessGray  RGB(153,153,153)

//注册登录
#define kLoginBtnColor_USE RGB(255,174,0)
#define kLoginBtnColor_NOUSE RGB(255,174,0)
#define kLoginBtnCornerRadius 6

//屏幕间隔
#define kSpace 15

//侧滑菜单宽度
#define kSLIDEMENU_WIDTH 240 //ScreenWidth * 0.65

//首页
#define kHomeADViewHeight  100
#define kBottomViewHeight  60
#define kBottomViewBtnFont FONTSIZE(12)
#define kBottomViewRefreshBtnColor RGB(255,174,0)//刷新按钮
#define kBottomViewBtnTextColor RGB(204,204,204)//接单设置   我的任务
#define kBottomViewBtnWidth 80
#define kBottomViewCertenBtnFont FONTSIZE(16)
#define kTableViewBackgroundColor RGB(244,244,244)
#define kLoginBtnHeight 40
#define kCelltextFont FONTSIZE(16)

//订单详情
#define kOrderDetails_l_r_space 7.5f//背景左右间隔
#define kMapViewHeight 250
#define kMapViewRoadColor RGB(49,190,255)

#pragma mark --正则表达式
#define kRegex_phone @"1[3|5|8][0-9]{9}"

#endif /* AppMacro_h */

