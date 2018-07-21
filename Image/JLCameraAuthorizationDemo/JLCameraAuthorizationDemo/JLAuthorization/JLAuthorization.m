//
//  JLAuthorization.m
//  JLCameraAuthorizationDemo
//
//  Created by JiBaoBao on 2018/7/21.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLAuthorization.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation JLAuthorization

// 跳转到系统设置
+ (void)jumptoSystemSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([ [UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark - 权限检查

///  检测相机的方法
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission {
    //AVMediaTypeVideo:相机权限; AVMediaTypeAudio：麦克风权限
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:{ //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                granted ? permissionGranted() : noPermission();
            }];
            break;
        }
        case AVAuthorizationStatusRestricted: //家长控制，访问限制
            NSLog(@"不能完成授权，可能开启了访问限制");
            noPermission();
            break;
        case AVAuthorizationStatusDenied: //未授权，用户选择授权过
            noPermission();
            break;
        case AVAuthorizationStatusAuthorized:{ //已经授权
            permissionGranted();
            break;
        }
        default:
            break;
    }
}

/// 检测访问相册的权限
+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission {
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined:{ //第一次提示用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                status == PHAuthorizationStatusAuthorized ? permissionGranted() : noPermission();
            }];
            noPermission();
            break;
        }
        case PHAuthorizationStatusRestricted: //无法授权，有访问限制
            NSLog(@"不能完成授权，可能开启了访问限制");
            noPermission();
            break;
        case PHAuthorizationStatusDenied: //未授权，用户选择授权过
            noPermission();
            break;
        case PHAuthorizationStatusAuthorized:{ //已经授权
            permissionGranted();
            break;
        }
        default:
            break;
    }
}


@end
