//
//  ViewController.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "JLScreenCaptureUtil.h"

#import "WKWebView+TYSnapshot.h"
#import <Photos/Photos.h>

#define kScreenHeight                       [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth                        [[UIScreen mainScreen] bounds].size.width

#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel; // 截图状态
@property (weak, nonatomic) IBOutlet UIView *contentView; // 内容视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;
@property (weak, nonatomic) IBOutlet UIView *wkwebContainerView;
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadWebRequest];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截屏" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除图片" style:UIBarButtonItemStylePlain target:self action:@selector(deletePhoto)];

}

- (void)shareAction{
    [self captureWKWebView:nil];
}


- (void)deletePhoto {
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx > [assetResult count] - 5) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
}

#pragma mark - 截屏

// 屏幕截屏
- (IBAction)captureCurrentScreen:(UIButton *)sender {
    [self saveImage:[JLScreenCaptureUtil captureCurrentScreen]];
}

// view截屏
- (IBAction)captureView:(UIButton *)sender {
    [self saveImage:[JLScreenCaptureUtil captureNormalView:self.contentView]];
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
    contentImageView.frame = self.contentView.frame;
    contentImageView.image = [JLScreenCaptureUtil captureOpenGLView: self.contentView];
    [combineView addSubview:contentImageView];
    
    combineView.frame = CGRectMake(0, 0, kScreenWidth, navBarImageView.frame.size.height+contentImageView.frame.size.height);
    UIImage *resultImage = [JLScreenCaptureUtil captureNormalView:combineView];
    
    [self saveImage:resultImage];
}

// scrollView截屏
- (IBAction)captureScrollView:(UIButton *)sender {
    [self saveImage:[JLScreenCaptureUtil captureScrollView:self.scrollView]];
}

// uiWebview截屏
- (IBAction)captureUIWebView:(UIButton *)sender {
    [self saveImage:[JLScreenCaptureUtil captureUIWebView:self.uiWebView]];
}

// wkWebView截屏
- (IBAction)captureWKWebView:(UIButton *)sender {
//    TICK
//    UIImage * image = [JLScreenCaptureUtil captureWKWebView:self.wkWebView];
//    [self saveImage:image];
//    TOCK
    
    
    TICK
    __weak typeof(self) weakSelf = self;
    [self.wkWebView screenSnapshot:^(UIImage *snapShotImage) {
        [weakSelf saveImage:snapShotImage];
        TOCK
    }];
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
        self.statusLabel.text = @"Fail";
        return;
    }
    self.statusLabel.text = @"Success";
}

#pragma mark - setup ui

- (void)setupUI {
    _wkWebView = [[WKWebView alloc] initWithFrame:self.wkwebContainerView.bounds];
    _wkWebView.opaque = NO;
    _wkWebView.scrollView.bounces = NO;
    [self.wkwebContainerView addSubview:_wkWebView];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width+10, _scrollView.bounds.size.height+100);
}

- (void)loadWebRequest {
    // uiwebview都有图像。加载速度慢，占用内存过大。
    // wkwebview有的有图像，有的没图像。加载速度快，占用内存少
    // uiwebview 和 wkwebview 内部加载和缓存机制不一样造成的
    // uiwebview.scrollview，就可以拿到整个网页的内容，但是wkwebview.scrollview是没有内容的，截屏的做法，相当于拿到网页整体的高度，然后一个屏幕的高度为计量单位，遍历拼接视图，组合成为的wkwebview的截图，所以在处理截图的速度上，网页内容长，wkwebview耗时会非常的长，五六秒，甚至十几秒都可能。另外本项目的wkwebview的截图方法，如wkwebview只占用了部分屏幕，此方法下层会有视图闪现。因此，如果网页一定要截图的功能，建议使用uiwebview，而非wkwebview
    
    
//    NSString *urlStr = @"https://www.meituan.com"; // 截屏有图像，截屏时间2s左右
//    NSString *urlStr = @"http://money.sina.cn/h5chart/apptkchart.html?theme=black&direction=vertical&symbol=sz300104"; // 截屏有图像，截屏时间0.8s左右
    NSString *urlStr = @"http://finance.sina.cn/2018-08-15/detail-ihhtfwqr2536607.d.html?from=wap"; // 截屏无图像，截屏时间4.5s
    //    NSString *urlStr = @"https://sina.cn/index/feed?from=touch&Ver=20"; // 截屏一开始有图像，加载更多后，截屏就无图像了
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];//超时时间10秒
    [self.wkWebView loadRequest:request];
    [self.uiWebView loadRequest:request];
}

@end
