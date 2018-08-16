## View截屏，方案对比

##### 方法一：renderInContext

- 该方法实际上是通过遍历UIView的layer tree进行渲染，但是它不支持动画的渲染，它的的性能会和layer tree的复杂度直接关联。

- 内存消耗多，所耗时间少。

- UIWebView使用此方法，可以拿到当前显示内容的截图。

- WKWebView使用此方法，拿不到当前显示内容的截图。（UIGraphicsGetCurrentContext()的返回结果是nil）

##### 方法二：drawViewHierarchyInRect

- API是苹果基于UIView的扩展，与第一种方式不同，这种方式是直接获取当前屏幕的“快照”
```
Renders a snapshot of the complete view hierarchy as visible onscreen into the current context.
```
其中的 visible onscreen，也就是将屏幕中可见部分渲染到上下文中，这也解释了为什么对 WKWebView 中的 scrollView 展开为实际内容大小，再调用 drawViewHierarchyInRect 方法总是得到一张不完整的截图（只有屏幕可见区域被正确截到，其他区域为空白）。

- 内存消耗少，所耗时间多。

- UIWebView使用此方法，可以拿到当前显示内容的截图。

- WKWebView使用此方法，可以拿到当前显示内容的截图。 （包含wkWebView的视图需使用此方法）

<br>



## UIWebView、WKWebView的长视图截屏对比

##### UIWebView

- 网页加载速度慢，占用内存过大。

- uiWebview.scrollView长视图截图，可以拿到整个网页内容。（UIWebView承载内容的其实是作为其子View的UIScrollView，所以对其scrollView进行截图即可）

- 本项目中截图方法，都有图像。

##### WKWebview

- 网页加载速度快，占用内存少。

- wkWebview.scrollView长视图截图是一片空白。（具体原因不明）

- 本项目中截图方法，有时可能拿不到图像。（网页内容过时，可能拿不到图像）

- 截屏处理时间长。（长视图截屏时采用了单屏截图，然后暴力渲染方式合成一张大截图。内容越长，递归操作的耗时越长，五六秒，甚至十几秒都可能）

- 本项目的wkwebview的截图方法，如果wkwebview只占用了部分屏幕，此方法会在wkwebview下层有视图闪现的问题。

##### 总结

- 加载webview时，考虑到网页加载速度和内存占用上 —> 推荐选用 WKWebview

- 如果有webview截图需求时，从耗时角度上考虑，WKWebview截图采用了递归操作耗时长，内容越长耗时越多， —> 推荐选用 WKWebview

- 如果有webview截图需求时，网页内容很短 —> 使用UIWebView，WKWebview均可

- 如果有webview截图需求时，网页内容过长，可能拿不到截图图像 —> 一定要选用UIWebView

<br>



## WKWebView 长视图截屏方案

暴力的渲染方式去合成一张大截图。

（截取屏幕显示范围大小的视图，滚动，按页截图，滚动，按页截图，递归操作直到滚动到最后一页，最后将所有截取的图片合成为一张大图。）

![image](http://blog.startry.com/img/blog_swvc_wkwebview.png)

<br>



## Bug及解决

##### 1、含有WKWebview的视图在截图时，图片可能为nil

截图使用的方法是 ` [view.layer renderInContext:context]; ` ，在截屏时可能拿不到wkwebview的内容，此时 `UIGraphicsGetCurrentContext()` 的返回结果是nil

需使用 ` self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]; `


##### 2、iOS11之后，图片保存到相机会报错

报错提示：

```objective-c
<Error>: CGImageCreateWithImageProvider: invalid image provider: NULL.
```
使用保存到相机的方法：

```objective-c
SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
UIImageWriteToSavedPhotosAlbum(image, self, selector, (__bridge void *)self);
```

原因分析：

```objective-c
[access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryAddUsageDescription key with a string value explaining to the user how the app uses this data.
```

解决方案：

在info.plist中增加 key-value 如下：

```objective-c
key：Privacy - Photo Library Additions Usage Description
value: 需要保存图片
```
<br>



## 参考文章链接

[StackOvetflow - WKWebView Screenshots](https://stackoverflow.com/questions/24727499/wkwebview-screenshots)

[StackOvetflow - Getting a Screenshot of a UIScrollView including offscreen parts](https://stackoverflow.com/questions/3539717/getting-a-screenshot-of-a-uiscrollview-including-offscreen-parts)

[两种截屏方案的对比](https://blog.csdn.net/lizitao/article/details/74857890)

[iOS 截图的那些事儿](https://www.jianshu.com/p/3327ffeb7fa5)

[我只是想要截个屏](http://blog.startry.com/2016/02/24/Screenshots-With-SwViewCapture/)

<br>



## 推荐的开源项目

[TYSnapshotScroll - 一句代码保存截图]( https://github.com/TonyReet/TYSnapshotScroll)

[SwViewCapture - iOS截图库（swift版本） ](https://github.com/startry/SwViewCapture)

