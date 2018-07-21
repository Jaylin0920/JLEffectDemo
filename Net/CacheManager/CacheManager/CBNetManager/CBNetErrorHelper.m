//
//  CBNetErrorHelper.m
//  CacheManager
//
//  Created by 俊欧巴 on 2018/7/16.
//  Copyright © 2018年 俊欧巴. All rights reserved.
//

#import "CBNetErrorHelper.h"

@implementation CBNetErrorHelper

+ (NSString *)handleErrorMessage:(NSError *)error{
    
    NSString * result = nil;
    switch (error.code) {
        case kCFURLErrorTimedOut://-1001
            result = @"服务器连接超时";
            break;
        case kCFURLErrorBadServerResponse://-1011
            result = @"请求无效";
            break;
        case kCFURLErrorNetworkConnectionLost: //-1005
            result = @"网络连接已中断";
            break;
        case kCFURLErrorNotConnectedToInternet: //-1009 @"似乎已断开与互联网的连接。"
            result = @"网络连接已中断";
            break;
        case kCFURLErrorCannotDecodeContentData://-1016 cmcc 解析数据失败
            result = @"解析数据失败";
            break;
        case kCFURLErrorCannotFindHost: //-1003 @"未能找到使用指定主机名的服务器。"
            result = @"服务器内部错误";
            break;
        case -1004: //-1004 @"未能连接到服务器"
            result = @"未能连接到服务器";
            break;
        default:
            result = @"服务器响应错误";
//            NSLog(@"其他错误 error:%@", error);
            break;
    }
    
    return result;
}

@end
