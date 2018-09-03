//
//  KMTDatePickView.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/25.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTDatePickView.h"
#import "YMTool.h"



@interface KMTDatePickView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIView  *backView;
@property(nonatomic,strong) UIView  *contentView;
@property(nonatomic,assign) CGRect  frame ;
@property(nonatomic,strong) UIPickerView  *pickerView;

//数据
@property(nonatomic,strong) NSArray  *dayArray;
@property(nonatomic,strong) NSMutableArray  *hourArray;
@property(nonatomic,strong) NSMutableArray  *minArray;

//当前数据
@property(nonatomic,copy) NSString *  currentDay;
@property(nonatomic,copy) NSString *  currentHour;
@property(nonatomic,copy) NSString *  currentMine;

//选中数据源
@property(nonatomic,copy) NSString *  selectDay;
@property(nonatomic,copy) NSString *  selectHour;
@property(nonatomic,copy) NSString *  selectMine;
@property(nonatomic,copy) NSString *  selectToTal;
@property(nonatomic,copy) NSString *  dayString;

//action
@property(nonatomic,copy) void(^sureBlock)(NSString *selectString,NSString *dayString);
@end

@implementation KMTDatePickView
-(instancetype)initWithFrame:(CGRect)frame DissMissBlock:(void (^)(NSString *,NSString *))selectDateBlock{
    if (self == [super init]) {
        _frame = frame;
        _sureBlock = selectDateBlock;
        _backView = [UIView initWithFrame:[UIScreen mainScreen].bounds backGroundColor:RGBA(0, 0, 0, 0.3)];
        _backView.userInteractionEnabled = YES;
        _backView.tag = 10091;
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)]];
        
        _contentView = [UIView initWithFrame:frame backGroundColor:WHITECOLOR];
        _contentView.tag = 10092;
        UIView *headView = [UIView initWithFrame:Rect(0, 0, ScreenWidth, 50) backGroundColor:kBackgroundColor];
        
        
        UIButton *cancelBtn = [UIButton initWithFrame:Rect(0, 0, 50, headView.height) andTitle:@"取消" andTitleFont:kCelltextFont andTextColor:kCellTextColor andAction:^(UIButton *btn) {
            [self dissmiss];
        }];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton initWithFrame:Rect(ScreenWidth - 50, 0, 50, headView.height) andTitle:@"确定" andTitleFont:kCelltextFont andTextColor:kMainYellow andAction:^(UIButton *btn) {
            if ([NSDate compareAndFormat:@"yyyy-MM-dd HH:mm" OneDay:[YMTool getCurrentTime] withAnotherDay:self.selectToTal] < 0) {
                [self dissmiss];
                self.sureBlock(self.selectToTal,self.dayString);
            }else{
                ShowToast(@"预计取件时间必须大于当前时间！");
            }
        }];
        sureBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:sureBtn];
        [_contentView addSubview:self.pickerView];
        [_contentView addSubview:headView];
    }
    return  self;
}


-(void)show{
    [KEY_WINDOW.rootViewController.view addSubview:self.backView];
    [KEY_WINDOW.rootViewController.view addSubview:self.contentView];
    self.contentView.y = ScreenHeight;
    self.backView.alpha = 0;
    __block CGRect frame = self.frame;
    wSelf(tself)
    [UIView animateWithDuration:0.35f animations:^{
        tself.backView.alpha = 0.35;
        tself.contentView.y = frame.origin.y;
    }];
}

-(void)dissmiss{
    UIView *bView = [KEY_WINDOW viewWithTag:10091];
    UIView *cView = [KEY_WINDOW viewWithTag:10092];
    cView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        cView.y = ScreenHeight;
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
        [cView removeFromSuperview];
    }];
}

#pragma mark -------- layLoad
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 50, self.contentView.width, self.contentView.height - 50);
        _pickerView.backgroundColor = WHITECOLOR;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        
        NSDateComponents *dataCom = [self getDateComponents];
        NSInteger hour = [dataCom hour];
        NSInteger minute = [dataCom minute];
        
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        [_pickerView selectRow:hour inComponent:1 animated:NO];
        [_pickerView selectRow:minute inComponent:2 animated:NO];
        [self pickerView:_pickerView didSelectRow:0 inComponent:0];
        [self pickerView:_pickerView didSelectRow:hour inComponent:1];
        [self pickerView:_pickerView didSelectRow:minute inComponent:2];
    }
    return _pickerView;
}

-(NSArray *)dayArray{
    if (_dayArray == nil) {
        _dayArray = @[@"今天",@"明天",@"后天"];
    }
    return _dayArray;
}

-(NSMutableArray *)hourArray{
    if (_hourArray == nil) {
        _hourArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 24; i++) {
            if (i < 10) {
                [_hourArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }else{
                [_hourArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
    }
    return _hourArray;
}

-(NSMutableArray *)minArray{
    if (_minArray == nil) {
        _minArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 60; i++) {
            if (i < 10) {
                [_minArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }else{
                [_minArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    return _minArray;
}

#pragma mark - UIPickerViewDelegate+UIPickerViewDataSource
// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return 3;
    }else if(component == 1){
        return 24;
    }else{
        return 60;
    }
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dayArray[row];
    }else if(component == 1){
        return [NSString stringWithFormat:@"%@点",self.hourArray[row]];
    }else{
        return [NSString stringWithFormat:@"%@分",self.minArray[row]];
    }
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *day = [NSString new];
    switch (component) {
        case 0:
            self.selectDay = [self dateWithString:self.dayArray[row]];
            day = self.dayArray[row];
            break;
        case 1:
            self.selectHour = self.hourArray[row];
            break;
        case 2:
            self.selectMine = self.minArray[row];
            break;
        default:
            break;
    }
    
    NSString *ymdString = [NSString timeStringFromTimeStamp:self.selectDay.integerValue * 1000 andFormat:@"yyyy-MM-dd"];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@:%@",ymdString,self.selectHour,self.selectMine];
    self.selectToTal = dateString;
    self.dayString = [NSString stringWithFormat:@"%@ %@点%@分",day,self.selectHour,self.selectMine];
    KMTLog(@"%@",dateString);
}

-(NSString*)dateWithString:(NSString*)day{
    NSDate *date= [NSDate date];
    //NSDateFormatter:NSFormatter : NSObject
    //日期格式化器
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //通过格式化器 将NSDate 转换成NSString
    NSString *time=  [formatter stringFromDate:date];
    NSLog(@"time===%@",time);
    NSDateFormatter *formatter2 =[[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 将NSString 转换成date
    NSDate *date1 =[formatter2 dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",time]];
    //    今天的时间戳
    if ([day isEqualToString:@"今天"]) {
        NSString *timeSp1 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
        return timeSp1;
    }else if ([day isEqualToString:@"明天"]){
        //    明天的时间戳
        NSString *timeSp2 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]+86400];
        return timeSp2;
    }else{
        //    后天的时间戳
        NSString *timeSp3 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]+86400*2];
        return  timeSp3;
    }
}


#pragma mark - 重写方法设置字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = kLineColor;
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = kLineColor;
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:FONTSIZE(18)];
        //    pickerLabel.textColor = kCellTextColor;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark -------- tool
-(NSDateComponents *)getDateComponents{
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
    return dataCom;
}

@end
