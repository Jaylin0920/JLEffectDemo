//
//  ViewController.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "JLWKController.h"
#import "JLScreenCaptureUtil.h"
#import "JLTools.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView; // 内容视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;
@property (weak, nonatomic) IBOutlet UIView *wkwebContainerView;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) NSString *urlStr;
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
    [JLTools saveImage:[JLScreenCaptureUtil captureCurrentScreen]];
}

// view截屏
- (IBAction)captureView:(UIButton *)sender {
    [JLTools saveImage:[JLScreenCaptureUtil captureNormalView:self.contentView]];
}

// view组合截屏
- (IBAction)captureCombineView:(UIButton *)sender {
    // shareView
    UIView *combineView = [[UIView alloc]init];
    combineView.clipsToBounds = YES;
    
    // nav
    UIImageView *navBarImageView = [[UIImageView alloc]init];
    navBarImageView.frame = CGRectMake(0, 0, kScreenWidth, self.navigationController.navigationBar.frame.size.height);
    navBarImageView.image =  [JLScreenCaptureUtil captureNormalView:self.navigationController.navigationBar];
    [combineView addSubview:navBarImageView];
    
    // contentView
    UIImageView *contentImageView = [[UIImageView alloc]init];
    contentImageView.frame = CGRectMake(0, navBarImageView.frame.size.height+10.f, self.contentView.frame.size.width, self.contentView.frame.size.height);
    contentImageView.image = [JLScreenCaptureUtil captureOpenGLView: self.contentView];
    [combineView addSubview:contentImageView];
    
    combineView.frame = CGRectMake(0, 0, kScreenWidth, navBarImageView.frame.size.height+contentImageView.frame.size.height);
    UIImage *resultImage = [JLScreenCaptureUtil captureNormalView:combineView];
    
    [JLTools saveImage:resultImage];
}

// scrollView截屏
- (IBAction)captureScrollView:(UIButton *)sender {
    [JLTools saveImage:[JLScreenCaptureUtil captureScrollView:self.scrollView]];
}

// uiWebview截屏
- (IBAction)captureUIWebView:(UIButton *)sender {
    [JLTools saveImage:[JLScreenCaptureUtil captureUIWebView:self.uiWebView]];
}

// wkWebView截屏
- (IBAction)captureWKWebView:(UIButton *)sender {
    // 跳转到全屏的webview页面，去截屏
    JLWKController *wkVC = [[JLWKController alloc]initWithUrlStr:_urlStr];
    [self.navigationController pushViewController:wkVC animated:YES];
    
//    // 使用当前的非全屏的webview页面截屏。在截屏过程中，会在wkwebview下层视图有页面闪动
//    TICK
//    [JLScreenCaptureUtil captureWKWebView:self.wkWebView finishBlock:^(UIImage *snapShotImage) {
//        [JLTools saveImage:snapShotImage];
//    }];
//    TOCK
}

#pragma mark - event method

- (void)deletePhoto {
    [JLTools deletePhoto];
}

- (void)loadWebRequest {
    // uiwebview都有图像。加载速度慢，占用内存过大。
    // wkwebview有的有图像，有的没图像。加载速度快，占用内存少
    // uiwebview.scrollview，就可以拿到整个网页的内容，但是wkwebview.scrollview是没有内容的，截屏的做法，相当于拿到网页整体的高度，然后一个屏幕的高度为计量单位，遍历拼接视图，组合成为的wkwebview的截图，所以在处理截图的速度上，网页内容长，wkwebview耗时会非常的长，五六秒，甚至十几秒都可能。另外本项目的wkwebview的截图方法，如wkwebview只占用了部分屏幕，此方法下层会有视图闪现。因此，如果网页一定要截图的功能，建议使用uiwebview，而非wkwebview
    NSString *urlStr = @"https://www.meituan.com"; // 截屏有图像，截屏时间2s左右
//    NSString *urlStr = @"http://money.sina.cn/h5chart/apptkchart.html?theme=black&direction=vertical&symbol=sz300104"; // 截屏有图像，截屏时间0.8s左右
//    NSString *urlStr = @"http://finance.sina.cn/2018-08-15/detail-ihhtfwqr2536607.d.html?from=wap"; // 截屏无图像，截屏时间4.5s
//    NSString *urlStr = @"https://sina.cn/index/feed?from=touch&Ver=20"; // 截屏一开始有图像，加载更多后，截屏就无图像了
    _urlStr = urlStr;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.wkWebView loadRequest:request];
    [self.uiWebView loadRequest:request];
}

#pragma mark - setup ui

- (void)setupUI {
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width+10, _scrollView.bounds.size.height+100);

    _wkWebView = [[WKWebView alloc] initWithFrame:self.wkwebContainerView.bounds];
    _wkWebView.opaque = NO;
    [_wkwebContainerView addSubview:_wkWebView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除图片" style:UIBarButtonItemStylePlain target:self action:@selector(deletePhoto)];
}


@end
