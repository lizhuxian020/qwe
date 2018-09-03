//
//  KMTView.h
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTView : UIView

- (BOOL)isShowingTopBorder;
- (BOOL)isShowingBottomBorder;
- (BOOL)isShowingLeftBorder;
- (BOOL)isShowingRightpBorder;

- (void)showTopBorder;
- (void)showBottomBorder;
- (void)showLeftBorder;
- (void)showRightBorder;

@end
