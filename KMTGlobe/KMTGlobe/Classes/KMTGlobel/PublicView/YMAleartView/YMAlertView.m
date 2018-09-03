//
//  YMAlertView.m
//  YMAlertView
//
//  Created by YiMan on 15/10/31.
//  Copyright © 2015年 YiMan. All rights reserved.
//

#import "YMAlertView.h"
/**
 *   #import <CoreGraphics/CoreGraphics.h>
 #import <QuartzCore/QuartzCore.h>
 */

const static CGFloat kCustomAlertViewDefaultButtonHeight         = 45;
const static CGFloat kCustomAlertViewDefaultButtonSpaceHeight    = 0.5;
const static CGFloat kCustomAlertViewCornerRadius                = 15;
const static CGFloat kCustomMotionEffectExtent                   = 10;

@implementation YMAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

- (instancetype)initWithContainerView:(UIView *)containerView buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.containerView = containerView;
        self.buttonTitles  = buttonTitles;
        self.delegate = delegate;
        self.useMotionEffects = NO;
        
        // 监听键盘的显示与隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.message = message;
        self.buttonTitles  = buttonTitles;
        self.delegate = delegate;
        self.useMotionEffects = NO;
        
        // 监听键盘的显示与隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)buttonColors delegate:(id<YMAlertViewDelegate>) delegate{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.message = message;
        self.buttonTitles  = buttonTitles;
        self.buttonColors = buttonColors;
        self.delegate = delegate;
        self.useMotionEffects = NO;
        
        // 监听键盘的显示与隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - show/dismiss
- (void)show {
    self.dialogView = [self creareDialogView];
    
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (self.useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:self.dialogView];
    
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    CGSize dialogViewSize = [self countDialogViewSize];
    CGSize keyboardSize = CGSizeMake(0, 0);
    
    self.dialogView.frame = CGRectMake((mainScreenSize.width - dialogViewSize.width) / 2, (mainScreenSize.height - keyboardSize.height - dialogViewSize.height) / 2, dialogViewSize.width, dialogViewSize.height);
    
    //如果当前主window上有该视图，先移除，再添加
    NSArray *subViews = [[[UIApplication sharedApplication] windows] firstObject].subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[YMAlertView class]]) {
            [subView removeFromSuperview];
        }
    }
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    self.dialogView.layer.opacity = 0.5f;
    self.dialogView.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35f];
                         self.dialogView.layer.opacity = 1.0f;
                         self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

- (void)dismiss {
    CATransform3D currentTransform = self.dialogView.layer.transform;
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

#pragma mark - assitMethods
- (UIView *)creareDialogView {
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    if (self.containerView == nil) {
        CGRect containerviewFrame = CGRectZero;
        if (iPhone4 || iPhone5) {
            containerviewFrame = CGRectMake(10, 0, mainScreenSize.width - 40 , [self.message stringSizeWithFont:YMFontSize(14) preComputeSize:CGSizeMake(mainScreenSize.width - 40, MAXFLOAT)].height + 60);
        }else if(iPhone6){
            containerviewFrame = CGRectMake(10, 0, mainScreenSize.width - 80 , [self.message stringSizeWithFont:YMFontSize(14) preComputeSize:CGSizeMake(mainScreenSize.width - 40, MAXFLOAT)].height + 60);
        }else{
            containerviewFrame = CGRectMake(10, 0, mainScreenSize.width - 80 , [self.message stringSizeWithFont:YMFontSize(14) preComputeSize:CGSizeMake(mainScreenSize.width - 40, MAXFLOAT)].height + 60);
        }
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:containerviewFrame];
        messageLabel.numberOfLines = 0;
        messageLabel.text = self.message;
        messageLabel.textColor = kAccountTextColor;
        messageLabel.font = YMFontSize(16);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [UILabel changeLineSpaceForLabel:messageLabel WithSpace:10];
        self.containerView = messageLabel;
    }
    
    CGSize dialogViewSize = [self countDialogViewSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogView =  [[UIView alloc] initWithFrame:CGRectMake((mainScreenSize.width - dialogViewSize.width) / 2, (mainScreenSize.height - dialogViewSize.height) / 2, dialogViewSize.width , dialogViewSize.height)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];
    CGFloat cornerRadius = kCustomAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogView.layer insertSublayer:gradient atIndex:0];
    
    dialogView.layer.cornerRadius = cornerRadius;
    dialogView.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0] CGColor];
    dialogView.layer.borderWidth = 1;
    dialogView.layer.shadowRadius = cornerRadius + 5;
    dialogView.layer.shadowOpacity = 0.1f;
    dialogView.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogView.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogView.bounds cornerRadius:dialogView.layer.cornerRadius].CGPath;
    
    // Add the custom container if there is any
    [dialogView addSubview:self.containerView];
    
    // There is a line above the button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogView.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogView.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0];
    [dialogView addSubview:lineView];
    
    // Add the buttons too
    [self addButtonsToView:dialogView];
    
    return dialogView;
}

- (CGSize)countDialogViewSize {
    if (self.buttonTitles != nil && self.buttonTitles.count > 0) {
        buttonHeight       = kCustomAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomAlertViewDefaultButtonSpaceHeight;
    } else {
        buttonHeight       = 0;
        buttonSpacerHeight = 0;
    }
    
    //根据containerView的宽来设置dialogView的宽
    CGFloat dialogViewWidth  = self.containerView.bounds.size.width+20;
    CGFloat dialogViewHeight = self.containerView.bounds.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogViewWidth, dialogViewHeight);
}

- (void)addButtonsToView:(UIView *)container {
    if (self.buttonTitles == nil || self.buttonTitles.count == 0) {
        return;
    }
    
    if (self.buttonTitles.count == 2) {
        CGFloat buttonWidth = (container.bounds.size.width - 1) / 2;
        for (NSInteger i=0; i<self.buttonTitles.count; i++) {
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setFrame:CGRectMake(i * (buttonWidth + 1) , container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
            [closeButton setTag:i];
            [closeButton addTarget:self action:@selector(customAlertViewButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setTag:i];
            
            [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            if (i==0) {
                if ([self.buttonColors isKindOfClass:[NSArray class]]&&self.buttonColors.count==2) {
                    UIColor *leftColor = self.buttonColors[0];
                    [closeButton setTitleColor:leftColor forState:UIControlStateNormal];
                }else{
                    [closeButton setTitleColor:kOrangeTextColor forState:UIControlStateNormal];

                }
            } else if (i == 1) {
                
                if ([self.buttonColors isKindOfClass:[NSArray class]]&&self.buttonColors.count==2) {
                    UIColor *rightColor = self.buttonColors[1];
                    [closeButton setTitleColor:rightColor forState:UIControlStateNormal];
                }else{
                    [closeButton setTitleColor:kAccountTextColor forState:UIControlStateNormal];

                }
            }
            
            [closeButton.titleLabel setFont:YMFontSize(15)];
            [closeButton.layer setCornerRadius:kCustomAlertViewCornerRadius];
            [container addSubview:closeButton];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth + 1, container.bounds.size.height - buttonHeight + 5, 1,  buttonHeight - 10)];
            lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0];
            [container addSubview:lineView];
        }
    } else {
        CGFloat buttonWidth = container.bounds.size.width / self.buttonTitles.count;
        for (NSInteger i=0; i<self.buttonTitles.count; i++) {
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setFrame:CGRectMake(i * buttonWidth , container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
            [closeButton setTag:i];
            [closeButton addTarget:self action:@selector(customAlertViewButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setTag:i];
            
            [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [closeButton setTitleColor:YMRGBValue(0xef9a48) forState:UIControlStateNormal];
            [closeButton.titleLabel setFont:YMFontSize(15)];
            [closeButton.layer setCornerRadius:kCustomAlertViewCornerRadius];
            
            [container addSubview:closeButton];
        }
    }
}

- (void)customAlertViewButtonTouchUpInside:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:sender.tag];
    }
    
    if (self.onButtonTouchUpInside) {
        self.onButtonTouchUpInside(self, (NSInteger)sender.tag);
    }
    
    //clicked the button then dismiss
    [self dismiss];
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomMotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomMotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomMotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomMotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [self.dialogView addMotionEffect:motionEffectGroup];
}
#endif

#pragma mark - keyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    CGSize dialogViewSize = [self countDialogViewSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.05f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((mainScreenSize.width - dialogViewSize.width) / 2, (mainScreenSize.height - keyboardSize.height-dialogViewSize.height - 15), dialogViewSize.width, dialogViewSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    CGSize dialogViewSize = [self countDialogViewSize];
    [UIView animateWithDuration:0.05f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((mainScreenSize.width - dialogViewSize.width) / 2, (mainScreenSize.height - dialogViewSize.height) / 2, dialogViewSize.width, dialogViewSize.height);
                     }
                     completion:nil
     ];
}

@end
