//
//  KMTLabel.m
//  Test
//
//  Created by mac on 18/7/2018.
//  Copyright © 2018 mac. All rights reserved.
//

#import "KMTLabel.h"

@interface KMTLabel()

@property(nonatomic, strong) CJLabel *mainLbl;

@end

@implementation KMTLabel

- (instancetype)initWithWidth:(CGFloat)width
                         text:(NSAttributedString *)text
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                        regex:(NSString *)regex
                       params:(id)params
                     didClick:(CJLabelLinkModelBlock)didClick {
    self = [super init];
    if (self) {
        
        self = [self initWithWidth:width text:text textColor:textColor font:font regexs:@[regex] params:params didClick:didClick];
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width
                         text:(NSAttributedString *)text
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                       regexs:(NSArray<NSString *> *)regexs
                       params:(id)params
                     didClick:(CJLabelLinkModelBlock)didClick {
    self = [super init];
    if (self) {
        
        NSDictionary *dic = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};
        
        NSAttributedString *ms = text;
        for (NSString *regex in regexs) {
            ms = [CJLabelConfigure configureLinkAttributedString:ms
                                                    atRange:[CommonTool validateString:text.string regex:regex]
                                             linkAttributes:dic
                                       activeLinkAttributes:nil
                                                  parameter:nil
                                             clickLinkBlock:^(CJLabelLinkModel *linkModel) {
                                                 didClick(linkModel);
                                             }
                                             longPressBlock:^(CJLabelLinkModel *linkModel) {
                                                 didClick(linkModel);
                                             }
                                                     islink:YES];
        }
        
        
        
        //这里计算单行的时候, 要把width给大一点, 否则会把高度算高了
        CGSize size = [CJLabel sizeWithAttributedString:ms withConstraints:CGSizeMake(width, CGFLOAT_MAX) limitedToNumberOfLines:0];
        CJLabel *lbl = [[CJLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 0)];
        lbl.numberOfLines = 0;
        lbl.attributedText = ms;
        [self addSubview:lbl];
        self.mainLbl = lbl;
        [lbl sizeToFit];
        self.frame = lbl.bounds;
        
    }
    return self;
}

- (void)setBufferMargin:(CGFloat)bufferMargin {
    [self setWidthBuffer:bufferMargin];
    [self setHeightBuffer:bufferMargin];
}

- (void)setWidthBuffer:(CGFloat)bufferMargin {
    if (_mainLbl) {
        CGRect currentFrame = _mainLbl.frame;
        _mainLbl.frame = CGRectZero;
        [_mainLbl sizeToFit];
        if (_mainLbl.width < (currentFrame.size.width + bufferMargin)) {
            //如果在允许范围内
            self.frame = _mainLbl.bounds;
            return;
        }
        
        _mainLbl.frame = currentFrame;
    }
}

- (void)setHeightBuffer:(CGFloat)bufferMargin {
    if (_mainLbl) {
        CGRect currentFrame = _mainLbl.frame;
        _mainLbl.width = _mainLbl.width + bufferMargin;
        [_mainLbl sizeToFit];
        if (_mainLbl.height < (currentFrame.size.width + bufferMargin)) {
            //如果在允许范围内
            self.size = _mainLbl.size;
            return;
        }
        
        _mainLbl.frame = currentFrame;
    }
}

- (void)addRegex:(NSString *)regex
       textColor:(UIColor *)textColor
            font:(UIFont *)font
          params:(id)params
        didClick:(CJLabelLinkModelBlock)didClick {
    NSAttributedString *ori_as = self.mainLbl.attributedText;
    
    NSDictionary *dic = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};
    NSAttributedString *new_as = [CJLabelConfigure configureLinkAttributedString:ori_as
                                            atRange:[CommonTool validateString:ori_as.string regex:regex]
                                     linkAttributes:dic
                               activeLinkAttributes:dic
                                          parameter:nil
                                     clickLinkBlock:^(CJLabelLinkModel *linkModel) {
                                         didClick(linkModel);
                                         
                                     }
                                     longPressBlock:^(CJLabelLinkModel *linkModel) {
                                         didClick(linkModel);
                                     }
                                             islink:YES];
    
    self.mainLbl.attributedText = new_as;
}


@end
