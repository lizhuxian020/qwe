//
//  KMTBaseViewController.h
//  KMDeparture
//
//  Created by 康美通 on 2018/5/31.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTGlobeViewController : UIViewController


#pragma MARK -- HUD
- (void)showHUD;

- (void)showHUDWithStutas:(NSString *)string;

- (void)showHUDWithTost:(NSString *)string;

- (void)hideWaiting;


#pragma mark -- Nav

/**
 返回按钮自定义
 */
- (void)resetBackBarButton;


/**
 pop方法
 */
-(void)viewWillBack;

/**
 判断上级页面类型
 @param VCName ViewController名称
 @return  true/false
 */
-(BOOL)superClassIs:(NSString *)VCName;


/**
 rightItem创建
 
 @param imageName 图片名称
 @param target target
 @param action action
 */
-(void)addRightBarWithImageName:(NSString *)imageName target:(id)target action:(void(^)(id sender))action;


/**
 leftItem创建
 */
-(void)addLeftBarWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;


/**
 自定义rightItem
 
 @param customView 自定义视图
 */
-(void)addRightBarButtonItem:(UIView *)customView;


/**
 自定义rightItem
 
 @param title 标题
 
 */
-(UIButton *)addRightBarWithTitle:(NSString *)title target:(id)target action:(void (^)(id))action;


/**
 push
 
 @param viewController 目标对象
 */
-(void)pushVC:(UIViewController *)viewController;


/**
 在当前导航控制器获取指定控制器

 @param name 要获取的控制器名称
 @return     指定控制器
 */
-(KMTGlobeViewController *)getNavigationVcWithClassName:(NSString *)name;


/**
 退出程序
 */
-(void)exitApplication;

-(void)showNoMoreDateViewWitTitle:(NSString *)title andSuperView:(UIView *)superView WithType:(NSString *)type;

-(void)showNoMoreDateViewWitTitle:(NSString *)title imageName:(NSString *)imageName andSuperView:(UIView *)superView WithType:(NSString *)type;

- (void)showNetworkErrorWithMessage:(NSString *)message SuperView:(UIView *)superView reload:(void(^)(void))reload;

-(void)removeFromSuperView:(UIView *)superView;

@end
