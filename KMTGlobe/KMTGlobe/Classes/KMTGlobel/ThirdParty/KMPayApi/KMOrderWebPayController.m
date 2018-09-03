//
//  KMOrderWebPayController.m
//  KMTPayDemo
//
//  Created by 123 on 16/3/4.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import "KMOrderWebPayController.h"

#define SCREENWIDTH   ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT  ([UIScreen mainScreen].bounds.size.height)

//测试环境
//#define ORDERWEBPAYURL   @"http://172.16.133.222:8080/kame-wap/mobile/pay.htm"

//#define ORDERWEBPAYURL    @"http://172.16.159.3:8080/kame-wap/mobile/pay.htm"

//#define ORDERWEBPAYURL    @"http://172.16.159.1:8080/kame-wap/mobile/pay.htm"
#define ORDERWEBPAYURL    @"http://172.16.159.7:8080/kame-wap/mobile/pay.htm"

//汤成
//#define ORDERWEBPAYURL  @"http://172.16.133.198:7080/kame-wap/mobile/pay.htm"
//生产环境
//#define ORDERWEBPAYURL    @"https://www.kmpay518.com/kame-wap/mobile/pay.htm"

@interface KMOrderWebPayController () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (copy,   nonatomic) NSString *currentLoadedURLStr;

@end

@implementation KMOrderWebPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURL * orderWebPayURL = [NSURL URLWithString:ORDERWEBPAYURL];
   
   //将请求参数字符串转成NSData类型
    NSData * postData = [self.bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:orderWebPayURL];
    [request setHTTPMethod:@"POST"];    //设置请求方式
    [request setHTTPBody:postData];     //设置请求体
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.cancelBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr isEqualToString:@"ios://iOSClose"]) {
        //dismiss
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
        return NO;
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
     // NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
     NSLog(@"webViewDidFinishLoad webView.request %@", webView.request);
    //http://172.16.133.222/kame-wap/mobile/paySuccess.htm    //订单支付成功页面
    //http://120.25.155.19:8800/kame-wap/mobile/payFail.htm   //订单支付失败页面
    //其它页面
    
    //当前页面加载的URL地址
    NSString *requestUrlStr = [webView.request.URL absoluteString];
    self.currentLoadedURLStr = requestUrlStr;
    
    BOOL successFlag  = [self.currentLoadedURLStr containsString:@"paySuccess"];
    BOOL failFlag     = [self.currentLoadedURLStr containsString:@"payFail"];
    
    if (successFlag || failFlag) {
        [self.cancelBtn setTitle:@"返回商家" forState:UIControlStateNormal];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
}

#pragma mark - clickEvents
- (void)dismissOrderWebPayController:(UIButton *)sender {
    
    //清除缓存与cookie
    [self cleanCacheAndCookie];
    
    //交易逻辑判断
    BOOL successFlag  = [self.currentLoadedURLStr containsString:@"paySuccess"];
    BOOL failFlag     = [self.currentLoadedURLStr containsString:@"payFail"];
    NSDictionary *orderPayResult = nil;
    if (successFlag || failFlag) {
        if (successFlag) {
            //支付成功
            orderPayResult = @{@"result": @{@"errorCode":@"1", @"errorMessage":@"订单支付成功"}};
        } else {
            orderPayResult = @{@"result": @{@"errorCode":@"2", @"errorMessage":@"订单支付失败"}};
        }
        
    } else {
        //其它取消支付操作
        orderPayResult = @{@"result": @{@"errorCode":@"0", @"errorMessage":@"订单支付取消"}};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderPayResult" object:self userInfo:orderPayResult];
    
    //dismiss
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - setter/getter
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
    }
    return _webView;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake((SCREENWIDTH - 100), (SCREENHEIGHT - 120), 60, 60);
        _cancelBtn.layer.cornerRadius = 30;
        _cancelBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismissOrderWebPayController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelBtn;
}

/*清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
  
    //清除UIWebView的缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


@end
