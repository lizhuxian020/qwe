//
//  ZXBottomView.h
//  KMDeparture
//
//  Created by mac on 15/8/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTView.h"

@protocol KMTCoreBottomView

@required

/**
 返回子类的UI

 @param contentWidth 父类的宽度, 根据宽度自己排版, 最后设置好高度
 */
- (UIView *)createContentViewWithWidth:(CGFloat)contentWidth;

@optional

/**
 子类定义点击左侧按钮, 默认执行dismiss, 如果重写了, dismiss逻辑需要自行补充
 */
- (void)didClickLeftLbl;

/**
 子类定义点击右侧按钮, 默认执行dismiss, 如果重写了, dismiss逻辑需要自行补充
 */
- (void)didClickRightLbl;

@end

typedef void(^LblBLK) ();

///该类为一个抽象类，定义了基于KMTCoreBottomView的KMTCoreBottomView类的基本属性和行为，不能直接使用，必须子类化之后才能使用

/**
 PopView核心视图
 */
@interface KMTCoreBottomView : KMTView<KMTCoreBottomView> {
    NSString *_title;
}

/**
 功能栏中间标题, 默认没有, 需要则设置
 */
@property(nonatomic, copy) NSString *title;

/**
 功能栏左标题, 默认是取消, 可设置
 */
@property(nonatomic, copy) NSString *leftTitle;

/**
 功能栏右标题, 默认是取消, 可设置
 */
@property(nonatomic, copy) NSString *rightTitle;

@property(nonatomic, copy) LblBLK didClickLeft;

@property(nonatomic, copy) LblBLK didClickRight;

- (instancetype)initWithBottomY:(CGFloat)bottomY;
- (instancetype)initWithTitle:(NSString *)title;

- (void)reloadUI;

- (void)show:(BOOL)animated;

- (void)dismiss:(BOOL)animated;

@end
