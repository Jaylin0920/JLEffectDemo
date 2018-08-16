//
//  JLTools.h
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/16.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define kScreenHeight                       [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth                        [[UIScreen mainScreen] bounds].size.width

#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);

@interface JLTools : NSObject

// 保存图片到相册
+ (void)saveImage:(UIImage *)image;

// 删除相册图片
+ (void)deletePhoto;

@end
