//
//  KMTPayApi.m
//  KMTPayDemo
//
//  Created by 123 on 16/2/26.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import "KMTPayApi.h"
#import "KMOrderWebPayController.h"

#define KMTPAYURL             @"kmtpay://"
#define KMTPAYAPIVERSION      @"1.0.0"
#define KMTPAYAPPINSTALLURL   @"https://itunes.apple.com/cn/app/kang-mei-qian-bao/id1078135361?mt=8"

@implementation KMTPayApi

+ (BOOL)isKMTPayInstalled {
    NSURL *kmtPayUrl = [NSURL URLWithString:KMTPAYURL];
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:kmtPayUrl];

    return isInstalled;
}

+(BOOL)openKMTPayApp {
    NSURL *kmtPayUrl = [NSURL URLWithString:KMTPAYURL];
    BOOL isOpened = [[UIApplication sharedApplication] openURL:kmtPayUrl];
    
    return isOpened;
}

+ (NSString *)getKMTPayApiVersion {
    return KMTPAYAPIVERSION;
}

+ (NSString *)getKMTPayAppInstallUrl {
    return KMTPAYAPPINSTALLURL;
}

+ (void) handleOpenURL:(NSURL *) url delegate:(id<KMTPayApiDelegate>) delegate {
    if (delegate && [delegate respondsToSelector:@selector(onResp:)]) {
        KMTPayResp *kmtpayResp = [KMTPayApi createKMTPayRespWithOpenURL:url];
        [delegate onResp:kmtpayResp];
    }
}

//第三方应用通过此接口传递生成康美支付预订单所需的信息
+ (BOOL)sendReq:(KMTPayReq *)req {
    //康美支付预订单所含的信息
    NSString *orderInfo = [[KMTPayApi createOpenUrlStringWithKMTPayReq:req] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //对参数不进行utf－8编码
//    NSString *orderInfo = [KMTPayApi createOpenUrlStringWithKMTPayReq:req];
    
    if ([KMTPayApi isKMTPayInstalled]) {
        //用户已经安装了康美钱包App,则将相应的生成康美支付预订单所需的信息传递给康美钱包App
        NSString *openUrlString = [NSString stringWithFormat:@"kmtpay://%@", orderInfo];
        NSURL *openUrl = [NSURL URLWithString:openUrlString];
        BOOL isOpened = [[UIApplication sharedApplication] openURL:openUrl];
        return isOpened;
    } else {
        //用户未安装康美钱包App,跳转至“康美支付网页”或“康美钱包”App的下载地址
       UIViewController *windowRootController = [UIApplication sharedApplication].keyWindow.rootViewController;
       
        //如果当前窗口的根控制器为导航控制器
        KMOrderWebPayController *orderWebPayController = [[KMOrderWebPayController alloc] init];
        orderWebPayController.bodyStr = orderInfo;
      
        if ([windowRootController isKindOfClass:[UINavigationController class]]) {
            //present
            [(UINavigationController *)windowRootController presentViewController:orderWebPayController animated:YES completion:^{
            }];
            
        } else if ([windowRootController isKindOfClass:[UITabBarController class]]) {
            //present
            UIViewController *selectedController = ((UITabBarController *)windowRootController).selectedViewController;
            [selectedController presentViewController:orderWebPayController animated:YES completion:^{
            }];
        }
        
        return NO;
    }
}

#pragma mark - 辅助
+ (NSString *)createOpenUrlStringWithKMTPayReq:(KMTPayReq *)req {
    
    //将req对象转换为字典
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionary];
    [reqDic setValue:req.partner   forKey:@"partner"];
    [reqDic setValue:req.notifyUrl forKey:@"notifyUrl"];
    if (req.returnUrl) {
        [reqDic setValue:req.returnUrl forKey:@"returnUrl"];
    }
    [reqDic setValue:req.outTradeNo  forKey:@"outTradeNo"];
    [reqDic setValue:req.totalAmount forKey:@"totalAmount"];
    [reqDic setValue:req.sellerEmail forKey:@"sellerEmail"];
    [reqDic setValue:req.subject     forKey:@"subject"];
    [reqDic setValue:req.body        forKey:@"body"];
    [reqDic setValue:req.timestamp   forKey:@"timestamp"];
    [reqDic setValue:req.signType    forKey:@"signType"];
    [reqDic setValue:req.rsaSign     forKey:@"sign"];
    [reqDic setValue:@"UTF-8"        forKey:@"inputCharset"];
    
    //针对康美电商登录h5而言
    if (req.kmpayAccount) {
        [reqDic setValue:req.kmpayAccount forKey:@"kmpayAccount"];
    }
    if (req.srcAccount) {
        [reqDic setValue:req.srcAccount forKey:@"srcAccount"];
    }
    if (req.src) {
        [reqDic setValue:req.src forKey:@"src"];
    }
    
    //将字典转为字符串
    NSString *openUrlStr = @"";
    
    NSArray *allKeys = reqDic.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = [reqDic valueForKey:key];
        openUrlStr = [openUrlStr stringByAppendingFormat:@"%@=%@&", key, value];
    }
    
    
    
    //删除拼接后多余的最后一个&字符
    openUrlStr = [openUrlStr substringToIndex:openUrlStr.length -1];
    
    NSLog(@"openUrlStr %@",openUrlStr);
    return openUrlStr;
}

//将康美钱包支付的处理结果组装为KMTPayResp对象
+ (KMTPayResp *)createKMTPayRespWithOpenURL:(NSURL *)openURL {
    
  //1)将openURL转换为字符串
    NSString *openURLStr = openURL.absoluteString;
    //转义
    NSString *absoluteStr = [openURLStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //2)对absoluteStr进行第一次分割,得到去除协议(kmt://)后的康美预支付订单参数字符串
    NSArray *removalProtocolArr = [absoluteStr componentsSeparatedByString:@"//"];
    
    //3)获取回调信息 errorCode=0&errorMessage=本次订单交易已被取消"
    NSString *respStr      = removalProtocolArr[1];
    NSArray  *respStrParasArr = [respStr componentsSeparatedByString:@"&"];
    
    //4)将数组中的参数信息转换为字典
    NSMutableDictionary *respDic = [NSMutableDictionary dictionary];
    for (NSString *preOrderParaStr in respStrParasArr) {
        NSArray *preOrderParaArr = [preOrderParaStr componentsSeparatedByString:@"="];
        NSString *key   = preOrderParaArr[0];
        NSString *value = preOrderParaArr[1];
        
        //给字典设值
        [respDic setValue:value forKey:key];
    }
   
    //5)创建KMTPayResp对象
    KMTPayResp *resp = [[KMTPayResp alloc] init];
    [resp setValuesForKeysWithDictionary:respDic];
    
    
    return resp;
}

@end
