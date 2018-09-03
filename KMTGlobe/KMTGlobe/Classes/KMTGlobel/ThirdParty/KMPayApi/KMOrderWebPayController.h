//
//  KMOrderWebPayController.h
//  KMTPayDemo
//
//  Created by 123 on 16/3/4.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMOrderWebPayController : UIViewController

//通过web页面支付时，所需要传递给web后台的数据
@property (copy, nonatomic) NSString *bodyStr;
@end
