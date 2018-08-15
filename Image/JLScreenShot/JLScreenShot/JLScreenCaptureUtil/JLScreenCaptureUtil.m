//
//  JLScreenCaptureUtil.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLScreenCaptureUtil.h"

@implementation JLScreenCaptureUtil

+ (UIImage *)captureCurrentScreen {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureNormalView:(UIView *)view {
    // 第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，屏幕密度会影响生成的图片大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [self getScreenScale]);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [view.layer renderInContext:context];
    view.layer.contents = nil;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureOpenGLView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [self getScreenScale]);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [self getScreenScale]);
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureUIWebView:(UIWebView *)uiWebview {
    return [self captureScrollView:uiWebview.scrollView];
}


+ (UIImage *)captureWKWebView:(WKWebView *)webView {
    UIView *snapshotView = [webView snapshotViewAfterScreenUpdates:YES];
    snapshotView.frame = webView.frame;
    [webView.superview addSubview:snapshotView];
    
    CGPoint currentOffset = webView.scrollView.contentOffset;
    CGRect currentFrame = webView.frame;
    UIView *currentSuperView = webView.superview;
    NSUInteger currentIndex = [webView.superview.subviews indexOfObject:webView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:webView.bounds];
    [webView removeFromSuperview];
    [containerView addSubview:webView];
    
    CGSize totalSize = webView.scrollView.contentSize;
    NSInteger page = ceil(totalSize.height / containerView.bounds.size.height);
    
    webView.scrollView.contentOffset = CGPointZero;
    webView.frame = CGRectMake(0, 0, containerView.bounds.size.width, webView.scrollView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(totalSize, YES, UIScreen.mainScreen.scale);
    
    [self drawContentPage:containerView webView:webView index:0 maxIndex:page];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    [webView removeFromSuperview];
//    [currentSuperView insertSubview:webView atIndex:currentIndex];
    webView.frame = currentFrame;
    webView.scrollView.contentOffset = currentOffset;
    [snapshotView removeFromSuperview];
    
    return snapshotImage;
}



//+ (void)drawContentPage:(UIView *)targetView webView:(WKWebView *)webView index:(NSInteger)index maxIndex:(NSInteger)maxIndex completion:(dispatch_block_t)completion
+ (void)drawContentPage:(UIView *)targetView webView:(WKWebView *)webView index:(NSInteger)index maxIndex:(NSInteger)maxIndex
{
    CGRect splitFrame = CGRectMake(0, index * CGRectGetHeight(targetView.bounds), targetView.bounds.size.width, targetView.frame.size.height);
    CGRect myFrame = webView.frame;
    myFrame.origin.y = -(index * targetView.frame.size.height);
    webView.frame = myFrame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if (index < maxIndex) {
            [self drawContentPage:targetView webView:webView index:index + 1 maxIndex:maxIndex];
        } else {
        }
    });
}



//+ (UIImage *)captureWKWebView:(WKWebView *)wkWebView {
//    UIView *snapShotView = [wkWebView snapshotViewAfterScreenUpdates:YES];
////    snapShotView.frame = CGRectMake(wkWebView.frame.origin.x, wkWebView.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
////    [wkWebView.superview addSubview:snapShotView];
//
//    //保存原始信息
//    CGRect oldFrame = wkWebView.frame;
//    CGPoint oldOffset = wkWebView.scrollView.contentOffset;
//    CGSize contentSize = wkWebView.scrollView.contentSize;
//
//    //计算快照屏幕数
//    NSUInteger snapshotScreenCount = floorf(contentSize.height / wkWebView.scrollView.bounds.size.height);
//
//    //设置frame为contentSize
//    wkWebView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
//
//    wkWebView.scrollView.contentOffset = CGPointZero;
//
//    UIGraphicsBeginImageContextWithOptions(contentSize, NO, [UIScreen mainScreen].scale);
//
//    __weak typeof(wkWebView) weakWebView = wkWebView;
//
//     UIImage *snapshotImage;
//    __block __weak typeof(snapshotImage) weakSnapshotImage = snapshotImage;
//
//
//    //截取完所有图片
//    [self scrollToDraw:0 maxIndex:snapshotScreenCount wkWebView:wkWebView finishBlock:^{
//        [snapShotView removeFromSuperview];
//
//        weakSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        weakWebView.frame = oldFrame;
//        weakWebView.scrollView.contentOffset = oldOffset;
//
//    }];
//
//    return snapshotImage;
//}
//
//+ (void )scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex wkWebView:(WKWebView *)wkWebView finishBlock:(void(^)(void))finishBlock{
//    UIView *snapshotView = wkWebView;
//
//    //截取的frame
//    CGRect snapshotFrame = CGRectMake(0, (float)index * snapshotView.bounds.size.height, snapshotView.bounds.size.width, snapshotView.bounds.size.height);
//
//    // set up webview originY
//    CGRect myFrame = wkWebView.frame;
//    myFrame.origin.y = -((index) * snapshotView.frame.size.height);
//    wkWebView.frame = myFrame;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
//
//        [snapshotView drawViewHierarchyInRect:snapshotFrame afterScreenUpdates:YES];
//
//        if(index < maxIndex){
//            [self scrollToDraw:index + 1 maxIndex:maxIndex wkWebView:wkWebView finishBlock:finishBlock];
//        }else{
//            if (finishBlock) {
//                finishBlock();
//            }
//        }
//    });
//}



#pragma mark - private method

+ (CGFloat)getScreenScale {
    return [UIScreen mainScreen].scale;
}

@end
