//
//  KMTLine.m
//  KMDeparture
//
//  Created by mac on 20/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTLine.h"


@implementation KMTLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kLineColor;
    }
    return self;
}

+ (instancetype)lineAtView:(UIView *)view frame:(CGRect)frame {
    KMTLine *line = [[KMTLine alloc] initWithFrame:frame];
    [view addSubview:line];
    return line;
}

@end
