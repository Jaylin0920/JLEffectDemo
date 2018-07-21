//
//  UserInfoManager.h
//  CacheManager
//
//  Created by 俊欧巴 on 2018/7/16.
//  Copyright © 2018年 俊欧巴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject
/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (instancetype)sharedInstance;
/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (void)configInfo:(NSDictionary *)infoDic;
/**
 *
 用户退出登录的操作
 *
 */
+ (void)loginOut;

@end
