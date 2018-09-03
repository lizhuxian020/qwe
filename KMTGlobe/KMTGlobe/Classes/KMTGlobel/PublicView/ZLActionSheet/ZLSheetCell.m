//
//  ZLSheetCell.m
//  ZLActionSheet
//
//  Created by 张雷 on 2016/11/17.
//  Copyright © 2016年 dik. All rights reserved.
//

#import "ZLSheetCell.h"

@interface ZLSheetCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableDivLineHeight;
@end

@implementation ZLSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _divLineHeight.constant = 0.5;
    _tableDivLineHeight.constant = 0.5;
    _myLabel.backgroundColor = [UIColor whiteColor];
    _myLabel.textColor = [UIColor lightTextColor];
    _myLabel.font = [UIFont systemFontOfSize:16];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
