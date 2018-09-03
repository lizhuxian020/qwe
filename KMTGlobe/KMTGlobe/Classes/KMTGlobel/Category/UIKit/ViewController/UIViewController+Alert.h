//
//  UIViewController+Alert.h
//  KMMerchant
//
//  Created by 123 on 2016/12/9.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActionHanlder)(UIAlertAction *action);
@interface UIAlertAction (YM)

@property (strong, nonatomic) NSNumber *index;
@end

@interface UIViewController (Alert)

- (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles actionHandler:(ActionHanlder)handler;

@end
