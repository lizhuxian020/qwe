//
//  KMTHomeBottomBtn.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTHomeBottomBtn.h"

@implementation KMTHomeBottomBtn

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 10;
    self.titleLabel.y = 35;
    self.titleLabel.centerX = self.width * 0.5;
}
@end
