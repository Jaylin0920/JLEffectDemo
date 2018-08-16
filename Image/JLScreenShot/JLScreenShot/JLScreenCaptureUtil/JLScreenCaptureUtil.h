//
//  JLScreenCaptureUtil.h
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/**
 截屏工具
 */
@interface JLScreenCaptureUtil : NSObject

/**
 屏幕截屏
 */
+ (UIImage *)captureCurrentScreen;

/**
 view截屏
 (适用于未使用layer和OpenGL渲染的视图；包含navigationBar的视图使用此方法)
 */
+ (UIImage *)captureNormalView:(UIView *)view;

/**
 view-OpenGL截屏
 (适用于使用过OpenGL渲染过的视图；包含wkWebView的视图使用此方法)
 */
+ (UIImage *)captureOpenGLView:(UIView *)view;

/**
 scrollView截屏
 */
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;

/**
 uiWebview截屏
 */
+ (UIImage *)captureUIWebView:(UIWebView *)uiWebview;

/**
 wkWebView截屏
 */
+ (void)captureWKWebView:(WKWebView *)wkWebview finishBlock:(void(^)(UIImage *snapShotImage))finishBlock;

@end
