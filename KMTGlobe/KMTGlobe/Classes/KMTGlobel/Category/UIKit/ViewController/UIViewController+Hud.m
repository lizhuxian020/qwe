//
//  UIViewController+Hud.m
//  KMMerchant
//
//  Created by 123 on 2016/10/25.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import "UIViewController+Hud.h"
#import "MBProgressHUD.h"

@implementation UIViewController (Hud)
- (void)showInfo:(NSString *)info {
    UIView *parentView = [self getHudSuperView];
    
    // 隐藏
    [self hideOtherHudsOnView:parentView];
    
    //然后再显示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.labelText = info;
    hud.margin = 12.f;
}

- (void)showOnlyPromptInfo:(NSString *)info {
    UIView *parentView = [self getHudSuperView];
    
    // 隐藏
    [self hideOtherHudsOnView:parentView];
    
    // 然后再显示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = info;
    hud.margin = 8.f;
    
    // 再隐藏
    [hud hide:YES afterDelay:2.0f];
}

- (void)showCustomInfo:(NSString *)info withImage:(NSString *)imageName {
    UIView *parentView = [self getHudSuperView];
    // 隐藏
    [self hideOtherHudsOnView:parentView];
    // 再显示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = info;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    // 再隐藏
    [hud hide:YES afterDelay:2.0f];
}

- (void)showInfo:(NSString *)info duration:(CGFloat)duration withExecutingBlock:(void (^)(void))block completionBlock:(void (^)(void))completionBlock {
    UIView *parentView = [self getHudSuperView];
    // 隐藏
    [self hideOtherHudsOnView:parentView];
    // 再显示
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = info;
    hud.margin = 12.f;
    [hud showAnimated:YES whileExecutingBlock:^{
        if (block) {
            block();
        }
        sleep(duration);
        
    } completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }
     ];
}

- (void)dismiss {
    UIView *parentView = [self getHudSuperView];
    
    // 由于在某个视图上显示时,确保了只有一个hud,所以隐藏时只需要隐藏一个
    MBProgressHUD *hud = [MBProgressHUD HUDForView:parentView];
    if (hud) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }
}

#pragma mark - assist
- (UIView *)getHudSuperView {
    UIView *parentView = nil;
    if (self.tabBarController) {
        parentView = self.view;
    } else {
        parentView = ((KMTGlobeNavigationController *)self.navigationController).view;
    }
    return parentView;
}

- (void)hideOtherHudsOnView:(UIView *)hudsParentView{
    // 显示前应判断当前视图上是否有正在显示的,如果有将其删除
    NSArray *huds = [MBProgressHUD allHUDsForView:hudsParentView];
    if (huds && huds.count != 0) {
        [MBProgressHUD hideAllHUDsForView:hudsParentView animated:YES];
    }
}


@end
