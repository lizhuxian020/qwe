//
//  KMTCustomCalloutView.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "CustomCalloutView.h"

@interface CustomCalloutView()

@property(nonatomic,copy) void(^completedBlock)(NSString *title);

@end


@implementation CustomCalloutView

#define kTitleHeight        20
#define kArrorHeight        10


- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, kMainYellow.CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 20.5;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title click:(void (^)(NSString *))completed{
    self = [super initWithFrame:frame];
    if (self)
    {
        _completedBlock = completed;
        self.backgroundColor = [UIColor clearColor];
        [self initSubViewsWithFrame:frame Title:title];
    }
    return self;
}

- (void)initSubViewsWithFrame:(CGRect)frame Title:(NSString *)title
{
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.y -= kArrorHeight * 0.5;
    self.titleLabel.font = kCelltextFont;
    self.titleLabel.textColor = WHITECOLOR;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
//    if (title.length > 4) {
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
//        NSRange r = NSMakeRange(0, 5);
//        NSRange r2 = NSMakeRange(title.length - 2, 2);
//        [attributedString addAttribute:NSForegroundColorAttributeName value:WHITECOLOR range:r];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:WHITECOLOR range:r2];
//        [self.titleLabel setAttributedText:attributedString];
//    }
    [self addSubview:self.titleLabel];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(calloutViewClicked)]];
    
}

-(void)calloutViewClicked{
    if (self.completedBlock) {
        self.completedBlock(self.title);
    }
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
@end



