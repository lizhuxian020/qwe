//
//  UIViewController+Alert.m
//  KMMerchant
//
//  Created by 123 on 2016/12/9.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <objc/runtime.h>


@implementation UIAlertAction (YM)

- (void)setIndex:(NSNumber *)index {
    objc_setAssociatedObject(self, @selector(index), index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)index {
    return objc_getAssociatedObject(self, _cmd);
}

@end


@implementation UIViewController (Alert)

- (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles actionHandler:(ActionHanlder)handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSInteger actionsCount = actionTitles.count;
    for (NSInteger i=0; i<actionsCount; i++) {
        NSString *title = actionTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
        action.index = [NSNumber numberWithInteger:i];
        [alertController addAction:action];
    }
    
    UIViewController *presentingController;
    if (self.navigationController) {
        presentingController = self.navigationController;
    } else {
        presentingController = self;
    }
    [presentingController presentViewController:alertController animated:YES completion:^{
        // 什么也不做
    }];
}
@end
