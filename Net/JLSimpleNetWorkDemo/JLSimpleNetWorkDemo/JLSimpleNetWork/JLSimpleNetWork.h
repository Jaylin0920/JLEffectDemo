//
//  JLSimpleNetWork.h
//  JLSimpleNetWork
//
//  Created by JiBaoBao on 2017/7/3.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    JLSimpleNetWorkHTTPMethodGET,
    JLSimpleNetWorkHTTPMethodPOST,
} JLSimpleNetWorkHTTPMethod;

//请求成功回调block
typedef void (^reqSuccessBlock)(NSDictionary *dic);
//请求失败回调block
typedef void (^reqFailureBlock)(NSError *error);

@interface JLSimpleNetWork : NSObject

+ (void)requestWithMethod:(JLSimpleNetWorkHTTPMethod)method
                 WithPath:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(reqSuccessBlock)success
          WithFailurBlock:(reqFailureBlock)failure;

+ (void)postWithUrlString:(NSString *)url
               parameters:(id)parameters
                  success:(reqSuccessBlock)successBlock
                  failure:(reqFailureBlock)failureBlock;

+ (void)getWithUrlString:(NSString *)url
              parameters:(id)parameters
                 success:(reqSuccessBlock)successBlock
                 failure:(reqFailureBlock)failureBlock;


@end
