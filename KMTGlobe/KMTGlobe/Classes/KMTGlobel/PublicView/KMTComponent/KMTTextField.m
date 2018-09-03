//
//  KMTTextField.m
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTTextField.h"

#define margin pixelToPoint(30)


@interface KMTTextField()<UITextFieldDelegate> {
    
}
//----------- UI -----------//
//输入框
@property(nonatomic, weak) UITextField *mainTF;

//倒计时Lbl
@property(nonatomic, weak) UILabel *countDownLbl;

//图标
@property(nonatomic, weak) UIImageView *iconView;
//----------- UI_END -----------//


//----------- 倒计时 -----------//
@property(nonatomic, assign) NSInteger second;

@property(nonatomic, copy) NSString *beginStr;

@property(nonatomic, copy) NSString *workingStr;

@property(nonatomic, copy) countDownCallback callback;

@property(nonatomic, weak) NSTimer *cdTimer;

@property(nonatomic, assign) NSInteger count;

@property(nonatomic, copy) clickableTFCallback clickableClb;
//----------- 倒计时_END -----------//


@end

@implementation KMTTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxLength = LONG_MAX;
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font
                 placeHolder:(NSString *)placeHolder {
    self = [self init];
    if (self) {
        [self createMainTFWithFont:font
                       placeHolder:placeHolder
                              icon:nil];
        
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font
                 placeHolder:(NSString *)placeHolder
                        icon:(UIImage *)icon{
    self = [self init];
    if (self) {
        [self createMainTFWithFont:font
                       placeHolder:placeHolder
                              icon:icon];
        
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font
                 placeHolder:(NSString *)placeHolder
          countDownTextColor:(UIColor *)color
                      second:(NSInteger)sec
                    beginStr:(NSString *)beginStr
                  workingStr:(NSString *)workingStr
           didClickCountDown:(countDownCallback)callback {
    self = [self init];
    if (self) {
        
        self.callback = callback;
        self.second = sec;
        self.beginStr = beginStr;
        self.workingStr = workingStr;
        
        [self createMainTFWithFont:font placeHolder:placeHolder icon:nil];
        
        [self createCountDownLblWithFont:font
                      countDownTextColor:color];
    }
    
    return self;
}

- (instancetype)initWithFont:(UIFont *)font
                 placeHolder:(NSString *)placeHolder
                        icon:(UIImage *)icon
          countDownTextColor:(UIColor *)color
                      second:(NSInteger)sec
                    beginStr:(NSString *)beginStr
                  workingStr:(NSString *)workingStr
           didClickCountDown:(countDownCallback)callback {
    self = [self init];
    if (self) {
        
        self.callback = callback;
        self.second = sec;
        self.beginStr = beginStr;
        self.workingStr = workingStr;
        
        [self createMainTFWithFont:font placeHolder:placeHolder icon:icon];
        
        [self createCountDownLblWithFont:font
                      countDownTextColor:color];
    }
    
    return self;
}

- (void)createMainTFWithFont:(UIFont *)font
                 placeHolder:(NSString *)placeHolder
                        icon:(UIImage *)icon{
    //图标
    [self createIconView:icon];
    
    UITextField *mainTF = [UITextField new];
    mainTF.delegate = self;
    mainTF.font = font;
    mainTF.placeholder = placeHolder;
    //在这里定下输入框高度, 刚好与Font相符
    [mainTF sizeToFit];
    [self addSubview:mainTF];
    self.mainTF = mainTF;
    self.mainTF.x = self.iconView ? self.iconView.right + margin : 0;
    
    //设置Container默认高度
    self.height = mainTF.height + margin * 2;
    self.width = self.iconView ? self.iconView.width + margin * 2 + self.mainTF.width : self.mainTF.width;
}

- (void)createIconView:(UIImage *)icon {
    //由于上下留了margin, 就直接放入icon
    if (icon) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:iconView];
        self.iconView = iconView;
    }
}

- (void)createCountDownLblWithFont:(UIFont *)font
                countDownTextColor:(UIColor *)color
{
    UILabel *countDownLbl = [[UILabel alloc] init];
    countDownLbl.font = font;
    [countDownLbl setTextColor:color];
    [countDownLbl setTextAlignment:NSTextAlignmentCenter];
    
    NSString *realWorkingStr = [NSString stringWithFormat:@"%ldS%@", self.second, self.workingStr];
    countDownLbl.text = self.beginStr.length >= realWorkingStr.length ? self.beginStr : realWorkingStr;
    //拿到高度
    [countDownLbl sizeToFit];
    //拿到最长宽度
    CGFloat max_width = countDownLbl.width;
    countDownLbl.text = self.beginStr;
    
    countDownLbl.frame = Rect(self.mainTF.right + margin, self.mainTF.top, max_width, countDownLbl.height);
    [self addSubview:countDownLbl];
    self.countDownLbl = countDownLbl;
    
    //调整Container的宽度
    self.width = self.mainTF.width + margin + self.countDownLbl.width;
    
    //添加倒计时响应事件
    self.countDownLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick)];
    [self.countDownLbl addGestureRecognizer:tap];
}

+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder {
    return [[KMTTextField alloc] initWithFont:font
                                  placeHolder:placeHolder];
}

+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
               countDownTextColor:(UIColor *)color
                           second:(NSInteger)sec
                         beginStr:(NSString *)beginStr
                       workingStr:(NSString *)workingStr
                didClickCountDown:(countDownCallback)callback {
    return [[KMTTextField alloc] initWithFont:font
                                  placeHolder:placeHolder
                           countDownTextColor:color
                                       second:sec
                                     beginStr:beginStr
                                   workingStr:workingStr
                            didClickCountDown:callback];
}

+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
                             icon:(UIImage *)icon
               countDownTextColor:(UIColor *)color
                           second:(NSInteger)sec
                         beginStr:(NSString *)beginStr
                       workingStr:(NSString *)workingStr
                didClickCountDown:(countDownCallback)callback {
    return [[KMTTextField alloc] initWithFont:font
                                  placeHolder:placeHolder
                                         icon:icon
                           countDownTextColor:color
                                       second:sec
                                     beginStr:beginStr
                                   workingStr:workingStr
                            didClickCountDown:callback];
}

+ (instancetype)textFieldWithFont:(UIFont *)font
                      placeHolder:(NSString *)placeHolder
                             icon:(UIImage *)icon {
    return [[KMTTextField alloc] initWithFont:font placeHolder:placeHolder icon:icon];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.mainTF.keyboardType = keyboardType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTF.centerY = self.height / 2.0;
    self.countDownLbl.centerY = self.mainTF.centerY;
    self.iconView.centerY = self.mainTF.centerY;
    if (!self.countDownLbl && !self.iconView) {
        self.mainTF.width = self.width;
    }
    if (self.countDownLbl && !self.iconView) {
        self.mainTF.width = self.width - self.countDownLbl.width - margin;
        self.countDownLbl.x = self.mainTF.right + margin;
    }
    if (self.countDownLbl && self.iconView) {
        self.mainTF.width = self.width - self.countDownLbl.width - margin * 3 - self.iconView.width;
        self.countDownLbl.x = self.mainTF.right + margin;
    }
 
}

- (void)didClick {
    wSelf(w_self);
    //只有存在callback,并且返回值为false时候不作为
    if (self.clickableClb && !self.clickableClb(w_self)) {
        return;
    }
    
    if (self.callback) self.callback(w_self);
}

#pragma mark --公开方法

- (void)startCountDown {
    if (!self.cdTimer && self.countDownLbl) {
        wSelf(w_self);
        _count = self.second;
        _count--;
        self.countDownLbl.text = KMTStrFormat(@"%ldS%@", _count, self.workingStr);
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:w_self selector:@selector(countDown1) userInfo:nil repeats:YES];
        self.cdTimer = timer;
    }
}

- (void)countDown1 {
    _count--;
    if (_count == -1) {
        [self.cdTimer invalidate];
        self.countDownLbl.text = self.beginStr;
        _count = self.second;
        return;
    }
    self.countDownLbl.text = KMTStrFormat(@"%ldS%@", _count, self.workingStr);
}

- (void)setClickable:(clickableTFCallback)block {
    if (self.countDownLbl) self.clickableClb = block;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString *result = KMTStrFormat(@"%@%@", textField.text, string);
    if (result.length > self.maxLength) {
        textField.text = [result substringToIndex:self.maxLength];
        return NO;
    }
    return YES;
}


#pragma mark --GET
- (NSString *)workingStr {
    return _workingStr ? _workingStr : @"";
}

- (NSString *)content {
    return self.mainTF.text;
}

- (void)setContent:(NSString *)content {
    self.mainTF.text = content;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
