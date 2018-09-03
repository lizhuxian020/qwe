//
//  XFAlertView.m
//  SCPay
//
//  Created by weihongfang on 2017/6/28.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import "XFAlertView.h"
#import "UILabel+XFLabel.h"
#import "CJLabel.h"


@interface XFAlertView()

@property (nonatomic, retain)UILabel        *lineLabel;
@property (nonatomic, retain)NSString       *msg;
@property (nonatomic, retain)NSString       *cancelBtnTitle;
@property (nonatomic, retain)NSString       *okBtnTitle;
@property (nonatomic, retain)UIImage        *img;
@property(nonatomic,copy)NSString* title;

@property (nonatomic, strong)UILabel        *lblMsg;
@property (nonatomic, strong)UIButton       *btnCancel;
@property(nonatomic,strong)UIButton *btnSure;
@property (nonatomic, strong)UIImageView    *imgView;
@property(nonatomic,strong)UILabel          *titleLabel;

@property (strong, nonatomic) UIView        *backgroundView;
@property(nonatomic,assign)AleartViewType aleartViewType;
@property(nonatomic,strong)UITapGestureRecognizer *gesture;
@property(nonatomic,strong)UIView *lineView;

@end

@implementation XFAlertView

-(instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile andType:(AleartViewType)type andTitle:(NSString *)title andIcon:(NSString *)iconName andSureBtnTitle:(NSString *)sureTitle{
    if (self == [super init]) {
        _msg = msg;
        _aleartViewType = type;
        _cancelBtnTitle = cancelBtnTtile;
        _title = title;
        
        self.backgroundColor = [UIColor whiteColor];
        _lblMsg = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblMsg.textColor = kTextColorAleartView;
        _lblMsg.backgroundColor = WHITECOLOR;
        _lblMsg.textAlignment = NSTextAlignmentCenter;
        _lblMsg.font =YMFontSize(16);
        
        _lblMsg.numberOfLines = 0;
        [self addSubview:_lblMsg];
        
        NSString *promptTextString  = msg;
        _lblMsg.text = promptTextString;
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONTSIZE(17);
        _titleLabel.textColor = kTextColorAleartView;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        
        
        
        _btnCancel = [[UIButton alloc]init];
        [_btnCancel setTitleColor:kMainYellow forState:UIControlStateNormal];
        [_btnCancel setTitle:_cancelBtnTitle forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSure = [[UIButton alloc]init];
        [_btnSure setTitleColor:kMainYellow forState:UIControlStateNormal];
        [_btnSure setTitle:sureTitle ? :@"取消" forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        
        
        switch (type) {
            case AleartViewType_message_cancelBtn:
            {
                UIImage *image = iconName ? Image(iconName) : Image(@"home_icon_robbed_list");
                _imgView.image = image;
                _img = image;
                [self addSubview:_lineLabel];
                [self addSubview:_btnCancel];
            }
                break;
            case AleartViewType_message_noCancelBtn:
            {
                UIImage *image = iconName ? Image(iconName) : Image(@"home_icon_cancel");
                _imgView.image = image;
                _img = image;
//                _backgroundView.userInteractionEnabled = YES;
//                [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)]];
            }
                break;
            case AleartViewType_message_verficationSuccess:
            {
                UIImage *image = iconName ? Image(iconName) : Image(@"registered_icon_submitted_successfully");
                _imgView.image = image;
                _img = image;
                [self addSubview:_titleLabel];
                [self addSubview:_lineLabel];
                [self addSubview:_btnCancel];
            }
                break;
            case AleartViewType_message_sureAndCancel:
            {
                UIImage *image = iconName ? Image(iconName) : Image(@"registered_icon_submitted_successfully");
                _imgView.image = image;
                _img = image;
                
                _lineView = [UIView drawVerticalLineView:CGRectZero];
                
                [self addSubview:_titleLabel];
                [self addSubview:_lineLabel];
                [self addSubview:_btnCancel];
                [self addSubview:_btnSure];
                [self addSubview:_lineView];
            }
                break;
            default:
                break;
        }
        
        [self.backgroundView addSubview:self];
    }

    return self;
}

- (instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile  andType:(AleartViewType)type 
{
   return [self initWithMsg:msg CancelBtnTitle:cancelBtnTtile andType:type andTitle:nil andIcon:nil andSureBtnTitle:nil];
}

- (instancetype)initWithMsg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile andType:(AleartViewType)type andTitle:(NSString *)title{
    return [self initWithMsg:msg CancelBtnTitle:cancelBtnTtile andType:type andTitle:title andIcon:nil andSureBtnTitle:nil];
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _backgroundView.layer.masksToBounds = YES;
        //加手势
        _backgroundView.userInteractionEnabled = YES;
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)]];
    }
    
    return _backgroundView;
}

- (void)layoutSubviews
{
    CGFloat alertViewWidth = 340;
    CGRect lineRect = CGRectZero;
    CGRect imgRect = CGRectZero;
    CGRect msgRect = CGRectZero;
    CGRect cancelRect = CGRectZero;
    CGRect titleRect = CGRectZero;
    CGRect sureRect = CGRectZero;
    
    if (_img != nil)
    {
        imgRect = CGRectMake(0, 40, alertViewWidth, 80);
    }
    
    titleRect = Rect(35, CGRectGetMaxY(imgRect) + 13, alertViewWidth - 70, [UILabel getHeightByWidth:alertViewWidth title:_title font:_titleLabel.font]);
    
    if (self.aleartViewType == AleartViewType_message_verficationSuccess) {
        msgRect = CGRectMake(35,
                             CGRectGetMaxY(titleRect) + 23,
                             alertViewWidth-70,
                             [UILabel getHeightByWidth:alertViewWidth title:_msg font:_lblMsg.font] + 20);
    }else{
        msgRect = CGRectMake(35,
                             CGRectGetMaxY(imgRect) + 13,
                             alertViewWidth-70,
                             [UILabel getHeightWithText:_msg textFonft:_lblMsg.font screenWidth:alertViewWidth] + 20);
        
    }
    
    
    lineRect =  CGRectMake(0, CGRectGetMaxY(msgRect) + 35,alertViewWidth,0.6);
    
    sureRect = self.aleartViewType == AleartViewType_message_sureAndCancel ? CGRectMake(0, CGRectGetMaxY(msgRect) + 35,alertViewWidth * 0.5,50.6) : CGRectZero;
    
    cancelRect = self.aleartViewType == AleartViewType_message_sureAndCancel ? CGRectMake(sureRect.size.width + 1, CGRectGetMaxY(msgRect) + 35,alertViewWidth * 0.5 - 1,50.6) : CGRectMake(0, CGRectGetMaxY(msgRect) + 35,alertViewWidth,50.6);
    
    _lineView.frame = self.aleartViewType == AleartViewType_message_sureAndCancel ? Rect(sureRect.size.width, CGRectGetMaxY(msgRect) + 35, 1, 50.6) : CGRectZero;
    
    _imgView.frame = imgRect;
    _lblMsg.frame = msgRect;
    _btnCancel.frame = cancelRect;
    _btnSure.frame = sureRect;
    _lineLabel.frame = lineRect;
    _titleLabel.frame = titleRect;
    
    
    CGFloat alertHeight = 0;
    if (self.aleartViewType == AleartViewType_message_cancelBtn) {
        alertHeight =  CGRectGetMaxY(_btnCancel.frame);
    }else if (self.aleartViewType == AleartViewType_message_verficationSuccess || self.aleartViewType == AleartViewType_message_sureAndCancel){
        alertHeight =  CGRectGetMaxY(_btnCancel.frame);
    }else{
        alertHeight = CGRectGetMaxY(_lblMsg.frame) + 40;
    }
    
    self.frame = CGRectMake((_backgroundView.frame.size.width - alertViewWidth) / 2,
                            (_backgroundView.frame.size.height - alertHeight) / 2,
                            alertViewWidth,
                            alertHeight);
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
}

-(void)cancel:(UITapGestureRecognizer *)gesture{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
    }];
    
    if (self.backBlock) {
        self.backBlock(gesture);
    }
    
    [[UIApplication sharedApplication].delegate.window removeGestureRecognizer:_gesture];
}

- (void)clickBtn:(UIButton *)sender
{
    
    if (self.sureClicked) {
        self.sureClicked(sender);
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(alertView:didClickTitle:)])
    {
        [self.delegate alertView:self didClickTitle:[sender titleForState:UIControlStateNormal]];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication].delegate.window removeGestureRecognizer:_gesture];
}

#pragma mark - public method

- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    
    if (self.aleartViewType == AleartViewType_message_noCancelBtn) {
        
        _gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)];
        [[UIApplication sharedApplication].delegate.window addGestureRecognizer:_gesture];

    }
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    } completion:nil];
}


@end
