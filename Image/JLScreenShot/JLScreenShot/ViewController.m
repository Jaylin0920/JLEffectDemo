//
//  ViewController.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "UIView+JLAdd.h"
#import <WebKit/WebKit.h>

#define kScreenHeight                       [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth                        [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel; // 截图状态
@property (weak, nonatomic) IBOutlet UIView *contentView; // 内容视图
@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;
@property (weak, nonatomic) IBOutlet UIView *wkwebContainerView;
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadWebRequest];
}

#pragma mark - 截屏

// 屏幕截屏
- (IBAction)captureCurrentScreen:(UIButton *)sender {
   UIImage *image = [self.view screenshot];
    [self saveImage:image];
}

// view截屏
- (IBAction)captureView:(UIButton *)sender {
    UIImage *image = [self.contentView jl_convertToImage];
    [self saveImage:image];
}

// view组合截屏
- (void)captureCombineView:(UIButton *)sender {
    // shareView
    UIView *combineView = [[UIView alloc]init];
    combineView.clipsToBounds = YES;
    
    // nav
    UIImageView *navBarImageView = [[UIImageView alloc]init];
    navBarImageView.frame = CGRectMake(0, 0, kScreenWidth, self.navigationController.navigationBar.frame.size.height);
    navBarImageView.image = [self.navigationController.navigationBar jl_convertToImage];
    [combineView addSubview:navBarImageView];
    
    // contentView
    UIImageView *contentImageView = [[UIImageView alloc]init];
    contentImageView.frame = self.contentView.frame;
    contentImageView.image = [self.contentView jl_convertToImage];
    [combineView addSubview:contentImageView];
    
    combineView.frame = CGRectMake(0, 0, kScreenWidth, navBarImageView.frame.size.height+contentImageView.frame.size.height);
    UIImage *resultImage = [combineView jl_convertToImage];
    
    [self saveImage:resultImage];
}

// webview截屏
- (void)captureUIWebView:(UIButton *)sender {
    
}

#pragma mark - 保存到相册

// 保存图片到相册
- (void)saveImage:(UIImage *)image {
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self, selector, (__bridge void *)self);
}

// 图片保存完后调用的方法
- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error){
        self.statusLabel.text = @"截图状态：失败";
        return;
    }
    self.statusLabel.text = @"截图状态：成功";
}

#pragma mark - setup ui

- (void)setupUI {
    _wkWebView = [[WKWebView alloc] initWithFrame:self.wkwebContainerView.bounds];
    _wkWebView.opaque = NO;
    _wkWebView.scrollView.bounces = NO;
    [self.wkwebContainerView addSubview:_wkWebView];
}

- (void)loadWebRequest {
    NSString *urlStr = @"http://finance.sina.cn/2018-08-14/detail-ihhtfwqq7086354.d.html?from=wap";
    [self.wkWebView loadRequest:[self getRequestWithUrlStr:urlStr]];
    [self.uiWebView loadRequest:[self getRequestWithUrlStr:urlStr]];
}

- (NSURLRequest *)getRequestWithUrlStr:(NSString *)urlStr{
    if (urlStr) {
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPShouldHandleCookies:NO];
        return [request copy];
    }
    return nil;
}

@end
