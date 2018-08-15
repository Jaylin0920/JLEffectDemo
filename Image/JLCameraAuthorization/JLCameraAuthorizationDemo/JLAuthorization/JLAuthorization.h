//
//  JLAuthorization.h
//  JLCameraAuthorizationDemo
//
//  Created by JiBaoBao on 2018/7/21.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相机相册权限
 */
@interface JLAuthorization : NSObject

/**
 跳转到系统设置中
 */
+ (void)jumptoSystemSetting;

/**
 检测相机的访问权限
 @param permissionGranted 相机授权成功执行的方法
 @param noPermission 相机授权失败或者未授权执行的方法
 */
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission;

/**
 检测访问相册的权限
 这里的方法适用于iOS8及其以后版本
 @param permissionGranted 相册授权成功执行的方法
 @param noPermission 相册授权失败或者未授权执行的方法
 */
+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission;

@end
