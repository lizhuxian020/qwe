//
//  UtilsMacro.h
//  KMDeparture
//
//  Created by 康美通 on 2018/5/31.
//  Copyright © 2018年 KMT. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

#define WINDOW                              ([UIApplication sharedApplication].delegate).window
#define KEY_WINDOW                           ([[UIApplication sharedApplication] keyWindow])
#define APPLICATION_DELEGATE                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define kNotificationCenter                  [NSNotificationCenter defaultCenter]
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define Image(name)                         [UIImage imageNamed:name]
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define IsiOS7Later                         (IOSVersion >= 7.0)
#define IsiOS8Later                         (IOSVersion >= 8.0)
#define IsiOS11Later                         (IOSVersion >= 11.0)
#define iOSSystemVersion ([[UIDevice currentDevice] systemVersion].floatValue)

#define VIEW_WIDTH(v)                        v.frame.size.width
#define VIEW_HEIGHT(v)                       v.frame.size.height
#define VIEW_X(v)                            v.frame.origin.x
#define VIEW_Y(v)                            v.frame.origin.y
#define SIZE_WIDTH(v)                        v.size.width
#define SIZE_HEIGHT(v)                       v.size.height
#define ORIGIN_X(v)                          v.origin.x
#define ORIGIN_Y(v)                          v.origin.y

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)
#define IntNumber(i)                        [NSNumber numberWithInt:i]
#define IntegerNumber(i)                    [NSNumber numberWithInteger:i]
#define FloatNumber(f)                      [NSNumber numberWithFloat:f]
#define DoubleNumber(dl)                    [NSNumber numberWithDouble:dl]
#define BoolNumber(b)                       [NSNumber numberWithBool:b]

#define StringNotEmpty(str)                 (str && (str.length > 0))
#define ArrayNotEmpty(arr)                  (arr && (arr.count > 0))
#define StringNotEmpty2(str)                 ( ![str isEqual:[NSNull null]])


#define USERMANAGER                          [UserManager sharedManager]
#define ORDER_SERVICE_MANAGER                [OrderServceManager sharedManager]

#define WINDOW_TABBAVIEWCONTROLLER           ((BaseTabBarController *)(APPLICATION_DELEGATE.window.rootViewController))
#define wSelf(a) __weak typeof(self) a = self;

//字体
#define FONT_NAME_SIZE(_FontName_,_FontSize_)           [UIFont fontWithName:_fontName_ size:_fontSize_]
#define FONTSIZE(_FontSize_)                            [UIFont systemFontOfSize:_FontSize_]
#define FONT_BOLD_SIZE(_FontSize_)                       [UIFont boldSystemFontOfSize: _FontSize_]

/// block self
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(self) strongSelf = weakSelf

//注视
#define _p(a) /**a*/

//打印输出
#ifdef DEBUG
#define KMTLog(...)DDLogVerbose(__VA_ARGS__)
#else  //发布状态  关闭LOG功能
#define KMTLog(...)
#endif

//打印输出
#ifdef DEBUG
#define KMTLogError(...)DDLogError(__VA_ARGS__)
#else  //发布状态  关闭LOG功能
#define KMTLogError(...)
#endif

//颜色16进制
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//nib
#define Nib(name) [UINib nibWithNibName:name bundle:nil]

//代码简写
#define AppVersionNumber                        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppName                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define DeviceName                              [[UIDevice currentDevice] name]
#define DeviceModel                             [[UIDevice currentDevice] systemName]
#define DeviceVersion                           [[UIDevice currentDevice] systemVersion]
#define URLFromString(str)                      [NSURL URLWithString:str]
#define StringFormat(str)                       [NSString stringWithFormat:@"%@",str]
#define KMTStrFormat(...)                       [NSString stringWithFormat:__VA_ARGS__]
#define KMTFUNCK KMTLog(@"%s",__func__);
#define ShowToast(a) [KMTProgressTool showHUDWithTost:a]
#define kUserInforManager [KMTUserInforModel shareUserInforManage]
#define kLoginId kUserInforManager.loginId
#define kToken_user kUserInforManager.token
#define kLogo_user kUserInforManager.head
#define kTel_user kUserInforManager.tel
#define kNSNotificationCenter [NSNotificationCenter defaultCenter]
#define KSELF __weak typeof(self) kself = self;
#define KMTFindImg(imgName) [CommonTool findImage:imgName]
#define KMTImage(imgNmae) [[UIImage alloc] initWithContentsOfFile:KMTFindImg(imgNmae)]
#define kFormatter(a,b) [NSString stringWithFormat:@"%@%@",a,b]

#define kLogicManager [KMTLogicManager shareLogicManager]

#define UI_IS_IPHONE4    (([[UIScreen mainScreen] bounds].size.height)==480)
#define UI_IS_IPHONE5    (([[UIScreen mainScreen] bounds].size.height)==568)
#define UI_IS_IPHONE6    (([[UIScreen mainScreen] bounds].size.height)==667)
#define UI_IS_IPHONE6P   (([[UIScreen mainScreen] bounds].size.height)==736)
#define UI_IS_IPHONEX    (([[UIScreen mainScreen] bounds].size.height)==812)

///状态栏高度
#define UI_STATUS_BAR_HEIGHT                    (UI_IS_IPHONEX ? 44.0 : 20.0)
///导航栏高度
#define UI_NAVIGATION_BAR_HEIGHT                (44)
///状态栏+导航栏高度
#define UI_NAVIGATION_BAR_STATUS_BAR_HEIGHT     (UI_STATUS_BAR_HEIGHT + UI_NAVIGATION_BAR_HEIGHT)
///底部安全距离
#define UI_TAB_BOTTOM_SAFE_PADDING              (UI_IS_IPHONEX ? 34.0 : 0.0)
///TabBar高度
#define UI_TAB_BAR_HEIGHT                       (UI_TAB_BOTTOM_SAFE_PADDING + 49.0)
///iphoneX的偏移
#define UI_STATUS_BAR_IphoneX_PADDING

//用户相关

// 用户登录状态(unlogin/login)
#define kLOGINSTATUS @"USERSTATUS"
#define kUSERINFORKEY @"userInfor"
#define kUSERHEADKEY @"head"
#define kUSERTELKEY @"tel"
#define kUSERREALKEY @"isRealCou"
#define kUSERNAMEKEY @"name"
#define kUSERISPAYPASSWORD @"isPayPasswd"


//定位经纬度
#define kUSER_COORDINATE @"coordinate"

///像素转点
#define pixelToPoint(pi)                        pi / 2.0
#define KMTFont(pi)                             [UIFont systemFontOfSize:pixelToPoint(pi)]

#endif /* UtilsMacro_h */
