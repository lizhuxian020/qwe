//
//  KMTProgressTool.m
//  KMDeparture
//
//  Created by 康美通 on 2018/6/1.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTProgressTool.h"
#import "SVProgressHUD.h"

#define progressShareTool  [KMTProgressTool shareProgressTool]

@interface KMTProgressTool()
{
    UILabel     *_netLabel;
}
@property (nonatomic, copy) progreCcompletionBlock completion;
@property (nonatomic, assign) SVProgressHUDMaskType defaultMaskType;
@end

@implementation KMTProgressTool

+(instancetype)shareProgressTool{
    static KMTProgressTool *progressTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressTool = [[KMTProgressTool alloc]init];
    });
    return progressTool;
}


+ (void)show
{
    [self showWithStatus:nil];
}

+ (void)showWithIsProgressHUDMaskTypeBlack:(BOOL)isProgressHUDMaskTypeBlack
{
    SVProgressHUDMaskType maskType = SVProgressHUDMaskTypeNone;
    if (isProgressHUDMaskTypeBlack) {
        maskType = KMTProgressToolBackgroundIsBlack;
    }
    [progressShareTool showWithStatus:nil maskType:maskType];
}

+ (void)showWithStatus:(NSString *)status
{
    [progressShareTool showWithStatus:status maskType:KMTProgressToolBackgroundIsBlack];
}

+ (void)showWithStatus:(NSString *)status isProgressHUDMaskTypeBlack:(BOOL)isProgressHUDMaskTypeBlack
{
    if(isProgressHUDMaskTypeBlack){
        [progressShareTool showWithStatus:status maskType:KMTProgressToolBackgroundIsBlack];
    }else{
        [progressShareTool showWithStatus:status maskType:SVProgressHUDMaskTypeNone];
    }
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [self showInfoWithStatus:status completion:nil];
}

+ (void)showInfoWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    [progressShareTool showInfoWithStatus:status completion:completion];
}

+ (void)dismiss
{
    [self dismissWithCompletion:nil];
}

+ (void)dismissWithCompletion:(progreCcompletionBlock)completion
{
    [progressShareTool dismissWithCompletion:completion];
}

+ (void)showError
{
    [self showErrorWithStatus:nil completion:nil];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [self showErrorWithStatus:status completion:nil];
}

+ (void)showErrorWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    [progressShareTool showErrorWithStatus:status completion:completion];
}

+ (void)showSuccess
{
    [self showSuccessWithStatus:nil completion:nil];
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [self showSuccessWithStatus:status completion:nil];
}

+ (void)showSuccessWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    [progressShareTool showSuccessWithStatus:status completion:completion];
}

+ (BOOL)isVisible
{
    return [SVProgressHUD isVisible];
}

+ (void)showHUDWithTost:(NSString *)string{
    [progressShareTool showTost:string onView:nil];
}

+(void)showHUDWithTost:(NSString *)string onSpecialView:(UIView *)view{
    [progressShareTool showTost:string onView:view];
}

#pragma mark - -方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerNotifications];
        self.defaultMaskType = KMTProgressToolBackgroundIsBlack;
        [SVProgressHUD setMaximumDismissTimeInterval:3.];
    }
    return self;
}

- (void)dealloc
{
    [self unRegisterNotifications];
}

- (void)registerNotifications
{
    [kNotificationCenter addObserver:self
                            selector:@selector(handleNotification:)
                                name:SVProgressHUDDidDisappearNotification
                              object:nil];
}

- (void)unRegisterNotifications
{
    [kNotificationCenter removeObserver:self];
}

- (void)handleNotification:(NSNotification *)notif
{
    if ([notif.name isEqualToString:SVProgressHUDDidDisappearNotification]) {
        if (self.completion) {
            self.completion();
        }
    }
}

- (void)showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultMaskType:maskType];
}

- (void)showInfoWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultMaskType:self.defaultMaskType];
    if (completion) completion();
}

- (void)dismissWithCompletion:(progreCcompletionBlock)completion
{
    self.completion = completion;
    [SVProgressHUD dismiss];
}

- (void)showErrorWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    self.completion = completion;
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setDefaultMaskType:self.defaultMaskType];
}

- (void)showSuccessWithStatus:(NSString *)status completion:(progreCcompletionBlock)completion
{
    self.completion = completion;
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setDefaultMaskType:self.defaultMaskType];
}

#pragma mark -- tost
-(void)showTost:(NSString *)string onView:(UIView *)view{
    [self loadNetViewWithText:string onView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            _netLabel.alpha = 0.0;
            [_netLabel removeFromSuperview];
            _netLabel = nil;
        }];
    });
}
//提示视图
- (void)loadNetViewWithText:(NSString *)text onView:(UIView *)view
{
    if (!text || [text isKindOfClass:[NSNull class]]) {
        return;
    }
    if (!_netLabel) {
        _netLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4.0, ScreenHeight/2 - 22, ScreenWidth/2.0, 44)];
        _netLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _netLabel.layer.cornerRadius = 4.0;
        _netLabel.layer.masksToBounds = YES;
        _netLabel.alpha = 1.0;
        _netLabel.textAlignment = NSTextAlignmentCenter;
        _netLabel.numberOfLines = 0;
        _netLabel.textColor = [UIColor whiteColor];
        _netLabel.font = [UIFont systemFontOfSize:15];
        
        if (view) {
            [view addSubview:_netLabel];
        }else{
            [KEY_WINDOW addSubview:_netLabel];
        }
    }
    _netLabel.text = text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_netLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGFloat width =  [_netLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width+10;
    if (width > ScreenWidth) {
        width = ScreenWidth - 40;
    }
    _netLabel.width = width;
    _netLabel.center = CGPointMake(ScreenWidth/2.0, _netLabel.center.y);
}

@end
