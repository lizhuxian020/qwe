//
//  UIButton+Block.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/5.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton* btn);

@interface UIButton (Block)

- (void)addAction:(ButtonBlock)block;
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;


@end
