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

+ (void)captureWKWebView:(WKWebView *)wkWebview finishBlock:(void(^)(UIImage *snapShotImage))finishBlock {
    //添加遮盖
    UIView *snapShotView = [wkWebview snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(wkWebview.frame.origin.x, wkWebview.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [wkWebview.superview addSubview:snapShotView];
    
    //保存原始信息
    CGRect oldFrame = wkWebview.frame;
    CGPoint oldOffset = wkWebview.scrollView.contentOffset;
    CGSize contentSize = wkWebview.scrollView.contentSize;
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / wkWebview.scrollView.bounds.size.height);
    
    //设置frame为contentSize
    wkWebview.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    wkWebview.scrollView.contentOffset = CGPointZero;
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, [UIScreen mainScreen].scale);
    
    __weak typeof(wkWebview) weakWKWebview = wkWebview;
    //截取完所有图片
    [self scrollToDraw:0 maxIndex:(NSInteger )snapshotScreenCount wkWebview:wkWebview finishBlock:^{
        [snapShotView removeFromSuperview];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        weakWKWebview.frame = oldFrame;
        weakWKWebview.scrollView.contentOffset = oldOffset;
        if (finishBlock) {
            finishBlock(snapshotImage);
        }
    }];
}

#pragma mark - private method

// 滑动wkwebview后再截图
+ (void)scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex wkWebview:(WKWebView *)wkWebview finishBlock:(void(^)(void))finishBlock {
    UIView *snapshotView = wkWebview;
    
    //截取的frame
    CGRect snapshotFrame = CGRectMake(0, (float)index * snapshotView.bounds.size.height, snapshotView.bounds.size.width, snapshotView.bounds.size.height);
    
    // set up webview originY
    CGRect myFrame = wkWebview.frame;
    myFrame.origin.y = -((index) * snapshotView.frame.size.height);
    wkWebview.frame = myFrame;
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [snapshotView drawViewHierarchyInRect:snapshotFrame afterScreenUpdates:YES];
        if(index < maxIndex){
            [self scrollToDraw:index + 1 maxIndex:maxIndex wkWebview:wkWebview finishBlock:finishBlock];
        }else{
            if (finishBlock)  finishBlock();
        }
    });
}

+ (CGFloat)getScreenScale {
    return [UIScreen mainScreen].scale;
}

@end
