//
//  CBNetRequest.m
//  CacheManager
//
//  Created by 俊欧巴 on 2018/7/16.
//  Copyright © 2018年 俊欧巴. All rights reserved.
//

#import "CBNetRequest.h"
#import "CBInterfacedConst.h"
#import "CBNetworkHelper.h"

@implementation CBNetRequest

/** 登录*/
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(CBRequestSuccess)success failure:(CBRequestFailure)failure
{
    // 将请求前缀与请求路径拼接成一个完整的URL
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kLogin];
    return [self requestWithURL:url parameters:parameters success:success failure:failure];
}
/** 退出*/
+ (NSURLSessionTask *)getExitWithParameters:(id)parameters success:(CBRequestSuccess)success failure:(CBRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kExit];
    return [self requestWithURL:url parameters:parameters success:success failure:failure];
}


#pragma mark - 请求的公共方法

+ (NSURLSessionTask *)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(CBRequestSuccess)success failure:(CBRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    [CBNetworkHelper setValue:@"9" forHTTPHeaderField:@"fromType"];
    
    // 发起请求
    return [CBNetworkHelper POST:URL parameters:parameter success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);
        
    } failure:^(NSError *error) {
        // 同上
        failure([CBNetErrorHelper handleErrorMessage:error]);
    }];
}

@end
