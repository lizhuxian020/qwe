//
//  CDSProgressView.h
//  YBLPageController
//
//  Created by YBL on 2018/6/8.
//  Copyright © 2018年 YBL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSProgressView : UIView
/** 进度条 */
@property (nonatomic, assign) CGFloat progress;
/** 尺寸 */
@property (nonatomic, strong) NSMutableArray *itemFrames;
/** 颜色 */
@property (nonatomic, assign) CGColorRef color;
/** 是否拉伸 */
@property (nonatomic, assign) BOOL isStretch;
@end
