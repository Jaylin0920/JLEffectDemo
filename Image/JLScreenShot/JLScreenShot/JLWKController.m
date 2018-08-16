//
//  JLWKController.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/16.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLWKController.h"
#import <WebKit/WebKit.h>
#import "JLScreenCaptureUtil.h"
#import "JLTools.h"

@interface JLWKController ()
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) NSString *urlStr;
@end

@implementation JLWKController

- (instancetype)initWithUrlStr:(NSString *)urlStr {
    if (self = [super init]) {
        self.urlStr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"WKWebView截屏";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截屏" style:UIBarButtonItemStylePlain target:self action:@selector(captureWKWebView)];

    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.backgroundColor = [UIColor whiteColor];
    _wkWebView.opaque = NO;
    [self.view addSubview:_wkWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.wkWebView loadRequest:request];
}

- (void)captureWKWebView {
    TICK
    [JLScreenCaptureUtil captureWKWebView:self.wkWebView finishBlock:^(UIImage *snapShotImage) {
        [JLTools saveImage:snapShotImage];
    }];
    TOCK
}

@end
