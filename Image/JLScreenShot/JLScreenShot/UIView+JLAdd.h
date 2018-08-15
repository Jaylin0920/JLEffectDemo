//
//  UIView+JLAdd.h
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/15.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JLAdd)

/**
 UIView 转换成 UIImage
 */
- (UIImage *)jl_convertToImage;

- (UIImage *)imageForWebView:(UIWebView *)webview;

- (UIImage *)screenshot;

@end
