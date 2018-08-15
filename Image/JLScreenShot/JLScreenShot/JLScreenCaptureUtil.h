//
//  JLScreenCaptureUtil.h
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 截屏
 */
@interface JLScreenCaptureUtil : NSObject

/**
 屏幕截屏
 */
+ (UIImage *)captureCurrentScreen;

/**
 view截屏
 (该API仅可以在未使用layer和OpenGL渲染的视图上使用)
 */
+ (UIImage *)captureNormalView:(UIView *)view;

/**
 view截屏
 (针对有用过OpenGL渲染过的视图截图)
 */
+ (UIImage *)captureOpenGLView:(UIView *)view;

/**
 长截图 tableView或者scrollView
 */
+ (UIImage *)captureLongView:(UIScrollView *)scrollView;

/**
 uiWebview截屏
 */
+ (UIImage *)captureWebView:(UIWebView *)webview;

/**
 wkWebView截屏
 */


@end
