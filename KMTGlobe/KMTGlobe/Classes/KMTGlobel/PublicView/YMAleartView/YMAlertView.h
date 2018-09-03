//
//  YMAlertView.h
//  YMAlertView
//
//  Created by YiMan on 15/10/31.
//  Copyright © 2015年 YiMan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMAlertView;

@protocol YMAlertViewDelegate <NSObject>

- (void)customAlertView:(YMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface YMAlertView : UIView

@property (strong, nonatomic) UIView *dialogView;     //Dialog's container view
@property (strong, nonatomic) UIView *containerView;  //Containr within the dialog(place your ui elements here)
@property (copy, nonatomic)   NSString *message;  //提示消息

@property (strong, nonatomic) id<YMAlertViewDelegate> delegate;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (strong, nonatomic) NSArray *buttonColors;
@property (assign, nonatomic) BOOL useMotionEffects;
@property (copy, nonatomic) void (^onButtonTouchUpInside)(YMAlertView *alertView, NSInteger buttonIndex);

- (instancetype)initWithContainerView:(UIView *)containerView buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate;
- (instancetype)initWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate;

- (instancetype)initWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)buttonColors delegate:(id<YMAlertViewDelegate>) delegate;

- (void)show;
- (void)dismiss;

@end
