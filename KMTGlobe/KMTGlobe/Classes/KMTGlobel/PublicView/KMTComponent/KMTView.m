//
//  KMTView.m
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTView.h"

@interface KMTView() {
    UIColor *_borderColor;
    CGFloat _borderWidth;
}

//----------- border -----------//
@property(nonatomic, weak) UIView *topBorder;
@property(nonatomic, weak) UIView *bottomBorder;
@property(nonatomic, weak) UIView *leftBorder;
@property(nonatomic, weak) UIView *rightBorder;
//----------- border_end -----------//

@end

@implementation KMTView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _borderColor = RGBA(238, 238, 238, 1);
        _borderWidth = pixelToPoint(1);
    }
    return self;
}

- (BOOL)isShowingTopBorder {
    return self.topBorder ? true : false;
}
- (BOOL)isShowingBottomBorder {
    return self.bottomBorder ? true : false;
}
- (BOOL)isShowingLeftBorder {
    return self.leftBorder ? true : false;
}
- (BOOL)isShowingRightpBorder {
    return self.rightBorder ? true : false;
}

- (void)showTopBorder {
    UIView *topView = [UIView new];
    topView.backgroundColor = _borderColor;
    topView.frame = Rect(0, 0, self.width, _borderWidth);
    [self addSubview:topView];
    self.topBorder = topView;
}
- (void)showBottomBorder {
    UIView *bView = [UIView new];
    bView.backgroundColor = _borderColor;
    bView.frame = Rect(0, self.height-_borderWidth, self.width, _borderWidth);
    [self addSubview:bView];
    self.bottomBorder = bView;
}
- (void)showLeftBorder {
    UIView *lView = [UIView new];
    lView.backgroundColor = _borderColor;
    lView.frame = Rect(0, 0, _borderWidth, self.height);
    [self addSubview:lView];
    self.leftBorder = lView;
}
- (void)showRightBorder {
    UIView *rView = [UIView new];
    rView.backgroundColor = _borderColor;
    rView.frame = Rect(self.width-_borderWidth, 0, _borderWidth, self.height);
    [self addSubview:rView];
    self.rightBorder = rView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isShowingTopBorder || self.isShowingBottomBorder) {
        self.topBorder.width = self.width;
        self.bottomBorder.width = self.width;
    }
    if (self.isShowingLeftBorder || self.isShowingRightpBorder){
        self.leftBorder.height = self.height;
        self.rightBorder.height = self.height;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
