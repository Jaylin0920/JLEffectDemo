//
//  CBInterfacedConst.m
//  CacheManager
//
//  Created by 俊欧巴 on 2018/7/16.
//  Copyright © 2018年 俊欧巴. All rights reserved.
//

#import "CBInterfacedConst.h"

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"接口服务器的请求前缀 例: http://192.168.10.10:8080";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#endif

/** 登录*/
NSString *const kLogin = @"/login";
/** 平台会员退出*/
NSString *const kExit = @"/exit";
