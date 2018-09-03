//
//  KMTBaseViewController.m
//  KMDeparture
//
//  Created by 康美通 on 2018/5/31.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTGlobeViewController.h"

typedef void(^itemClickedBlock)(id sender);

@interface KMTGlobeViewController ()
{
    __weak UIView *_noDataView;
    __weak UIView *_networkErrorView;
}
@property(nonatomic,copy) itemClickedBlock itemBlock;
@property(nonatomic, strong) UILabel *netLabel;//网络异常视图

@end

@implementation KMTGlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonViewSet];
    [self createNavigationBarLeftBarButtonItem];
    [self checkNetWorking];
}


/**
 通用页面设置
 */
-(void)commonViewSet{
    self.navigationController.navigationBar.translucent = false;
}

/**
 监测网络状态
 */
-(void)checkNetWorking{
    wSelf(w_self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KMTHttpTool isAvailableToNetworkWithBlock:^(BOOL isAvailable) {
            if (!isAvailable) {
                if ([w_self isKindOfClass:NSClassFromString(@"KMTUserInfoViewController")]) {
                    return ;
                }
                ShowToast(@"网络异常");
            }
        }];
    });
}



#pragma mark -- navi

/**
 创建返回按钮, 基类, 空实现(需要BaseVC去实现)
 */
-(void)createNavigationBarLeftBarButtonItem
{

}


/**
 返回按钮自定义
 */
- (void)resetBackBarButton
{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setBackgroundColor:WHITECOLOR];
    UIImage *backImage = [UIImage imageNamed:@"icon_back"];
    leftBarButton.frame = CGRectMake(0, 0, backImage.size.width + 10, backImage.size.height + 20);
    // [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBarButton setImage:backImage forState:UIControlStateNormal];
    [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftBarButton addTarget:self action:@selector(viewWillBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space_item, item, nil];
}

-(void)addRightBarButtonItem:(UIView *)customView{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;//纠正系统barbuttom偏移10px
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
}

-(void)addRightBarWithImageName:(NSString *)imageName target:(id)target action:(void (^)(id))action{
    self.itemBlock = action;
    UIButton *button = [self getButtnWithImageName:imageName andtitle:nil target:target action:@selector(rightBtnClicked:)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = navLeftButton;
}

-(UIButton *)addRightBarWithTitle:(NSString *)title target:(id)target action:(void (^)(id))action{
    self.itemBlock = action;
    UIButton *button = [self getButtnWithImageName:nil andtitle:title target:target action:@selector(rightBtnClicked:)];
    [button setTitleColor:kTextColorAleartView forState:UIControlStateNormal];
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    navLeftButton.width = 10;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    return button;
}

-(void)rightBtnClicked:(id)sender{
    if (self.itemBlock) {
        self.itemBlock(sender);
    }
}

-(void)addLeftBarWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    UIButton *button = [self getButtnWithImageName:imageName andtitle:nil  target:target action:action];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = navLeftButton;
}

-(UIButton *)getButtnWithImageName:(NSString *)imageName andtitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    barButton.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height + 20);
    [barButton setBackgroundColor:WHITECOLOR];
    if (!imageName) barButton.frame = CGRectMake(0, 0, 60, 40);
    if (imageName)[barButton setImage:image forState:UIControlStateNormal];
    if (title) [barButton setTitle:title forState:UIControlStateNormal];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return barButton;
}

-(void)pushVC:(UIViewController *)viewController{
    [self.view endEditing:true];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)viewWillBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popToRootViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





/**
 判断上级页面类型

 @param VCName viewController名称
 @return true/false;
 */
-(BOOL)superClassIs:(NSString *)VCName{
    return self.navigationController.viewControllers.count >= 2 ? [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:NSClassFromString(VCName)] : false;
}


-(KMTGlobeViewController *)getNavigationVcWithClassName:(NSString *)name{
    __block KMTGlobeViewController *vc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(name)]) {
            vc = obj;
            *stop = YES;
        }
    }];
    return vc;
}

#pragma MARK -- 退出程序
- (void)exitApplication {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id app = [UIApplication sharedApplication].delegate;
        if ([app respondsToSelector:@selector(window)]) {
            UIWindow *window = [app window];
            [UIView animateWithDuration:1.0f animations:^{
                window.alpha = 0;
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            } completion:^(BOOL finished) {
                exit(0);
            }];
        }
    });
}

#pragma MARK -- HUD
-(void)showHUD{
//    [KMTProgressTool show];
}

-(void)showHUDWithStutas:(NSString *)string{
//    [KMTProgressTool showWithStatus:string];
}

-(void)showHUDWithTost:(NSString *)string{
    KSELF
    [self loadNetViewWithText:string];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            kself.netLabel.alpha = 0.0;
            [kself.netLabel removeFromSuperview];
            kself.netLabel = nil;
        }];
    });
}

//提示视图
- (void)loadNetViewWithText:(NSString *)text
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
        _netLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:_netLabel];
       
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

-(void)hideWaiting{
    [KMTProgressTool dismiss];
}

#pragma MARK -- touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:true];
}

#pragma mark -- NoDataView
-(void)showNoMoreDateViewWitTitle:(NSString *)title andSuperView:(UIView *)superView WithType:(NSString *)type{
    [self showNoMoreDateViewWitTitle:title imageName:@"image_no_order" andSuperView:superView WithType:type];
}

-(void)showNoMoreDateViewWitTitle:(NSString *)title imageName:(NSString *)imageName andSuperView:(UIView *)superView WithType:(NSString *)type {
    if (_noDataView && [superView.subviews containsObject:_noDataView]) {
        return;
    }
    UIView *view = [UIView initWithFrame:Rect(0, 0, ScreenWidth, ScreenHeight) backGroundColor:kBackgroundColor];
    UIImage *image = !kIsEmpty(imageName) ? Image(imageName) : Image(@"image_no_order");
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = Rect(0, 0, image.size.width, image.size.height);
    imageView.centerY = view.centerY - 64 - 50 ;
    imageView.centerX = view.centerX;
    [view addSubview:imageView];
    UILabel *noddateLabel= [UILabel initLabelWithFrame:Rect(0, imageView.bottom + 30, view.width, 20) andFont:FONTSIZE(16) andTextColor:kLessGray andBackgroudColor:[UIColor clearColor] andText:title andTextAligment:NSTextAlignmentCenter];
    [view addSubview:noddateLabel];
    _noDataView = view;
    [superView addSubview:view];
}

- (void)showNetworkErrorWithMessage:(NSString *)message SuperView:(UIView *)superView reload:(void(^)(void))reload{
    UIView *view = [UIView initWithFrame:Rect(0, 0, superView.width, superView.height) backGroundColor:kBackgroundColor];
    [superView addSubview:view];
    
    UIImage *image = Image(@"image_no_order");
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.center = view.center;
    [view addSubview:imageView];
    
    UILabel *noddateLabel= [UILabel initLabelWithFrame:CGRectZero andFont:FONTSIZE(16) andTextColor:kLessGray andBackgroudColor:[UIColor clearColor] andText:message andTextAligment:NSTextAlignmentCenter];
    [view addSubview:noddateLabel];
    noddateLabel.numberOfLines = 0;
    noddateLabel.width = superView.width / 2.0;
    [noddateLabel sizeToFit];
    noddateLabel.centerX = view.centerX;
    noddateLabel.y = imageView.bottom + 30;
    
    UIButton *reloadBtn = nil;
    if (reload) {
        reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [reloadBtn setBackgroundColor:kThemeColor];
        [reloadBtn sizeToFit];
        [view addSubview:reloadBtn];
        reloadBtn.centerX = view.centerX;
        reloadBtn.y = noddateLabel.bottom +  30;
        reloadBtn.width = reloadBtn.width + 10;
        [reloadBtn addCornerRadius:reloadBtn.height / 8.0];
        [reloadBtn addAction:^(UIButton *btn) {
            reload();
        }];
    }
    
    CGFloat contentHeight = reloadBtn? reloadBtn.bottom - imageView.y : noddateLabel.bottom - imageView.y;
    CGFloat margin = contentHeight / 2.0 + imageView.y - view.centerY + 10;
    imageView.y = imageView.y - margin;
    noddateLabel.y = noddateLabel.y - margin;
    if (reloadBtn) reloadBtn.y = reloadBtn.y - margin;
    
    _networkErrorView = view;
    
}

-(void)removeFromSuperView:(UIView *)superView {
    [_noDataView removeFromSuperview];
    [_networkErrorView removeFromSuperview];
    if (_noDataView != nil || _networkErrorView != nil) {
        KMTLog(@"still have other reference");
    }
}






@end
