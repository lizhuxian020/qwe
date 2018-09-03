//
//  ZLSheetHead.m
//  ZLActionSheet
//
//  Created by 张雷 on 2016/11/17.
//  Copyright © 2016年 dik. All rights reserved.
//

#import "ZLSheetHead.h"

@implementation ZLSheetHead

- (void)awakeFromNib{
    [super awakeFromNib];
    _headLabel.backgroundColor = [UIColor whiteColor];
    _headLabel.width = ScreenWidth;
    _headLabel.textColor = [UIColor darkGrayColor];
    _headLabel.font = [UIFont systemFontOfSize:16];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
