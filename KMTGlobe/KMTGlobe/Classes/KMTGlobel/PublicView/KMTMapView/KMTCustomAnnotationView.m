//
//  KMTCustomAnnotationView.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTCustomAnnotationView.h"
#define kCalloutWidth       320.0
#define kCalloutHeight      45.0

@interface KMTCustomAnnotationView()
@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
@end

@implementation KMTCustomAnnotationView
//复写父类init方法
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        //创建大头针视图
        [self setUpClloutView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        [self setUpClloutView];
    }
    else
    {
    }
    [super setSelected:selected animated:animated];
}

- (void)setUpClloutView {
    if (self.calloutView == nil)
    {
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        [self addSubview:self.calloutView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*坐标不合适再此设置即可*/
    //Code ...
    self.calloutView.frame = CGRectMake(-(kCalloutWidth-self.frame.size.width)*0.5, -kCalloutHeight, kCalloutWidth, kCalloutHeight);
}


@end
