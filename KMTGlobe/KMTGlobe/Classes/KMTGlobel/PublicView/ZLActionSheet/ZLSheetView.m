//
//  ZLSheetView.m
//  ZLActionSheet
//
//  Created by 张雷 on 2016/11/17.
//  Copyright © 2016年 dik. All rights reserved.
//

#import "ZLSheetView.h"
#import "ZLSheetCell.h"

#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)


@interface ZLSheetView()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divLineHeight;

@end

@implementation ZLSheetView

- (void)awakeFromNib{
    [super awakeFromNib];
    _divLineHeight.constant = 0.5;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLSheetCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZLSheetCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZLSheetCell class]) owner:self options:nil].lastObject;
        if (_cellTextColor) {
            cell.myLabel.textColor = _cellTextColor;
        }
    }
    cell.myLabel.text = _dataSource[indexPath.row];
    
    if (_cellTextFont) {
        cell.myLabel.font = _cellTextFont;
    }
    
    if (_cellTextStyle == NSTextStyleLeft) {
        cell.myLabel.textAlignment = NSTextAlignmentLeft;
    } else if (_cellTextStyle == NSTextStyleRight){
        cell.myLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.myLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (_showTableDivLine) {
        cell.divLine.hidden = YES;
        cell.tableDivLine.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    ZLSheetCell *cell = (ZLSheetCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.myLabel.text;

    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle:cellTitle];
    }
}


@end
