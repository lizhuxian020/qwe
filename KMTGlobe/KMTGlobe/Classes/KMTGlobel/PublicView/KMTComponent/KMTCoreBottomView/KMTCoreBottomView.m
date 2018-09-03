//
//  ZXBottomView.m
//  KMDeparture
//
//  Created by mac on 15/8/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTCoreBottomView.h"

#define kBarView_LeftRightMargin 10
#define kBarView_TopBottomMargin 15

@interface KMTCoreBottomView()

@property(nonatomic, weak) UIView *maskView;

@property(nonatomic, weak) UIView *contentView;

//必须Strong
@property(nonatomic, strong) UIView *barView;

@property(nonatomic, strong) UILabel *barLeftLbl;
//必须Strong
@property(nonatomic, strong) UILabel *barCenterLbl;

@property(nonatomic, strong) UILabel *barRightLbl;

@end

@implementation KMTCoreBottomView

UIFont *defalutFont = nil;
+ (void)load {
    defalutFont = KMTFont(30);
}

- (instancetype)init
{
    self = [self initWithBottomY:ScreenHeight];
    if (self) {
    }
    return self;
}

- (instancetype)initWithBottomY:(CGFloat)bottomY {
    self = [super init];
    if (self) {
        self.frame = Rect(0, 0, ScreenWidth, bottomY);
        [self createUIWithBottomY:bottomY];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)createUIWithBottomY:(CGFloat)bottomY {
    UIView *maskView = [UIView new];
    maskView.frame = self.bounds;
    maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:maskView];
    _maskView = maskView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap)];
    [maskView addGestureRecognizer:tap];
    
    UIView *contentView = UIView.new;
    contentView.backgroundColor = WHITECOLOR;
    contentView.frame = Rect(0, self.height, self.width, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    
    [self reloadUI];
}

- (void)reloadUI {
    [_contentView removeAllSubView];
    
    self.barView.width = _contentView.width;
    [_contentView addSubview:self.barView];
    
    //不用addsubView, 默认add上
    [self.barLeftLbl sizeToFit];
    self.barLeftLbl.origin = Point(kBarView_LeftRightMargin, kBarView_TopBottomMargin);
    
    //不用addsubView, 默认add上
    [self.barRightLbl sizeToFit];
    self.barRightLbl.right = self.barView.width - kBarView_LeftRightMargin;
    self.barRightLbl.centerY = self.barLeftLbl.centerY;
    
    if (!kIsEmpty(_title)) {
        self.barCenterLbl.text = _title;
        [_barCenterLbl sizeToFit];
        _barCenterLbl.centerX = self.barView.width / 2.0;
        _barCenterLbl.centerY = self.barLeftLbl.centerY;
        [self.barView addSubview:_barCenterLbl];
    } else {
        //remove之后, 还是被本身指着, 以备下次用上, 跟着self一起释放
        [_barCenterLbl removeFromSuperview];
    }
    
    self.barView.height = _barLeftLbl.bottom + kBarView_TopBottomMargin;
    
    UIView *view = [self createContentViewWithWidth:_contentView.width];
    view.origin = Point(0, self.barView.bottom);
    [_contentView addSubview:view];
    _contentView.height = view.bottom;
}

#pragma mark --PublicMethod
- (void)didClickLeftLbl {
    _didClickLeft ? _didClickLeft() : [self dismiss:YES];
}

- (void)didClickRightLbl {
    _didClickRight ? _didClickRight() : [self dismiss:YES];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.barCenterLbl.text = title;
    [self reloadUI];
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    self.barLeftLbl.text = leftTitle;
    [self reloadUI];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    self.barRightLbl.text = rightTitle;
    [self reloadUI];
}

/**
 @OVERRIDES: 子类需要重写此接口
 */
- (UIView *)createContentViewWithWidth:(CGFloat)contentWidth {
    return nil;
}

- (void)show:(BOOL)animated {
    KSELF
    if (!self.superview) [KEY_WINDOW.rootViewController.view addSubview:self];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            kself.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            kself.contentView.y = kself.height - kself.contentView.height;
        }];
    }
}

- (void)dismiss:(BOOL)animated {
    KSELF
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            kself.maskView.backgroundColor = [UIColor clearColor];
            kself.contentView.y = kself.height;
        } completion:^(BOOL finished) {
            if (kself.superview) [kself removeFromSuperview];
        }];
    } else {
        
    }
}

- (void)maskViewTap {
    [self dismiss:YES];
}

- (UIView *)barView {
    if (!_barView) {
        UIView *barView = [UIView new];
        barView.backgroundColor = kBackgroundColor;
        _barView = barView;
    }
    return _barView;
}

- (UILabel *)barLeftLbl {
    if (!_barLeftLbl) {
        UILabel *lbl = UILabel.new;
        lbl.font = defalutFont;
        lbl.text = @"取消";
        lbl.textColor = kLessGray;
        _barLeftLbl = lbl;
        [self.barView addSubview:_barLeftLbl];
        lbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickLeftLbl)];
        [lbl addGestureRecognizer:tap];
    }
    return _barLeftLbl;
}

- (UILabel *)barCenterLbl {
    if (!_barCenterLbl) {
        UILabel *lbl = UILabel.new;
        lbl.font = defalutFont;
        _barCenterLbl = lbl;
        lbl.textColor = kTextColorAleartView;
    }
    return _barCenterLbl;
}

- (UILabel *)barRightLbl {
    if (!_barRightLbl) {
        UILabel *lbl = UILabel.new;
        lbl.font = defalutFont;
        lbl.text = @"确认";
        lbl.textColor = kMainYellow;
        _barRightLbl = lbl;
        [self.barView addSubview:_barRightLbl];
        lbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickRightLbl)];
        [lbl addGestureRecognizer:tap];
    }
    return _barRightLbl;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
