//
//  YMTool.m
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//   xxxxx

#import "YMTool.h"
#import <objc/runtime.h>
#include "iconv.h"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "KMTSetPayPWViewController.h"
//#import "BindCardViewController.h"
//#import "KMTVerifiedViewController.h"
//#import "Mehandler.h"



@class UIStatusBar;

@implementation YMTool


+ (YMAlertView *)alertMessageWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate {
    YMAlertView *alertView = [[YMAlertView alloc] initWithMessage:message buttonTitles:buttonTitles delegate:delegate];
    NSArray *subViews = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[YMAlertView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    [alertView show];
    
    return alertView;
}

//当前控制器在显示状态才弹框
+ (YMAlertView *)alertMessageWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles delegate:(id<YMAlertViewDelegate>) delegate  showViewController:(UIViewController *)showViewController{
    if ([YMTool isCurrentViewControllerVisible:showViewController]) {
        YMAlertView *alertView = [[YMAlertView alloc] initWithMessage:message buttonTitles:buttonTitles delegate:delegate];
        NSArray *subViews = [UIApplication sharedApplication].keyWindow.subviews;
        for (UIView *subView in subViews) {
            if ([subView isKindOfClass:[YMAlertView class]]) {
                [subView removeFromSuperview];
                break;
            }
        }
        [alertView show];
        
        return alertView;
    }
    return nil;
}

//是否是当前显示控制器
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}


+ (void)drawDashLineInView:(UIView *)superView startPoint:(CGPoint)startP endPoint:(CGPoint)endP {
        CAShapeLayer *dotLayer = [CAShapeLayer layer];

        // 设置填充,绘制的颜色 线宽  拼接处的连接样式
        [dotLayer setFillColor:[[UIColor clearColor] CGColor]];
        [dotLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
        [dotLayer setLineWidth:1.0f];
        [dotLayer setLineJoin:kCALineJoinRound];
        
        // lineWidth=每个短线的长度 lineSpace=每两条短线的间距
        int lineWidth = 10;
        int lineSpace = 5;
        [dotLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],[NSNumber numberWithInt:lineSpace],nil]];
        
        //设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, startP.x, startP.y);
        CGPathAddLineToPoint(path, NULL, endP.x,endP.y);
        [dotLayer setPath:path];
        
        CGPathRelease(path);
        [superView.layer addSublayer:dotLayer];
}

+ (void)timerCountDownWith:(NSInteger)time titleChangedButton:(UIButton *)sender {
        __block NSInteger timeout=time; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                   // NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"重新发送"];
                   // [sender setAttributedTitle:str forState:UIControlStateNormal];
                    //[sender setTitleColor:kButtonEnableColor forState:UIControlStateNormal];
                    [sender setTitle:@"重新发送" forState:UIControlStateNormal];
                  //  [sender setTitleColor:kButtonEnableColor forState:UIControlStateNormal];
                     sender.enabled = YES;
                });
            }else{
                NSInteger seconds = timeout % 61;
                NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *titleString = [NSString stringWithFormat:@"%@S",strTime];
//                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleString];
//                    [str addAttribute:NSForegroundColorAttributeName value:kButtonEnableColor range:NSMakeRange(0,str.length-4)];
//                     [str addAttribute:NSForegroundColorAttributeName value:kCellTextColor range:NSMakeRange(str.length-4,4)];
                   // sender setTitleColor:kCellTextColor forState:<#(UIControlState)#>
                    
                    [sender setTitle:titleString forState:(UIControlStateNormal)];
                    sender.enabled = NO;
                });
             timeout--;
            }
        });
        dispatch_resume(_timer);
}





// 正则表达式判断手机号码是否有效
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum{
    if (phoneNum.length!=11) {
        return NO;
    }
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [pred evaluateWithObject:phoneNum];
    return isValid;
}

// 正则表达式判断邮箱是否有效
+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 正则表达式判断是否输入的是数字
+ (BOOL)isNumber:(NSString *)number{
  NSString *regex = @"[0-9]+";
  NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
   BOOL isNumber = [pred evaluateWithObject:number];
    return isNumber;
}

//判断密码是否由数字与字母构成,并长度大于等于6位小于等于20位
+ (BOOL)isValidPassword:(NSString *)password{
    BOOL result = NO;
    if ([password length] >= 6 && [password length] <= 20 ){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}

// 是否个人银行卡号
+ (BOOL) isValidPersonalBankCardNum:(NSString *)bankCardNum
{
    NSString *bankCardRegex = @"^[0-9]{16,19}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankCardRegex];
    return [pre evaluateWithObject:bankCardNum];
    
}

//判断姓名是否只由中文组成
+ (BOOL)validateName:(NSString *)name {
    BOOL result = NO;
    NSString *regex = @"^[\u4e00-\u9fa5]{2,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:name];
    
    return result;
}

//是否身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//获取*字符串
+ (NSString *)getStarWithStinng:(NSString *)string Number:(NSInteger)number{
    NSRange range0 = NSMakeRange(0, 1);
    NSRange range1 = NSMakeRange(3, 4);
    NSRange range2 = NSMakeRange(3, 11);
  
    if(number == 0){
        if (string.length>0) {
            string = [string stringByReplacingCharactersInRange:range0 withString:@"*"];
        }
    }else if(number == 1){
        if (string.length>6) {
            string = [string stringByReplacingCharactersInRange:range1 withString:@"****"];
        }
    }else if(number == 2){
        if (string.length>13) {
            string = [string stringByReplacingCharactersInRange:range2 withString:@"*************"];
        }
    }
    return string;
}

//将邮箱第1位至@符号前全部置换为字符串**
+(NSString *)veilEmail:(NSString *)emailStr{
    NSString *veilEmail;
    NSArray *sepArr = [emailStr componentsSeparatedByString:@"@"];
    NSString *firstStr = sepArr[0];
    if (firstStr.length>1) {
        veilEmail = [emailStr stringByReplacingCharactersInRange:NSMakeRange(1, firstStr.length-1) withString:@"**"];
    }else{
        veilEmail = emailStr;
    }
    return veilEmail;
}




+ (BOOL)formartInputMoney:(NSString *)inputMoney inputCharacter:(NSString *)inputCharacter {
   
    NSString *characters = @".0123456789";   //金额中只能包含的字符
    NSString *numberSet  = @"0123456789";    //数字集合
    
    //如果输入的字符非以上字符，禁止输入
    if ([characters rangeOfString:inputCharacter].location != NSNotFound || [inputCharacter isEqualToString:@""]) {
        //判断是否包含.
        NSRange dotRange = [inputMoney rangeOfString:@"."];
        if (dotRange.location != NSNotFound) {
            //已输入.
            if ([inputCharacter isEqualToString:@"."]) {
                return NO;
            } else if (inputMoney.length >= dotRange.location + 3 && [numberSet rangeOfString:inputCharacter].location != NSNotFound) {
               return NO;
            }
        } else {
            if (inputMoney.length >= 6 && [numberSet rangeOfString:inputCharacter].location != NSNotFound) {
                return NO;
            }
        }
    }else {
        return NO;
    }
 
    return YES;
}

//把金额从以分为单位转换为xx元xx角xx分的形式  123分 -> 1.23元
+ (NSString *)convertFenBalanceToYuanJiaoFenWithBalance:(NSString *)balance {
    NSString *balanceStr = nil;
    if (balance) {
        NSInteger yuanBalance = [balance integerValue] / 100;  //元
        NSInteger jiaoBalance = [balance integerValue] /10 %10; //角
        NSInteger fenBalance  = [balance integerValue] % 10;    //分

     balanceStr = [NSString stringWithFormat:@"%ld.%ld%ld", yuanBalance, jiaoBalance, fenBalance];
   }
    return balanceStr;
}

//把金额从以元为单位转换为xx分的形式
+ (NSInteger)convertYuanBalanceToFenWithBalance:(NSString *)balance {
    NSInteger yuanBalance = 0, jiaoBalance = 0, fenBalance = 0;
    
    NSUInteger dotLoc =[balance rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        //表示有小数点,
        if (dotLoc == 0) {
            //在第一位
            yuanBalance = 0;
        } else {
            yuanBalance = [[balance substringToIndex:dotLoc] integerValue];
        }
        
        //如果小数点后有2位
        if (dotLoc + 3 == balance.length) {
            jiaoBalance = [[balance substringWithRange:NSMakeRange(dotLoc +1, 1)] integerValue];
            fenBalance  = [[balance substringWithRange:NSMakeRange(dotLoc +2, 1)] integerValue];
        } else if (dotLoc + 2 == balance.length){
            //如果小数点后有1位
             jiaoBalance = [[balance substringWithRange:NSMakeRange(dotLoc +1, 1)] integerValue];
             fenBalance = 0;
        } else if (dotLoc + 1 == balance.length) {
            jiaoBalance = 0;
            fenBalance  = 0;
        }
       
       return yuanBalance * 100 + jiaoBalance * 10 + fenBalance;
        
    } else {
        yuanBalance = [balance integerValue];
        return yuanBalance * 100;
    }
}

//给一串字符串按每单位长度添加指定的字符
+ (NSString *)appendCharacters:(NSString *)addedStr WithUnitLength:(NSInteger)unitLength inAppendingStr:(NSString *)appendingStr {
    
    NSInteger units = 0;  //定义指定字符串的长度中含有的指定单位长度的个数
    
    //计算指定的字符串按指定的长度可以分为多少段
    NSInteger appendingStrLength = appendingStr.length;
    if (appendingStrLength % unitLength == 0) {
        units = appendingStrLength / unitLength;
    } else {
        units = appendingStrLength / unitLength + 1;
    }
    
    NSString *appededStr = @"";
    if (appendingStrLength % unitLength == 0) {
        for (NSInteger i = 0; i < units; i++) {
           NSString *subStr = [appendingStr substringWithRange:NSMakeRange(i*unitLength, unitLength)];
            appededStr = [appededStr stringByAppendingString:subStr];
            if (i != units - 1) {
             appededStr = [appededStr stringByAppendingString:addedStr];
            }
        }
    } else {
        for (NSInteger i = 0; i < units -1; i++) {
            NSString *subStr = [appendingStr substringWithRange:NSMakeRange(i*unitLength, unitLength)];
            appededStr = [appededStr stringByAppendingString:subStr];
            appededStr = [appededStr stringByAppendingString:addedStr];
        }
        NSString *endStr = [appendingStr substringFromIndex:(units -1) * unitLength];
        appededStr = [appededStr stringByAppendingString:endStr];
    }
    
    return appededStr;
}

//去掉银行卡中的空格
+ (NSString *)trimBankCard:(NSString *)bankCardNum {
    NSString *trimmingStr = [bankCardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return trimmingStr;
}

//根据交易类型的英文转换为中文
+ (NSString *)convertTradingTypeToChieseFromEnglishTradingType:(NSString *)tradingType {
    if ([tradingType isEqualToString:@"TRADE"]) {
        return @"在线支付";
    } else if ([tradingType isEqualToString:@"RETRD"]) {
        return @"重复交易";
    } else if ([tradingType isEqualToString:@"WITHDRAW"]) {
        return @"提现";
    } else if ([tradingType isEqualToString:@"WITHDRAW_RFD"]) {
        return @"提现退款";
    }else if ([tradingType isEqualToString:@"RECHARGE"]) {
        return @"充值";
    }else if ([tradingType isEqualToString:@"TRANSFER"]) {
        return @"转账到康美钱包";
    }else if ([tradingType isEqualToString:@"BANKTRANS"]) {
        return @"转账到银行卡";
    }else if ([tradingType isEqualToString:@"DFPAY"]) {
        return @"代付";
    }else if ([tradingType isEqualToString:@"ALTIN"]) {
        return @"调入";
    }else if ([tradingType isEqualToString:@"ALTOUT"]) {
        return @"调出";
    }else if ([tradingType isEqualToString:@"PREPAR"]) {
        return @"头寸备付";
    }else if ([tradingType isEqualToString:@"ADJUST"]) {
        return @"科目调账";
    }else if ([tradingType isEqualToString:@"ALLOT"]) {
        return @"调拨";
    }else if ([tradingType isEqualToString:@"AUTHEN"]) {
        return @"认证";
    }else if([tradingType isEqualToString:@"REFUND"]) {
        return @"退款";
    }else if([tradingType isEqualToString:@"REDPKG"]) {
        return @"康美红包";
    }else if([tradingType isEqualToString:@"NBNKTRANS"]) {
        return @"转账到康美钱包";
    }else if([tradingType isEqualToString:@"REDPKGBACK"]){
        return @"红包退款";
    }else if([tradingType isEqualToString:@"CREDITPAY"]){
        return @"信用卡还款";
    }else if([tradingType isEqualToString:@"MOBILERHG"]){
        return @"话费充值";
    }else if([tradingType isEqualToString:@"FUND"]){
        return @"代扣";
    }else if([tradingType isEqualToString:@"EXPENSE"]){
        return @"借支";
    }else if([tradingType isEqualToString:@"MOBILEFLOWRHG"]){
        return @"流量充值";
    }else if([tradingType isEqualToString:@"LIFEPAY"]){
        return @"生活缴费";
    }else if([tradingType isEqualToString:@"PENALTY"]){
        return @"违章代缴";
    }else if([tradingType isEqualToString:@"KMZHYS"]){
        return @"在线支付";
    }else if([tradingType isEqualToString:@"KMZHYSFEE"]){
        return @"在线支付";
    }else {
        return @"";
    }
}


//将银行卡类型转化为中文
+(NSString *)changeChineseTypeWithCardType:(NSString *)cardType{
    NSString *chineseType;
    if ([cardType isEqualToString:@"DEBIT"]) {
        chineseType = @"储蓄卡";
    }else if ([cardType isEqualToString:@"CREDIT"]){
        chineseType = @"信用卡";
    }else if ([cardType isEqualToString:@"BOTH"]){
        chineseType = @"借贷卡";
    }
    return chineseType;
}

//过滤NSNull类型的对象
+(NSDictionary *)safeDictionaryWithDic:(NSDictionary *)dic{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mutableDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null] || obj == nil) {
            [mutableDic removeObjectForKey:key];
            [mutableDic setObject:@"" forKey:key];
        }
    }];
    return [[NSDictionary alloc] initWithDictionary:mutableDic];
}

//判断是否含拼音
+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}



+(NSString *)getTime:(NSString *)time{
    if (time.length == 0) {
        return @"";
    }
    // 把时间戳转换为NSString型的时间
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval _interval=[time doubleValue] / 1000.0;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:_interval];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)getHanziTime:(NSString *)time{
    // 把时间戳转换为NSString型的时间
    NSString *timeSubstr = [time substringWithRange:NSMakeRange(0, 10)];

    NSArray *b = [timeSubstr componentsSeparatedByString:@"-"];
    NSMutableString *arr = [NSMutableString string];
    for (NSInteger i = 0; i < b.count; i++) {
        if(i==0){
            [arr appendString:[NSString stringWithFormat:@"%@年",b[i]]];
        }else if(i==1){
            [arr appendString:[NSString stringWithFormat:@"%@月",b[i]]];
        }else if(i==2){
            [arr appendString:[NSString stringWithFormat:@"%@日 ",b[i]]];
        }
    }
    [arr appendString:[time substringWithRange:NSMakeRange(11, 5)]];
    return arr;
}

+(NSString *)getHanziYearMonthTime:(NSString *)time{
    // 把时间戳转换为NSString型的时间
    NSString *timeSubstr = [time substringWithRange:NSMakeRange(0, 10)];
    
    NSArray *b = [timeSubstr componentsSeparatedByString:@"-"];
    NSMutableString *arr = [NSMutableString string];
    for (NSInteger i = 0; i < b.count; i++) {
        if(i==0){
            [arr appendString:[NSString stringWithFormat:@"%@年",b[i]]];
        }else if(i==1){
            [arr appendString:[NSString stringWithFormat:@"%@月",b[i]]];
        }else if(i==2){
            [arr appendString:[NSString stringWithFormat:@"%@日 ",b[i]]];
        }
    }
   // [arr appendString:[time substringWithRange:NSMakeRange(11, 5)]];
    return arr;
}

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

//输入字符串转星期
+ (NSString*)weekdayStringFromDateString:(NSString*)dateString{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *inputDate =[dateFormat dateFromString:dateString];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}



+ (NSString *)getCurrentStandarTimeWithxiegang{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}



+(NSString *)arabicNumeralsToChinese:(int)number{
    
    switch (number) {
        case 0:
            return @"零";
            break;
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
        case 8:
            return @"八";
            break;
        case 9:
            return @"九";
            break;
        case 10:
            return @"十";
            break;
        case 11:
            return @"十一";
            break;
        case 12:
            return @"十二";
            break;
        case 100:
            return @"百";
            break;
        case 1000:
            return @"千";
            break;
        case 10000:
            return @"万";
            break;
        case 100000000:
            return @"亿";
            break;
        default:
            return nil;
            break;
    }
}


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+(void)customerService{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://400-6600-518"]]];
    
}


/**
 * 数字转罗马
 */
+ (NSString *)toRoman:(int)num {
    NSString *roman = @"";
    if (num > 0 && num < 100) {
        
        NSArray *pChars = [[NSArray alloc]initWithObjects: @"L", @"X", @"V", @"I",  nil];
        NSArray *pValues = [[NSArray alloc]initWithObjects:@"50",@"10" , @"5", @"1" ,  nil];
        
        
        while (num > 0) {
            if (num >= 90) {
                roman = [roman stringByAppendingString:@"XC"];
                num -= 90;
                continue;
            }
            
            if (num >= [[pValues objectAtIndex:0] intValue]) {
                NSString *string = [NSString stringWithFormat:@"%@",[pChars objectAtIndex:0]];
                roman = [roman stringByAppendingString:string];
                num -= [[pValues objectAtIndex:0] intValue];
                continue;
            }
            if (num >= 40) {
                roman = [roman stringByAppendingString:@"XL"];
                
                num -= 90;
                continue;
            }
            if (num >= [[pValues objectAtIndex:1] intValue]) {
                int x10 = num /[[pValues objectAtIndex:1] intValue];
                for (int i = 0; i < x10; i++) {
                    
                    NSString *string = [NSString stringWithFormat:@"%@",[pChars objectAtIndex:1]];
                    roman = [roman stringByAppendingString:string];
                    num -= [[pValues objectAtIndex:1] intValue];
                }
                continue;
            }
            if (num >= 9) {
                roman = [roman stringByAppendingString:@"IX"];
                
                num -= 9;
                continue;
            }
            if (num >= [[pValues objectAtIndex:2] intValue]) {
                
                NSString *string = [NSString stringWithFormat:@"%@",[pChars objectAtIndex:2]];
                roman = [roman stringByAppendingString:string];
                num -= [[pValues objectAtIndex:2] intValue];
                continue;
            }
            if (num == 4) {
                roman = [roman stringByAppendingString:@"IV"];
                num = 0;
                continue;
            }
            for (int i = 0; i < num; i++) {
                NSString *string = [NSString stringWithFormat:@"%@",[pChars objectAtIndex:3]];
                roman = [roman stringByAppendingString:string];
                
                num -= [[pValues objectAtIndex:3] intValue];
            }
        }
    } else {
        NSLog(@"数字超出范围！");
    }
    return roman;  
}

/**
 *  切换label关键字颜色
 *
 *  @param label 传入文本框
 *  @param color 颜色值
 */
+ (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    NSString *labelStr = label.text; //初始化string为传入label.text的值
    NSString * kNumber =@"0123456789.";//创建一个字符串过滤参数,decimalDigitCharacterSet为过滤小数,过滤某个关键词,只需改变 decimalDigitCharacterSet类型  在将此方法增加一个 NSString参数即可
    NSCharacterSet *numberSet = [[NSCharacterSet characterSetWithCharactersInString:kNumber]invertedSet];
    NSString *stringRange = [labelStr stringByTrimmingCharactersInSet:numberSet];//获取过滤出来的数值
    NSRange range = [labelStr rangeOfString:stringRange];//获取过滤出来的数值的位置
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];//创建一个带属性的string
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];//给带属性的string添加属性,attrubute:添加的属性类型（颜色\文字大小\字体等等）,value:改变成的属性参数,range:更改的位置
    label.attributedText = attrStr;//将 attstr 赋值给label带属性的文本框属性
    /**
     以下为NSCharacterSet的过滤类型:
     controlCharacterSet; //控制符
     whitespaceCharacterSet; //空格
     whitespaceAndNewlineCharacterSet; //空格和换行符
     decimalDigitCharacterSet; //小数
     letterCharacterSet; //文字
     lowercaseLetterCharacterSet; //小写字母
     uppercaseLetterCharacterSet; //大写字母
     nonBaseCharacterSet; //非基础
     alphanumericCharacterSet; //字母数字
     decomposableCharacterSet; //可分解
     illegalCharacterSet; //非法
     punctuationCharacterSet; //标点
     capitalizedLetterCharacterSet; //大写
     symbolCharacterSet; //符号
     newlineCharacterSet; //换行符
     */
}



//根据bankcode获得bankname
+ (NSString *)getBankNameWithBankCode:(NSString *)bankCode{
    NSString *bankName;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BankCardBGColor" ofType:@"plist"];
    NSArray *bankCardBGColorsArr = [[NSArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *dic in bankCardBGColorsArr) {
        NSString *bankCardCode = [dic jsonString:@"bankCode"];
        
        if ([bankCardCode isEqualToString:bankCode.lowercaseString]) {
            bankName = [dic jsonString:@"bankName"];
            break;
            
        }
    }
    
    return bankName;
}



+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



//当大于1000M时，将流量中M转化为G，小于时不变
+ (NSString *)transformGwithM:(NSString *)m{
    NSString *transformDataStr;
    if ([m integerValue]) {
        if ([m integerValue]>=1000) {
            //取整数
           NSInteger g = [m integerValue]/1000;
            transformDataStr = [NSString stringWithFormat:@"%ldG",g];
            
        }else{
            transformDataStr = [NSString stringWithFormat:@"%@M",m];
        }
    }else{
        transformDataStr = nil;
    }
    
    return transformDataStr;
}

//校验车牌号
+ (BOOL )validateCarNo:(NSString *)carNo{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Za-z]{1}[A-Za-z_0-9]{5,6}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    
      return [carTest evaluateWithObject:carNo];
}


//身份证号
+ (BOOL)checkIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

//是否含空格
+ (BOOL) checkEmptyString:(NSString *) string {
    
    if (string == nil) return string == nil;
    
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}


+(BOOL)checkDateIsUsed:(NSString *)dateString{
    NSString *regex = @"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\\s+([01][0-9]|2[0-3]):[0-5][0-9]$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if([identityCardPredicate evaluateWithObject:dateString]){
        return YES;
    }
    return false;
}

//是否是中文姓名
+ (BOOL)isVaildRealName:(NSString *)realName
{
    if ([YMTool checkEmptyString:realName]){
        return NO;
        
    }
    
    NSRange range1 = [realName rangeOfString:@"·"];
    NSRange range2 = [realName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] > 16)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于1位并且不超过16位，如果有那就设高一点
        if ( [realName length] > 16) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}


+ (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    NSString *regex =@"[xX0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


+ (BOOL)isValidOperatorNum:(NSString *)operatorNum{
    NSString *regex = @"^[a-zA-Z]{2}(0|86|17951)?(13[0-9]|14[57]|15[012356789]|17[0-9]|18[0-9])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [pred evaluateWithObject:operatorNum];
    return isValid;
}



//根据传入的字符串格式判断，来用****隐藏信息
+ (NSString *)veilString:(NSString *)string{
    NSString *returnStr;
    if ([YMTool isValidPhoneNumber:string]) {
        returnStr = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else if ([YMTool isValidEmail:string]){
        returnStr = [YMTool veilEmail:string];
    }else if ([YMTool isValidOperatorNum:string]){
        NSString *headStr = [string substringWithRange:NSMakeRange(0, 2)];
        NSString *operatorPhone = [string substringWithRange:NSMakeRange(2, 11)];
        operatorPhone = [operatorPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        returnStr = [headStr stringByAppendingString:operatorPhone];
    }else if ([YMTool isValidPersonalBankCardNum:string]){
        returnStr =  [string stringByReplacingCharactersInRange:NSMakeRange(6, string.length - 10) withString:@"****"];
    }else{
        returnStr = string;
    }
    return returnStr;
}

//属性字符串
+(NSAttributedString *)getAttStrWithStr:(NSString *)str  attributedSubStrings:(NSArray *)attributedSubStrings attributedStyles:(NSArray *)attributedStyles{
    NSAttributedString *attributedStr = [str stringToAttributedStringWithAttributedSubStrings:attributedSubStrings attributedStyles:attributedStyles];
    return attributedStr;
}

//改变图片透明度
+ (UIImage *)changeAlphaOfImageWith:(CGFloat)alpha withImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//是否已登录(只判断)
+ (BOOL)loginStatus{
    if ([[YMUserDefaults  stringValueForKey:kLOGINSTATUS] isEqualToString:@"login"]) {
        return YES;
    }
    return NO;
}




//获取当前窗口的UINavigationController
+(UIViewController *)theTopviewControler{
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    return rootVC;
}


//根据订单信息，生成rsa的签名值对rsa值url编码
+ (NSString *)urlInURLEncoding:(NSString *)str{
    NSString *encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedUrl;
}

//商户自己调用后台服务器获取rsa的签名值
+ (NSString *)getRSASignWithParas:(NSDictionary *)dic {
    NSString *urlStr;
    //获取rsa签名值post请求的URL地址
    //获取rsa签名值post请求的URL地址
    //urlStr = @"http://172.16.133.198:7080/kame-mapi/gw/router"; // 汤成
    //urlStr = @"http://172.16.133.188:8088/kame-mapi/gw/router"; //宪新
    // urlStr = @"http://172.16.133.222:8080/kame-mapi/gw/router";//测试环境
    //  urlStr = @"http://172.16.159.1:8080/kame-mapi/gw/router";//测试环境
    //urlStr = @"http://172.16.159.3:8080/kame-mapi/gw/router";//测试环境
    urlStr = @"http://172.16.159.7:8080/kame-mapi/gw/router";//测试环境
    NSURL * orderWebPayURL = [NSURL URLWithString:urlStr];
    //将需要签名的业务参数与协议参数组装在字典里
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parameters setValue:@"kmpay.merchant.sign" forKey:@"method"];
    //由参数字典(含业务参数与协议参数)字符串化与签名key拼接构成
    NSString *signStr = [NSString stringWithFormat:@"%@%@", [self stringFromDictionaryParameters:parameters], @"xid9OVYOq3d9Dc6sVnCpiw1JI3loLP6q"];
    NSString *md5edStr = [self md5String:signStr];
    [parameters setValue:md5edStr forKey:@"sign"];
    //将请求参数字符串转成NSData类型
    NSString *bodyStr = [self stringFromDictionary:parameters];
    NSData * postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:orderWebPayURL];
    [request setHTTPMethod:@"POST"];    //设置请求方式
    [request setHTTPBody:postData];     //设置请求体
    NSError *err;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic %@",resDic);
    NSString *rsaSign =  [[resDic valueForKey:@"data"] valueForKey:@"sign"];
    return rsaSign;
}

//将字典按key的升序排列字符串化
+ (NSString *)stringFromDictionaryParameters:(NSDictionary *)dic {
    NSString *appendingStr = [NSMutableString string] ;
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [dic allKeys];
        NSArray *sortedAllKeys = [keys sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString * obj1, NSString *obj2){
            if ([obj1 compare:obj2] == NSOrderedAscending) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        
        for (NSString *key in sortedAllKeys) {
            NSString *value = [dic valueForKey:key];
            appendingStr = [appendingStr stringByAppendingFormat:@"%@=%@",key,value];
        }
    }
    
    return appendingStr;
}

//把用于post请求的参数拼接起来，用&符号
+ (NSString *)stringFromDictionary:(NSDictionary *)dic {
    NSString *appendingStr = @"";
    
    NSArray *allkeys = [dic allKeys];
    for (NSString *key in allkeys) {
        NSString *value = [dic valueForKey:key];
        appendingStr = [appendingStr stringByAppendingFormat:@"%@=%@&",key,value];
    }
    appendingStr = [appendingStr substringToIndex:(appendingStr.length-1)];
    
    return appendingStr;
}

//md5签名
+ (NSString *)md5String:(NSString *)str {
    const char *cstr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

@end

