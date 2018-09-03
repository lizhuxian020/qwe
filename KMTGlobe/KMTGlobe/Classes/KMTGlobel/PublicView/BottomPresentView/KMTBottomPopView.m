//
//  KMTBottomPopView.m
//  KMDeparture
//
//  Created by 康美通 on 2018/6/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBottomPopView.h"
#import "HXTagsView.h"
#import "PayPresentView.h"
#import "LYSDatePickerController.h"

#define titleTopViewHeight 46
static NSString * const askAddTimeError = @"预计送达时间输入有误，请重新输入!";
static NSString * const askAddOrderAmountError = @"订单金额输入有误，请重新输入!";

@interface KMTBottomPopView()<UITextFieldDelegate,HXTagsViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIView *blackView;
@property(nonatomic,strong)UIView *cotentView;
@property(nonatomic,assign)CGRect frame;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UITextField *timeTF;
@property(nonatomic,strong)UITextField *orderAmountTF;
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* orderAmount;
@property(nonatomic,strong)NSArray *tagArray;
@property(nonatomic,strong)HXTagsView *tagView;
@property(nonatomic,strong)UIView *titleTopView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *selectDateSource;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong) NSArray  *categryArray ;//包裹类型
@end

@implementation KMTBottomPopView

-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type andTimetext:(NSString *)time andOrderAmount:(NSString *)amount andProblemArray:(NSArray *)problem andIsAskeType:(KMTBottomBtnAskType)askType
{
    
    return [self initWithPopViewType:type andTimetext:time andOrderAmount:amount andProblemArray:problem andIsAskeType:askType andBalance:nil];
}


-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type andTimetext:(NSString *)time andOrderAmount:(NSString *)amount andProblemArray:(NSArray *)problem andIsAskeType:(KMTBottomBtnAskType)askType andBalance:(NSString *)balance{
    if (self = [super init]) {
        switch (type) {
            case KMTBottomPopViewType_birthday:
            {
                self.title = @"备注信息";
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - 300, ScreenWidth, 300) andType:askType];
                
            }
                break;
            case KMTBottomPopViewType_sexchnage:
            {
                self.title = @"";
            }
                break;
            case KMTBottomPopViewType_receiptTime:
            {
                self.title = @"收件时间";
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - 254, ScreenWidth, 254) andType:0];
            }
                break;
            case KMTBottomPopViewType_packageategory:
            {
                self.title = @"包裹品类";
                _categryArray = problem;
                CGFloat height = 75 + (44 * problem.count/3) + 50;
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - height, ScreenWidth, height) andType:0];
            }
                break;
            case KMTBottomPopViewType_remarksInformation:
            {
                self.title = @"备注信息";
                _categryArray = problem;
                _time = time;
                CGFloat height = 34 + 46 + (44 * problem.count/3) + 50 + 44;
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - height, ScreenWidth, height) andType:0];
            }
                break;
            case KMTBottomPopViewType_askAdd:
            {
                self.title = @"商议价格";
                _time = time;
                _orderAmount = amount;
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - 215, ScreenWidth, 215) andType:askType];
            }
                break;
            case KMTBottomPopViewType_cancelPickup:
            {
                self.title = @"取消寄件";
                _tagArray = problem;
                _time = time;
                _orderAmount = amount;
                [self createBasePopViewWithFrame:Rect(0, ScreenHeight - 225, ScreenWidth, 225) andType:askType];
            }
                break;
            case KMTBottomPopViewType_Pay:
            {
                [self createPayViewWithBalance:balance];
            }
                break;
            default:
                break;
        }
    }
    return self;
}



-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type andTimetext:(NSString *)time andOrderAmount:(NSString *)amount andIsAskeType:(KMTBottomBtnAskType)askType{
    return [self initWithPopViewType:type andTimetext:time andOrderAmount:amount andProblemArray:nil andIsAskeType:askType];
}

-(instancetype)initWithPopViewType:(KMTBottomPopViewType)type{
    return [self initWithPopViewType:type andTimetext:nil andOrderAmount:nil andProblemArray:nil andIsAskeType:0];
}

-(instancetype)initWithPopViewProblemArray:(NSArray *)contentArray popViewType:(KMTBottomPopViewType)type;{
    return [self initWithPopViewType:type andTimetext:nil andOrderAmount:nil andProblemArray:contentArray andIsAskeType:0];
}

-(instancetype)initWithPopViewProblemArray:(NSArray *)contentArray popViewType:(KMTBottomPopViewType)type andText:(NSString *)text{
    return [self initWithPopViewType:type andTimetext:text andOrderAmount:nil andProblemArray:contentArray andIsAskeType:0];
}


-(void)createPayViewWithBalance:(NSString *)balance{
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.userInteractionEnabled = YES;
    [blackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewClicked)]];
    blackView.tag = 440;
    self.frame = Rect(0, ScreenHeight - 354, ScreenWidth, 354);
    self.blackView = blackView;
    UIView *shareView = [[UIView alloc]initWithFrame:Rect(0, 0, ScreenWidth, 354)];
    PayPresentView *payView = [[NSBundle mainBundle]loadNibNamed:@"PayPresentView" owner:self options:0].firstObject;
    payView.frame = shareView.frame;
    payView.amountLabel.text = [NSString stringWithFormat:@"%@元",[YMTool convertFenBalanceToYuanJiaoFenWithBalance:balance]];
    [payView.wechatBtn addAction:^(UIButton *btn) {
        //        [btn setImage:Image(@"order_icon_selected") forState:UIControlStateNormal];
        //        if (self.selectPayBlock) self.selectPayBlock(PayType_WXPAY);
        //        [self dissmiss];
        ShowToast(@"请暂时使用余额支付");
    }];
    
    [payView.aliPayBtn addAction:^(UIButton *btn) {
        //        [btn setImage:Image(@"order_icon_selected") forState:UIControlStateNormal];
        //        if (self.selectPayBlock) self.selectPayBlock(PayType_ALIPAY);
        //        [self dissmiss];
        ShowToast(@"请暂时使用余额支付");
    }];
    
    [payView.kangmeiPayBtn addAction:^(UIButton *btn) {
        if (balance.floatValue == 0) {
            ShowToast(@"支付金额为0时请使用余额支付");
            return ;
        }
        [btn setImage:Image(@"order_icon_selected") forState:UIControlStateNormal];
        if (self.selectPayBlock) self.selectPayBlock(PayType_KMPAY);
        [self dissmiss];
    }];
    
    [payView.balanceBtn addAction:^(UIButton *btn) {
        [btn setImage:Image(@"order_icon_selected") forState:UIControlStateNormal];
        if (self.selectPayBlock) self.selectPayBlock(PayType_YEP);
        [self dissmiss];
    }];
    
    
    [shareView addSubview:payView];
    shareView.tag = 441;
    self.cotentView = shareView;
    
}


/**
 通用view元素设置
 
 @param frame frame
 */
-(void)createBasePopViewWithFrame:(CGRect)frame andType:(KMTBottomBtnAskType)type{
    KSELF
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.userInteractionEnabled = YES;
    [blackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewClicked)]];
    blackView.tag = 440;
    self.blackView = blackView;
    self.frame = frame;
    UIView *shareView = [[UIView alloc]initWithFrame:frame];
    shareView.tag = 441;
    self.cotentView = shareView;
    
    UIView *titleTopView = [[UIView alloc]initWithFrame:Rect(0, 0, ScreenWidth, titleTopViewHeight)];
    titleTopView.backgroundColor = RGB(247, 247, 247);
    __weak typeof(self) wself = self;
    UIButton *cancelBtn = [UIButton initWithFrame:Rect(10, 0, 50, titleTopView.height) andTitle:@"取消" andTitleFont:FONTSIZE(14) andTextColor:[UIColor orangeColor] andAction:^(UIButton *btn) {
        [self dissmiss];
        if (wself.btnBlock) wself.btnBlock(btn, false);
    }];
    self.titleTopView = titleTopView;
    UIButton *sureBtn = [UIButton initWithFrame:Rect(ScreenWidth - 60, 0, 50,titleTopView.height) andTitle:@"确定" andTitleFont:FONTSIZE(14) andTextColor:[UIColor grayColor] andAction:^(UIButton *btn) {
        
        __block UIButton *itemBtn;
        for (UIButton *btn in self.selectDateSource) {
            if (btn.selected) {
                itemBtn = btn;
            }
        }
        if (itemBtn || (self.textView.text && ![self.textView.text isEqualToString:@"请留言给快递小哥"])) {
            if (itemBtn) {
                if (wself.sureCancleBlock) wself.sureCancleBlock([NSMutableArray arrayWithObject:itemBtn], [self.textView.text isEqualToString:@"请留言给快递小哥"] ? @"" : self.textView.text);
            }else{
                if (wself.sureCancleBlock) wself.sureCancleBlock(nil, [self.textView.text isEqualToString:@"请留言给快递小哥"] ? @"" : self.textView.text);
            }
            [wself dissmiss];
        }else{
            ShowToast(@"请选择包裹品类");
        }
        
    }];
    UILabel *titleLabel = [UILabel initLabelWithFrame:Rect(0, 0, ScreenWidth - sureBtn.width * 2 + 20, titleTopView.height) andFont:FONTSIZE(14) andTextColor:RGB(73, 73, 73) andBackgroudColor:nil andText:self.title andTextAligment:NSTextAlignmentCenter];
    titleLabel.centerX = titleTopView.centerX;
    [titleTopView addSubview:titleLabel];
    shareView.backgroundColor = [UIColor clearColor];
    
    if ([self.title isEqualToString:@"商议价格"]) {
        
        UIView *cellView = [UIView initWithFrame:Rect(0, titleTopViewHeight, ScreenWidth, 106) backGroundColor:WHITECOLOR];
        UIView *cellLine = [UIView drawLineView:1];
        cellLine.y = 53;
        [cellView addSubview:cellLine];
        
        UILabel *timeLabel = [UILabel initWithLabe:Rect(15, 0, 110, 53) title:@"预计取件时间：" backgroundColor:WHITECOLOR font:FONTSIZE(15) textColor:kCellTextColor];
        UILabel *orderAmountLabel = [UILabel initWithLabe:Rect(15, 54, 110, 52) title:@"订单金额：" backgroundColor:WHITECOLOR font:FONTSIZE(15) textColor:kCellTextColor];
        orderAmountLabel.textAlignment = NSTextAlignmentRight;
        UITextField *tf_time = [[UITextField alloc]initWithFrame:Rect(timeLabel.right + 15, 0, ScreenWidth - 30 - 15 - timeLabel.width, 53)];
        tf_time.backgroundColor = WHITECOLOR;
        tf_time.text = _time;
        tf_time.delegate = self;
        self.timeTF = tf_time;
        UITextField *tf_amount = [[UITextField alloc]initWithFrame:Rect(timeLabel.right + 15, 54, ScreenWidth - 30 - 15 - timeLabel.width, 52)];
        tf_amount.backgroundColor = WHITECOLOR;
        tf_amount.delegate = self;
        tf_amount.keyboardType = UIKeyboardTypeDecimalPad;
        tf_amount.text = _orderAmount;
        self.orderAmountTF = tf_amount;
        [cellView addSubview:tf_time];
        [cellView addSubview:tf_amount];
        [cellView addSubview:timeLabel];
        [cellView addSubview:orderAmountLabel];
        [self.cotentView addSubview:cellView];
        
        
        UIView *ButtonView = [UIView initWithFrame:Rect(0, cellView.bottom + 10, ScreenWidth, 55) backGroundColor:WHITECOLOR];
        UIView *btnView = [UIView drawVerticalLineView:Rect(ScreenWidth * 0.5, 0, 0.5, ButtonView.height)];
        __weak typeof(self) kself = self;
        UIButton *cancelBtn = [UIButton initWithFrame:Rect(0, 0, ScreenWidth * 0.5, ButtonView.height) andTitle:@"取消" andTitleFont:FONTSIZE(16) andTextColor:kLessGray andAction:^(UIButton *btn) {
            if (type == KMTBottomBtnAskType_alreadyAskd) {
                if (kself.askBlock) {
                    kself.askBlock(tf_time.text, tf_amount.text);
                }
            }
            [kself blackViewClicked];
            [kself dissmiss];
        }];
        
        UIButton *topBtn = [UIButton initWithFrame:Rect(ScreenWidth * 0.5 + 1, 0, ScreenWidth * 0.5, ButtonView.height) andTitle:@"提交" andTitleFont:FONTSIZE(16) andTextColor:kMainYellow andAction:^(UIButton *btn) {
            
            if (!tf_time.text || [tf_time.text isEqualToString:@""]) {
                ShowToast(askAddTimeError);
                return ;
            }
            
            if (!tf_amount.text || [tf_amount.text isEqualToString:@""]) {
                ShowToast(askAddOrderAmountError);
                return;
            }
            
            [kself blackViewClicked];
            
            if (kself.askBlock) {
                kself.askBlock(tf_time.text, tf_amount.text);
            }
            [kself dissmiss];
        }];
        
        switch (type) {
            case KMTBottomBtnAskType_normal:
            {
                [ButtonView addSubview:cancelBtn];
                [ButtonView addSubview:topBtn];
                [ButtonView addSubview:btnView];
            }
                break;
            case KMTBottomBtnAskType_alreadyAskd:
            {
                cancelBtn.frame = Rect(0, 0, ScreenWidth, ButtonView.height);
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [ButtonView addSubview:cancelBtn];
            }
                break;
            default:
                break;
        }
        
        [self.cotentView addSubview:ButtonView];
        
    }else if([self.title isEqualToString:@"取消寄件"]){
        
        UIView *cellView = [UIView initWithFrame:Rect(0, titleTopViewHeight, ScreenWidth, 124) backGroundColor:WHITECOLOR];
        [self.cotentView addSubview:cellView];
        
        UIView *ButtonView = [UIView initWithFrame:Rect(0, cellView.bottom + 10, ScreenWidth, 45) backGroundColor:WHITECOLOR];
        UIView *btnView = [UIView drawVerticalLineView:Rect(ScreenWidth * 0.5, 0, 0.5, ButtonView.height)];
        
        UIButton *cancelBtn = [UIButton initWithFrame:Rect(0, 0, ScreenWidth * 0.5, ButtonView.height) andTitle:@"暂不取消" andTitleFont:FONTSIZE(16) andTextColor:kLessGray andAction:^(UIButton *btn) {
            [wself dissmiss];
        }];
        
        UIButton *topBtn = [UIButton initWithFrame:Rect(ScreenWidth * 0.5 + 1, 0, ScreenWidth * 0.5, ButtonView.height) andTitle:@"确认取消" andTitleFont:FONTSIZE(16) andTextColor:kMainYellow andAction:^(UIButton *btn) {
            
            
            if (wself.selectDateSource.count == 0 && [wself.textView.text isEqualToString:@"请详细输入您遇到的问题（300字以内）"]) {
                ShowToast(@"请选择或者输入取消原因！");
                return ;
            }
            
            if (![wself.textView.text isEqualToString:@"请详细输入您遇到的问题（300字以内）"] ) {
                [self.selectDateSource removeAllObjects];
            }
            
            if (kself.sureCancleBlock) {
                kself.sureCancleBlock(wself.selectDateSource,wself.textView.text);
            }
            [wself dissmiss];
            
        }];
        
        //tagView
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:Rect(0, 0, cellView.width, cellView.height)];
        scrollView.delegate = self;
        scrollView.scrollEnabled = false;
        self.scrollView = scrollView;
        
        HXTagsView *tagView = [[HXTagsView alloc]initWithFrame:Rect(0, 0, cellView.width, cellView.height)];
        tagView.tagHeight = 31;
        tagView.tagOriginX = 15;
        tagView.tagOriginY = 25;
        tagView.tagHorizontalSpace = 10;
        tagView.tagVerticalSpace = 13;
        tagView.normalBackgroundImage = [UIImage imageWithColor:kBackgroundColor];
        tagView.highlightedBackgroundImage = [UIImage imageWithColor:kMainYellow];
        [tagView setTagAry:_tagArray Block:^(NSInteger index, NSString *title, UIButton *sender) {
            KMTLog(@"%ld%@",index,title);
            sender.selected = !sender.selected;
            if (sender.selected && sender.tag != 106) {
                [sender setBackgroundImage:[UIImage imageWithColor:kMainYellow] forState:UIControlStateSelected];
                [sender setTitleColor:WHITECOLOR forState:UIControlStateSelected];
            }else{
                [sender setBackgroundImage:[UIImage imageWithColor:kBackgroundColor] forState:UIControlStateNormal];
                [sender setTitleColor:kLessGray forState:UIControlStateNormal];
            }
            
            if ([title isEqualToString:@" 其他问题 "]) {
                [UIView animateWithDuration:0.4 animations:^{
                    scrollView.contentOffset = CGPointMake(cellView.width, 0);
                }];
            }else{
                [self checkBtnIsSelected:sender];
            }
            KMTLog(@"%@",self.selectDateSource);
            
        }];
        self.tagView = tagView;
        [self tagsViewButtonAction:tagView button:nil];
        [scrollView addSubview:tagView];
        
        UIView *tfView = [UIView initWithFrame:Rect(tagView.width, 0, cellView.width, cellView.height) backGroundColor:WHITECOLOR];
        UITextView *textView = [[UITextView alloc]initWithFrame:Rect(15, 10, cellView.width - 30, cellView.height - 20)];
        textView.text = @"请详细输入您遇到的问题（300字以内）";
        //        textView.scrollEnabled = false;
        textView.alwaysBounceVertical = YES;
        textView.spellCheckingType = .0;
        textView.autocorrectionType = .0;
        textView.delegate = self;
        textView.layer.borderWidth = 1;
        textView.font = FONTSIZE(14);
        textView.textColor = kLessGray;
        //        textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        textView.layer.cornerRadius = 6;
        textView.layer.borderColor = kLessGray.CGColor;
        textView.layer.masksToBounds = YES;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.layoutManager.allowsNonContiguousLayout = false;
        [tfView addSubview:textView];
        self.textView = textView;
        [scrollView addSubview:tfView];
        
        scrollView.contentSize = CGSizeMake(tfView.width + tagView.width, cellView.height);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = false;
        [cellView addSubview:scrollView];
        [ButtonView addSubview:cancelBtn];
        [ButtonView addSubview:topBtn];
        [ButtonView addSubview:btnView];
        [self.cotentView addSubview:ButtonView];
        
    }else if ([self.title isEqualToString:@"包裹品类"]){
        shareView.backgroundColor = [UIColor whiteColor];
        [titleTopView addSubview:cancelBtn];
        [titleTopView addSubview:sureBtn];
        HXTagsView *tagView = [self createTagesViewWithFrame:Rect(0, 46, ScreenWidth, frame.size.height)];
        [shareView addSubview:tagView];
    }else if ([self.title isEqualToString:@"备注信息"]){
        shareView.backgroundColor = [UIColor whiteColor];
        [titleTopView addSubview:cancelBtn];
        [titleTopView addSubview:sureBtn];
        UITextView *textView = [[UITextView alloc]initWithFrame:Rect(15, 49 + 16, ScreenWidth - 30, 44)];
        textView.text = _time ? _time : @"请留言给快递小哥";
        //        textView.scrollEnabled = false;
        textView.alwaysBounceVertical = YES;
        textView.spellCheckingType = .0;
        textView.autocorrectionType = .0;
        textView.delegate = self;
        textView.font = FONTSIZE(14);
        textView.textColor = kLessGray;
        //        textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        textView.layer.cornerRadius = 6;
        textView.backgroundColor = kBackgroundColor;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.layoutManager.allowsNonContiguousLayout = false;
        [shareView addSubview:textView];
        self.textView = textView;
        
        HXTagsView *tagView = [self createTagesViewWithFrame:Rect(0, textView.bottom, ScreenWidth, frame.size.height)];
        [shareView addSubview:tagView];
        
    }else if ([self.title isEqualToString:@"取件时间"]){
        shareView.backgroundColor = [UIColor whiteColor];
        [titleTopView addSubview:cancelBtn];
        [titleTopView addSubview:sureBtn];
        
    }else{
        shareView.backgroundColor = [UIColor whiteColor];
        [titleTopView addSubview:cancelBtn];
        [titleTopView addSubview:sureBtn];
        
    }
    [self.cotentView addSubview:titleTopView];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)checkBtnIsSelected:(UIButton *)sender{
    if (sender.selected) {
        [self.selectDateSource addObject:sender];
    }else{
        NSMutableArray *btnArray = self.selectDateSource;
        NSArray *tempArray = [NSArray arrayWithArray:btnArray];
        for (UIButton *obj in tempArray) {
            if (sender == obj) {
                [btnArray removeObject:obj];
            }
        }
    }
    
}


- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    // 输入框上移
    [UIView animateWithDuration:0.1 animations:^ {
        CGRect frame = self.cotentView.frame;
        frame.origin.y = ScreenHeight - (frame.size.height + keyboardRect.size.height);
        self.cotentView.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    /* 输入框下移 */
    [UIView animateWithDuration:0.1 animations:^ {
        CGRect frame = self.cotentView.frame;
        frame.origin.y = ScreenHeight - 215;
        self.cotentView.frame = frame;
    }];
    
}


-(void)showViewWithdismissBlock:(dismissBlock)block{
    [self showTopView];
    _btnBlock = block;
}

-(void)showViewWithaskAddBlock:(askAddBlock)block{
    [self showTopView];
    _askBlock = block;
}

-(void)showViewSureCancel:(sureCancelBlock)block{
    [self showTopView];
    _sureCancleBlock = block;
}

-(void)showViewSelectPayCancel:(selectPayBlock)block{
    [self showTopView];
    _selectPayBlock = block;
}

#pragma mark -------- pay


-(void)showTopView{
    [KEY_WINDOW.rootViewController.view addSubview:self.blackView];
    [KEY_WINDOW.rootViewController.view addSubview:self.cotentView];
    self.cotentView.y = ScreenHeight;
    self.blackView.alpha = 0;
    __block CGRect frame = self.frame;
    wSelf(tself)
    [UIView animateWithDuration:0.35f animations:^{
        tself.blackView.alpha = 0.35;
        tself.cotentView.y = frame.origin.y;
    }];
}

-(void)dissmiss{
    UIView *blackView = [KEY_WINDOW viewWithTag:440];
    UIView *shareView = [KEY_WINDOW viewWithTag:441];
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        shareView.y = ScreenHeight;
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
}

-(void)blackViewClicked{
    [self.timeTF resignFirstResponder];
    [self.orderAmountTF resignFirstResponder];
    
    [self dissmiss];
}

#pragma mark -- UITextfieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.timeTF) {
        [self createTimeSelector];
        return false;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL flag = [YMTool formartInputMoney:textField.text inputCharacter:string];
    return flag;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

#pragma mark -------- 时间选择器
-(void)createTimeSelector{
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
    datePicker.headerView.backgroundColor = kBackgroundColor;
    datePicker.indicatorHeight = 0;
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = kCellTextColor;
    datePicker.headerView.leftItem.itemView.x = 15;
    datePicker.headerView.rightItem.textColor = kMainYellow;
    datePicker.pickHeaderHeight = 46;
    datePicker.pickType = LYSDatePickerTypeDayAndTime;
    datePicker.minuteLoop = YES;
    datePicker.headerView.showTimeLabel = NO;
    datePicker.headerView.centerItem = nil;
    datePicker.showWeakDay = false;
    [datePicker setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        self.timeTF.text = currentDate;
    }];
    [datePicker showDatePickerWithController:KEY_WINDOW.rootViewController];
}

#pragma mark -- textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return  false;
    }
    
    if (range.location > 50) {
        return false;
    }
    
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = kCellTextColor;
    return YES;
}

#pragma mark -- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIImage *backImage = [UIImage imageNamed:@"order_icon_back"];
    UIButton *backBtn = [UIButton initWithFrame:Rect(15, 0, backImage.size.width + 15, self.titleTopView.height) andImage:@"order_icon_back" andSelectImage:@"order_icon_back" andTitle:nil andTitleFont:nil andTextColor:nil andBackGroundColor:kBackgroundColor andBackgroundImage:nil andAction:^(id sender) {
        [UIView animateWithDuration:0.4 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            [sender removeFromSuperview];
        }];
    }];
    if (scrollView.contentOffset.x > 0) {
        [self.titleTopView addSubview:backBtn];
        
    }else{
        [backBtn removeFromSuperview];
        //        self.textView.text = nil;
    }
    
}

#pragma mark -------- UI
-(HXTagsView *)createTagesViewWithFrame:(CGRect)frame{
    HXTagsView *tagView = [[HXTagsView alloc]initWithFrame:frame];
    tagView.tagHeight = 31;
    tagView.tagOriginX = 15;
    tagView.tagOriginY = 25;
    tagView.tagHorizontalSpace = 20;
    tagView.tagVerticalSpace = 13;
    tagView.normalBackgroundImage = [UIImage imageWithColor:kBackgroundColor];
    tagView.highlightedBackgroundImage = [UIImage imageWithColor:kMainYellow];
    [tagView setTagAry:_categryArray Block:^(NSInteger index, NSString *title, UIButton *btn) {
        [self.selectDateSource addObject:btn];
        btn.selected = !btn.selected;
        for (UIButton *obj in self.selectDateSource) {
            if (obj != btn) {
                obj.selected = false;
            }
            
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageWithColor:kMainYellow] forState:UIControlStateSelected];
                [btn setTitleColor:WHITECOLOR forState:UIControlStateSelected];
            }else{
                [btn setBackgroundImage:[UIImage imageWithColor:kBackgroundColor] forState:UIControlStateNormal];
                [btn setTitleColor:kLessGray forState:UIControlStateNormal];
            }
            
        }
        
    }];
    return tagView;
}


#pragma mark -- TagViewDelegate
-(void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender{
    UIButton *senderFirst = [tagsView viewWithTag:101];
    senderFirst.selected = YES;
    [senderFirst setBackgroundImage:[UIImage imageWithColor:kMainYellow] forState:UIControlStateSelected];
    [senderFirst setTitleColor:WHITECOLOR forState:UIControlStateSelected];
    [self checkBtnIsSelected:senderFirst];
}

-(NSMutableArray *)selectDateSource{
    if (_selectDateSource == nil) {
        _selectDateSource = [[NSMutableArray alloc]init];
    }
    return _selectDateSource;
}

@end
