# 相机、相册访问权限

####  info.plist设置

```
<!-- 相机 —> 
<key>NSCameraUsageDescription</key>
<string>App需要您的同意,才能访问相机</string>
<!-- 相册 —> 
<key>NSPhotoLibraryUsageDescription</key>
<string>App需要您的同意,才能访问相册</string>
```



#### 权限API

相机权限

```objective-c
//相机、麦克风的授权状态
typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
    AVAuthorizationStatusNotDetermined = 0, //未询问过用户是否授权
    AVAuthorizationStatusRestricted, //未授权，家长控制，访问限制
    AVAuthorizationStatusDenied, //未授权，用户选择授权过
    AVAuthorizationStatusAuthorized //已经授权
} NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;

//AVMediaTypeVideo:相机权限
//AVMediaTypeAudio：麦克风权限
```

相机权限

```objective-c
typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
    PHAuthorizationStatusNotDetermined = 0, //未询问过用户是否授权
    PHAuthorizationStatusRestricted, //未授权，家长控制，访问限制
    PHAuthorizationStatusDenied, //未授权，用户选择授权过           
    PHAuthorizationStatusAuthorized, //已经授权  
} PHOTOS_AVAILABLE_IOS_TVOS(8_0, 10_0);
```



#### Alert文案内容

> Tips：文案内容注意符合规范，否则审核会被拒

首次访问（未询问过用户是否授权）

> alert为苹果系统控制。message可修改，title、buttonTitle不可修改

```
“APP名称”想访问您的相机
App需要您的同意,才能访问相机 - jl此处文案可修改，但要符合规范，否则审核会被拒
不允许 vs 好
```

非首次访问

> alert为APP端控制。title、message、buttonTitle均可修改

```
“APP名称”想访问您的照片
需要获取您的相册信息
不允许 vs 好
```



#### 相册访问权限变更

iOS11之前：无默认权限

iOS11之后：默认开启访问相册权限（读权限），可直接跳转到相册。如想添加图片到相册（写权限），需用户授权。



#### 相册访问权限效果

iOS11以下，不配置访问权限时，

第一次访问时，会直接进入相册，可能会出现短暂的白屏/黑屏，进行苹果系统弹窗授权提示，

-> 同意授权后，第二次访问，正常访问，可直接接入相册

-> 拒绝授权后，第二层次访问，无法访问，出现锁定权限的页面（如：蚂蚁财富）

锁定权限的提示内容“此应用没有权限访问您的照片或视频，您可以在“隐私设置”中启用访问”



#### 参考文章链接

[info.plist权限设置](https://blog.csdn.net/qq413191840/article/details/74171751)

[ECAuthorizationTools（iOS隐私权限获取的封装工具类）](https://blog.csdn.net/qq_30513483/article/details/74388625)

[iOS11相册权限变更](https://www.jianshu.com/p/c03a87e4ca87)

[改变相册访问许可时 crash 问题](http://www.cocoachina.com/ios/20161129/18218.html)