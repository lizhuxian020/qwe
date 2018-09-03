//
//  KMTButton.m
//  KMDeparture
//
//  Created by mac on 12/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTButton.h"

@interface KMTButton()

@property(nonatomic, weak) UIButton *mainBtn;

@property(nonatomic, copy) didClickCallback didClickCallback;

@property(nonatomic, copy) clickableBtnCallback clickableClb;

@end

@implementation KMTButton

- (instancetype)initWithhTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font bgColor:(UIColor *)bgColor didClick:(didClickCallback)callback {
    self = [super init];
    if (self) {
        self.didClickCallback = callback;
        [self createMainBtnTitle:title titleColor:color font:font bgColor:bgColor];
    }
    return self;
}

- (void)createMainBtnTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font bgColor:(UIColor *)bgColor {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(mainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainBtn = btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font bgColor:(UIColor *)bgColor didClick:(didClickCallback)callback {
    return [[KMTButton alloc] initWithhTitle:title titleColor:color font:font bgColor:bgColor didClick:callback];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainBtn.size = self.size;
}

- (void)mainBtnAction {
    wSelf(w_self);
    if (self.clickableClb && !self.clickableClb(w_self)) return;
    self.didClickCallback(w_self);
}

- (void)setClickable:(clickableBtnCallback)callback {
    self.clickableClb = callback;
}


#pragma mark --get & set
- (NSString *)title{
    return self.mainBtn.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    [self.mainBtn setTitle:title forState:UIControlStateNormal];
}

- (UIColor *)titleColor {
    return self.mainBtn.titleLabel.textColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self.mainBtn.titleLabel setTextColor:titleColor];
}

- (UIColor *)bgColor {
    return [self.mainBtn backgroundColor];
}

- (void)setBgColor:(UIColor *)bgColor {
    [self.mainBtn setBackgroundColor:bgColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addCornerRadius:pixelToPoint(10)];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
