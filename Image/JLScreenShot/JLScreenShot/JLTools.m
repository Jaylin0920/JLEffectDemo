//
//  JLTools.m
//  JLScreenShot
//
//  Created by JiBaoBao on 2018/8/16.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLTools.h"

@interface JLTools()
@property (nonatomic, strong) UIViewController *currentVC;
@end


@implementation JLTools

#pragma mark - 保存到相册

// 保存图片到相册
+ (void)saveImage:(UIImage *)image {
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self, selector, (__bridge void *)self);
}

// 图片保存完后调用的方法
+ (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error){
        [self showAlertWithMessage:@"失败"];
        return;
    }
    [self showAlertWithMessage:@"成功"];
}

#pragma mark - 删除相册图片

+ (void)deletePhoto {
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx > [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
}

#pragma mark - show alert

+ (void)showAlertWithMessage:(NSString *)message {
    message = [NSString stringWithFormat:@"图片保存%@", message];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [[self lt_getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}


#pragma mark - get currentVC

+ (UIViewController *)lt_getCurrentViewController{
    UIViewController *result = nil;
        UIWindow * window = [self lt_getMainWindow];
    UIView *frontView = [[window subviews] lastObject];
        id nextResponder = [frontView nextResponder];
    while ([nextResponder nextResponder]) {
        nextResponder = [nextResponder nextResponder];
    }
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return [self lt_getTopViewController:result];
}

+ (UIWindow *)lt_getMainWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)lt_getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self lt_getTopViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self lt_getTopViewController:[(UINavigationController *)viewController topViewController]];
    } else if (viewController.presentedViewController) {
        return [self lt_getTopViewController:viewController.presentedViewController];
    } else {
        return viewController;
    }
}


@end
