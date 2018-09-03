//
//  ZLSheetFoot.m
//  ZLActionSheet
//
//  Created by 张雷 on 2016/11/17.
//  Copyright © 2016年 dik. All rights reserved.
//

#import "ZLSheetFoot.h"

@implementation ZLSheetFoot

- (void)awakeFromNib{
    [super awakeFromNib];
    _footButton.backgroundColor = [UIColor whiteColor];
    
    [_footButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
}

@end
