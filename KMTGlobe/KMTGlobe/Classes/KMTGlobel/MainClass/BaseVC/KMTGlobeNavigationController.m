//
//  KMTNavigationController.m
//  KMDeparture
//
//  Created by 康美通 on 2018/5/31.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTGlobeNavigationController.h"


@interface KMTGlobeNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation KMTGlobeNavigationController

+ (void)initialize {
    if (self == [self class]) {
        [self setNavigationBar];
    }
}

+ (void)setNavigationBar {
    UINavigationBar *apperance = [UINavigationBar appearance];
    [apperance setShadowImage:[UIImage new]];
    UIImage *navBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor] andSize:Size(ScreenWidth, UI_NAVIGATION_BAR_STATUS_BAR_HEIGHT)];
    [apperance setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}







@end
