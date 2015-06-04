//
//  AFHttpTool.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/4.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestTypePost = 1,
    RequestTypeGet = 2
};

@interface AFHttpTool : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

+ (instancetype)shareTool;

//发送一个请求
- (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;

//instragram登录
- (void)loginWithCodeString:(NSString *)codeStr
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure;
//登录
- (void)loginWithParameters:params
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure;






@end
