//
//  ViewController.m
//  JLCameraAuthorizationDemo
//
//  Created by JiBaoBao on 2018/7/21.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "JLAuthorization.h"

@interface ViewController ()<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 点击了“打开相机”
- (IBAction)cameraButtonClick:(UIButton *)sender {
    __weak typeof(self) wSelf = self;
    [JLAuthorization checkCameraAuthorizationGrand:^{
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf openCamera];
    } withNoPermission:^{
        __strong typeof(wSelf) sSelf = wSelf;
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"相机授权" message:@"跳转相机授权设置" delegate:sSelf cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 10;
            [alert show];
        #pragma clang diagnostic pop
    }];
}

// 点击了“打开相册”
- (IBAction)photoButonClick:(UIButton *)sender {
    //iOS11之前：访问相册和存储照片到相册（读写权限），需要用户授权，需要添加NSPhotoLibraryUsageDescription。
    //iOS11之后：默认开启访问相册权限（读权限），无需用户授权。如需添加图片到相册（写权限），则需要添加‘NSPhotoLibraryUsageDescription’
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0) {
        [self openPhotoLibrary];
    }else{
        __weak typeof(self) wSelf = self;
        [JLAuthorization checkPhotoAlbumAuthorizationGrand:^{
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf openPhotoLibrary];
        } withNoPermission:^{
            __strong typeof(wSelf) sSelf = wSelf;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"相册授权" message:@"跳转相册授权设置" delegate:sSelf cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
#pragma clang diagnostic pop
        }];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [JLAuthorization jumptoSystemSetting];
    }
}
#pragma clang diagnostic pop


#pragma mark - event respond

/**
 *  调用照相机
 */
- (void)openCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else  {
        NSLog(@"没有摄像头");
    }
}

/**
 *  打开相册
 */
-(void)openPhotoLibrary {
    // 进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"打开相册");
        }];
    } else{
        NSLog(@"不能打开相册");
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
