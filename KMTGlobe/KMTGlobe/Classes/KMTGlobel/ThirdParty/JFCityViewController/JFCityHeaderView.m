//
//  JFCityHeaderView.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityHeaderView.h"

#import "Masonry.h"
#import "JFButton.h"

#define JFRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kCurrentCityInfoDefaults [NSUserDefaults standardUserDefaults]

@interface JFCityHeaderView ()<UISearchBarDelegate>

@property (nonatomic, strong) UILabel *currentCityLabel;
@property (nonatomic, strong) JFButton *button;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic,strong) UIButton  *cancelBtn ;
@property(nonatomic,assign) BOOL  isActive;//searchBar活跃状态

@end

@implementation JFCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSearchBar];
        [self addLabels];
        [self addJFButton];
    }
    return self;
}

- (void)setCityName:(NSString *)cityName {
    self.currentCityLabel.text = cityName;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    self.button.title = buttonTitle;
}

- (void)addSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:Rect(kSpace, 30, ScreenWidth - 70, 28)];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    searchBar.placeholder = @"输入城市名称";
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    searchBar.backgroundColor = kBackgroundColor;
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    
    
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ScreenWidth - 70);
        make.height.offset(28);
        make.top.equalTo(self.mas_top).offset(10);
        make.left.offset(kSpace);
    }];
    
    for (UIView* subview in [[searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            textField.textColor = kCellTextColor;                         //修改输入字体的颜色
            [textField setBackgroundColor:kBackgroundColor];      //修改输入框的颜色
            [textField setValue:kLessGray forKeyPath:@"_placeholderLabel.textColor"];   //修改placeholder的颜色
        } else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
        }
    }
    
    
    //CancelBtn
    wSelf(kself)
    UIButton *btn = [UIButton initWithFrame:Rect(searchBar.right + 10, 8, 60, searchBar.height) andTitle:@"取消" andTitleFont:kCelltextFont andTextColor:kCellTextColor andAction:^(UIButton *btn) {
        if (kself.isActive) {
            [kself cancelSearch];
        }else{
            if (kself.delegate && [kself.delegate respondsToSelector:@selector(headCancelBtnClicked:)]) {
                [kself.delegate headCancelBtnClicked:btn];
            }
        }
    }];
    [btn sizeToFit];
    [self addSubview:btn];
    self.cancelBtn = btn;
    
}


- (void)addLabels {
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = [NSString stringWithFormat:@"当前定位城市:%@",[kCurrentCityInfoDefaults objectForKey:@"locationCity"]?:@"定位中..."];
    currentLabel.textAlignment = NSTextAlignmentLeft;
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:currentLabel];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ScreenWidth);
        make.height.offset(21);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.currentCityLabel = [[UILabel alloc] init];
    _currentCityLabel.textColor  = [UIColor blackColor];
    _currentCityLabel.textAlignment = NSTextAlignmentLeft;
    _currentCityLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_currentCityLabel];
    [_currentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(21);
        make.left.equalTo(currentLabel.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    

}

- (void)addJFButton {
//    self.button = [[JFButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 95, self.frame.size.height - 31, 75, 21)];
//    [_button addTarget:self action:@selector(touchUpJFButtonEnevt:) forControlEvents:UIControlEventTouchUpInside];
//    _button.imageName = @"down_arrow_icon1";
//    _button.title = @"选择区县";
//    _button.titleColor = JFRGBAColor(155, 155, 155, 1.0);
//    [self addSubview:_button];
}

- (void)touchUpJFButtonEnevt:(JFButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageName = @"down_arrow_icon2";
    }else {
        sender.imageName = @"down_arrow_icon1";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityNameWithSelected:)]) {
        [self.delegate cityNameWithSelected:sender.selected];
    }

}

#pragma mark --- UISearchBarDelegate

//// searchBar开始编辑时调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = false;
    searchBar.placeholder = nil;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        for(id cc in [searchBar subviews]) {
            for (id zz in [cc subviews]) {
                if([zz isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)zz;
                    [btn setTitle:@"取消"  forState:UIControlStateNormal];
                    [btn setTitleColor:kCellTextColor forState:UIControlStateNormal];
                    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
                }
            }
        }
    }else{
        for(id cc in [searchBar subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:kCellTextColor forState:UIControlStateNormal];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginSearch)]) {
        [self.delegate beginSearch];
    }
    
    self.isActive = true;
}

// searchBar文本改变时即调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchResult:)]) {
            [self.delegate searchResult:searchText];
        }

    }
}

// 点击键盘搜索按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResult:)]) {
        [self.delegate searchResult:searchBar.text];
    }

    NSLog(@"点击搜索按钮编辑的结果是%@",searchBar.text);
}

//  点击searchBar取消按钮时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelSearch];
}

//  取消搜索
- (void)cancelSearch {
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
    _searchBar.text = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(endSearch)]) {
        [self.delegate endSearch];
    }
    

    self.searchBar.placeholder = @"输入城市名称";
    self.isActive = false;
    
}

@end
