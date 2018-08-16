截图

##### View截屏

方法一：renderInContext
方式实际上是通过遍历UIView的layer tree进行渲染，但是它不支持动画的渲染，它的的性能会和layer tree的复杂度直接关联。
内存消耗多，耗时

方法二：drawViewHierarchyInRect

api是苹果基于UIView的扩展，与第一种方式不同，这种方式是直接获取当前屏幕的“快照”

内存消耗少，耗时多

fix wkwebview bug，UIGraphicsGetCurrentContext()的返回结果是nil



##### UIWebView截屏



##### WKWebView截屏





### Bug



ios11之后，保存到相机报错：

<Error>: CGImageCreateWithImageProvider: invalid image provider: NULL.

如果view中内容存在wkwebview，
使用 [self.layer renderInContext:context]; 在截屏时可能拿不到wkwebview内容，UIGraphicsGetCurrentContext()的返回结果是nil，
需使用 [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];

fix wkwebview bug，UIGraphicsGetCurrentContext()的返回结果是nil



##### 保存到相机

方法：
```
SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
UIImageWriteToSavedPhotosAlbum(image, self, selector, (__bridge void *)self);
```
ios11之后，保存到相机报错：
[access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryAddUsageDescription key with a string value explaining to the user how the app uses this data.
解决方案：info.plist中增加key-value:
key：Privacy - Photo Library Additions Usage Description
value: 需要保存图片



#### 参考文章链接

[StackOvetflow - WKWebView Screenshots](https://stackoverflow.com/questions/24727499/wkwebview-screenshots)

[两种截屏方案的对比](https://blog.csdn.net/lizitao/article/details/74857890)

[iOS 截图的那些事儿](https://www.jianshu.com/p/3327ffeb7fa5)

[我只是想要截个屏](http://blog.startry.com/2016/02/24/Screenshots-With-SwViewCapture/)



#### 推荐的开源项目

[TYSnapshotScroll - 一句代码保存截图]( https://github.com/TonyReet/TYSnapshotScroll)

[SwViewCapture - iOS截图库（swift版本） ](https://github.com/startry/SwViewCapture)

