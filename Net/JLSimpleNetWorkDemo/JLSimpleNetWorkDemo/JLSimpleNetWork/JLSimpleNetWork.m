//
//  JLSimpleNetWork.m
//  JLSimpleNetWork
//
//  Created by JiBaoBao on 2017/7/3.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import "JLSimpleNetWork.h"

@implementation JLSimpleNetWork

+ (void)requestWithMethod:(JLSimpleNetWorkHTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(reqSuccessBlock)success
          WithFailurBlock:(reqFailureBlock)failure {
    switch (method) {
        case JLSimpleNetWorkHTTPMethodGET:{
            [self getWithUrlString:path parameters:params success:^(NSDictionary *dic) {
                success(dic);
            } failure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
        case JLSimpleNetWorkHTTPMethodPOST:{
            [self postWithUrlString:path parameters:params success:^(NSDictionary *dic) {
                success(dic);
            } failure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

+ (void)getWithUrlString:(NSString *)url
              parameters:(id)parameters
                 success:(reqSuccessBlock)successBlock
                 failure:(reqFailureBlock)failureBlock {
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    if ([parameters allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in parameters) {
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failureBlock(error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];
}

+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(reqSuccessBlock)successBlock failure:(reqFailureBlock)failureBlock {
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [request setHTTPShouldHandleCookies:NO];
    
    //设置请求类型
    request.HTTPMethod = @"POST";
    //设置请求头
    [request setValue:@"1.0.0" forHTTPHeaderField:@"Version"];//版本
//    NSLog(@"POST-Header:%@",request.allHTTPHeaderFields);
    //把参数放到请求体内
    NSString *postStr = [JLSimpleNetWork parseParams:parameters];
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            failureBlock(error);
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];  //开始请求
}

#pragma mark - private method

+ (NSString *)parseParams:(NSDictionary *)params {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
//    [parameters setValue:@"ios" forKey:@"client"];
//    [parameters setValue:@"请替换版本号" forKey:@"auth_version"];
//    NSString* phoneModel = @"获取手机型号" ;
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//ios系统版本号
//    NSString *system = [NSString stringWithFormat:@"%@(%@)",phoneModel, phoneVersion];
//    [parameters setValue:system forKey:@"system"];
//    NSDate *date = [NSDate date];
//    NSTimeInterval timeinterval = [date timeIntervalSince1970];
//    [parameters setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];//请求时间戳
//    NSString *devicetoken = @"请替换DeviceToken";
//    [parameters setValue:devicetoken forKey:@"uuid"];
//    NSLog(@"请求参数:%@",parameters);
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    NSEnumerator *keyEnum = [parameters keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}

@end
