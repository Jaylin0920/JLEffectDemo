//
//  UIView+JLAdd.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "UIView+JLAdd.h"
#import <WebKit/WebKit.h>

@implementation UIView (JLAdd)

/**
 ios11之后，保存到相机报错：
 [access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryAddUsageDescription key with a string value explaining to the user how the app uses this data.
 info.plist中增加
 key: Privacy - Photo Library Additions Usage Description
 value: 需要保存图片
 
 
 */


//两种方式的性能和耗时比较：https://blog.csdn.net/lizitao/article/details/74857890
- (UIImage *)jl_convertToImage {
    // obtain scale
    CGFloat scale = [UIScreen mainScreen].scale;
    // 开始绘图，下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, scale);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //开始生成图片
    UIImage *image;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        // fix wkwebview bug，UIGraphicsGetCurrentContext()的返回结果是nil
        // api是苹果基于UIView的扩展，与第一种方式不同，这种方式是直接获取当前屏幕的“快照”，
        // 内存消耗少，耗时多
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        image = UIGraphicsGetImageFromCurrentImageContext();
    } else {
        
        // renderInContext:方式实际上是通过遍历UIView的layer tree进行渲染，但是它不支持动画的渲染，它的的性能会和layer tree的复杂度直接关联。
        // 内存消耗多，耗时少
        CGContextSaveGState(context);
        [self.layer renderInContext:context];
        self.layer.contents = nil;
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)imageForWebView:(UIWebView *)webview
{
    // 1.获取WebView的宽高
    CGSize boundsSize = webview.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    // 2.获取contentSize
    CGSize contentSize = webview.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    // 3.保存原始偏移量，便于截图后复位
    CGPoint offset = webview.scrollView.contentOffset;
    // 4.设置最初的偏移量为(0,0);
    [webview.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        // 5.获取CGContext 5.获取CGContext
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 6.渲染要截取的区域
        [self.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 7.截取的图片保存起来
        [images addObject:image];
        
        CGFloat offsetY = webview.scrollView.contentOffset.y;
        [webview.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    // 8 webView 恢复到之前的显示区域
    [webview.scrollView setContentOffset:offset];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    // 9.根据设备的分辨率重新绘制、拼接成完整清晰图片
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,scale * boundsHeight * idx,scale * boundsWidth,scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullImage;
}


// 长截图 类型可以是 tableView或者scrollView 等可以滚动的视图 根据需要自己改
- (UIImage *)saveLongImage:(UIScrollView *)table {
    UIImage* image = nil;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(table.contentSize, YES, [UIScreen mainScreen].scale);
    CGPoint savedContentOffset = table.contentOffset;
    CGRect savedFrame = table.frame;
    table.contentOffset = CGPointZero;
    table.frame = CGRectMake(0, 0, table.contentSize.width, table.contentSize.height);
    [table.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    table.contentOffset = savedContentOffset;
    table.frame = savedFrame;
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)screenshot {
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

@end
