//
//  KMTWebViewController.m
//  KMDeparture
//
//  Created by mac on 20/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTWebViewController.h"
#import <WebKit/WebKit.h>

@interface KMTWebViewController ()<WKNavigationDelegate> {
    NSString *_title;
    NSString *_urlString;
}

@property(nonatomic, weak) WKWebView *mainWebView;

@end

@implementation KMTWebViewController

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url {
    self = [super init];
    if (self) {
        _title = title;
        _urlString = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITECOLOR;
    self.title = _title;
    
    [self resetBackBarButton];
    
    WKWebView *mainWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.navigationDelegate = self;
    [self.view addSubview:mainWebView];
    self.mainWebView = mainWebView;
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetBackBarButton
{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setBackgroundColor:WHITECOLOR];
    UIImage *backImage = [UIImage imageNamed:@"icon_back"];
    leftBarButton.frame = CGRectMake(0, 0, backImage.size.width + 10, backImage.size.height + 20);
    // [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBarButton setImage:backImage forState:UIControlStateNormal];
    [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftBarButton addTarget:self action:@selector(viewWillBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space_item, item, nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (kIsEmpty(_title)) self.title = webView.title;
}

@end
