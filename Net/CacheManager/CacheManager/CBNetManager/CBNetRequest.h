//
//  CBNetRequest.h
//  CacheManager
//
//  Created by 俊欧巴 on 2018/7/16.
//  Copyright © 2018年 俊欧巴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBNetErrorHelper.h"

/**
 请求成功的block
 
 @param response 响应体数据
 */
typedef void(^CBRequestSuccess)(id response);
/**
 请求失败的block
 
 @param error 错误信息
 */
typedef void(^CBRequestFailure)(NSString *error);

@interface CBNetRequest : NSObject

#pragma mark - 登陆退出
/** 登录*/
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(CBRequestSuccess)success failure:(CBRequestFailure)failure;
/** 退出*/
+ (NSURLSessionTask *)getExitWithParameters:(id)parameters success:(CBRequestSuccess)success failure:(CBRequestFailure)failure;

@end
