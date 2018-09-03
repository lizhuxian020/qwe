//
//  ShowPayMoneyPWDView.m
//  KMMerchant
//
//  Created by 康美通 on 17/2/8.
//  Copyright © 2017年 KMT. All rights reserved.
//

#import "ShowPayMoneyPWDView.h"


@interface ShowPayMoneyPWDView ()<UITextFieldDelegate, TXTradePasswordViewDelegate>
@property (nonatomic, strong) UIView            *bgView;//背景

@property (nonatomic, strong) UIView            *headView;

@property (nonatomic, strong) UIView            *contentView;

@property (nonatomic, strong) NSString          *titleStr;//标题


@property (nonatomic, strong) NSString          *yuanAmount;//支付金额（元）

@property (nonatomic, strong) NSString          *yuanFee;//手续费（元）

@property (nonatomic, strong) UIView            *amountView;




@end

@implementation ShowPayMoneyPWDView
-(instancetype)initWithPayAmount:(NSString *)amount fee:(NSString *)fee{
   
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    if (self) {
        self.titleStr = @"请输入支付密码";
        if ([amount isEqualToString:@"修改银行卡信息需要验证支付密码"]) {
            self.yuanAmount = amount;
        }else{
            self.yuanAmount = [YMTool convertFenBalanceToYuanJiaoFenWithBalance:amount];
        }
        
        NSInteger fengFee = [fee integerValue];
        if (fengFee==0) {
            self.yuanFee = @"0";
        }else{
            self.yuanFee = [YMTool convertFenBalanceToYuanJiaoFenWithBalance:fee];
        }

        [self addSubview:self.bgView];
        // 监听键盘的相关通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - click

-(void)show{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; 
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [self addSubview:self.contentView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }];
}

-(void)dismiss{
    if(!self.superview) {
        return;
    }
    [self.inputView resignFirstResponder];
    
    CGRect contentFrame = self.contentView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.backgroundColor = [UIColor clearColor];
        self.contentView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, contentFrame.size.height);
        self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight);
    } completion:^(BOOL finished) {
        if (@available(iOS 9.0, *)) {
            if (finished) {
                for (UIView *vi in self.subviews) {
                    [vi removeFromSuperview];
                }
                [self removeFromSuperview];
            }
        }
      
    }];
}


-(void)close{
    if (self.clickCloseBlock) {
        self.clickCloseBlock();
    }
    [self endEditing:YES];
    [self dismiss];
}

#pragma mark - notification
- (void)keyBoardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat addHeight = 180;
        if (kMainScreenWidth== 320 ) {
            addHeight = 160;
        }else if (kMainScreenWidth == 375 ){
            addHeight = 170;
        }
        self.contentView.frame = CGRectMake(0, kMainScreenHeight-kbHeight-45-addHeight, kMainScreenWidth, 45+addHeight);
    }];
}

-(void)keyBoardWillHidden:(NSNotification *)noti{
    [self dismiss];
}

#pragma mark - delegate
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password{
    
    [self.inputView.TF resignFirstResponder];
    [self dismiss];
    
    self.completeBlock(Password);
    
}



#pragma setting/getting

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)]];
        _bgView.alpha = 0.35;
    }
    return _bgView;
}


-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.headView];
        [_contentView addSubview:self.inputView];
        [_contentView addSubview:self.amountView];
    }
    
    return _contentView;
}


-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        //关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame     = CGRectMake(0, 5, 60, 35);
        [closeBtn setImage:[UIImage imageNamed:@"recharge_cancel"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:closeBtn];
        
        //标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, closeBtn.top, kMainScreenWidth-120, 35)];
        titleLabel.text          = self.titleStr;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor     = kAccountTextColor;
        titleLabel.font          = YMFontSize(20);
        [_headView addSubview:titleLabel];
        //横线
        UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45-1, kMainScreenWidth, 0.5)];
        hLine.backgroundColor = YMRGBValue(0xbdbdbd);
        [_headView addSubview:hLine];
    }
    return _headView;
}


-(TXTradePasswordView *)inputView{
     // wSelf(kself)
    if (!_inputView) {
     _inputView = [[TXTradePasswordView alloc]initWithFrame:Rect(0, self.amountView.height + 20, kMainScreenWidth, 60) WithTitle:@""];
        _inputView.TXTradePasswordDelegate = self;
        
        [_inputView.TF becomeFirstResponder];
        
        KMTLog(@"%d",[_inputView.TF canBecomeFirstResponder]);
        
//        _inputView.endBlock = ^(UITextField *tf, NSString *string) {
//             kself.completeBlock(string);
//        };

    }
    return _inputView;
}


- (UIView *)amountView{
    if (!_amountView) {
        _amountView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom, kMainScreenWidth, 75)];
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _amountView.width, _amountView.height*0.6)];
        amountLabel.font = [UIFont systemFontOfSize:31];
        amountLabel.textColor = [UIColor orangeColor];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        if ([self.yuanAmount isEqualToString:@"修改银行卡信息需要验证支付密码"]) {
             amountLabel.text = self.yuanAmount;
             amountLabel.font = YMFontSize(16);
        }else{
             amountLabel.text = [NSString stringWithFormat:@"￥%@",self.yuanAmount];
        }
       
        [_amountView addSubview:amountLabel];
        
        UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, amountLabel.bottom, _amountView.width, _amountView.height*0.3)];
        feeLabel.font = [UIFont systemFontOfSize:14];
        feeLabel.textColor = [UIColor blackColor];
        feeLabel.textAlignment = NSTextAlignmentCenter;
        feeLabel.text = [NSString stringWithFormat:@"手续费：￥%@",self.yuanFee];

        //如果没有手续费则不显示
        if ([self.yuanFee isEqualToString:@"0"]) {
            //将金额放在中间
            amountLabel.frame = CGRectMake(0, 0, _amountView.width, _amountView.height);
        }else{
            [_amountView addSubview:feeLabel];
        }
    }

    return _amountView;
}




@end
