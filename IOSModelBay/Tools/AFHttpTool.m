//
//  AFHttpTool.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/4.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "AFHttpTool.h"

#define baseUrl @""

//#define ContentType @"text/html"
//#define ContentType @"text/plain"

@implementation AFHttpTool

static AFHttpTool *httpTool = nil;
+ (instancetype)shareTool {
    
    if (httpTool == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            httpTool = [[AFHttpTool alloc] init];
            httpTool.manager = [AFHTTPRequestOperationManager manager];
        });
    }
    return httpTool;
}


- (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    url = [NSString stringWithFormat:@"%@%@",baseUrl,url];
//#ifdef ContentType
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
//#endif
//    _manager.requestSerializer.HTTPShouldHandleCookies = YES;
    switch (methodType) {
        case RequestTypeGet:
        {
            //GET请求
            [_manager GET:url parameters:params
             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                 if (success) {
                     success(responseObj);
                 }
             } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 if (failure) {
                     failure(error);
                 }
             }];
        }
            break;
        case RequestTypePost:
        {
            //POST请求
            [_manager POST:url parameters:params
              success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                  if (success) {
                      success(responseObj);
                  }
              } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                  if (failure) {
                      failure(error);
                  }
              }];
        }
            break;
        default:
            break;
    }
}

- (void)loginWithCodeString:(NSString *)codeStr
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure {
    
    //获取token
    NSDictionary *params = @{@"client_id":kClientID,
                             @"client_secret":kClientSecret,
                             @"grant_type":@"authorization_code",
                             @"redirect_uri":kRedirectUri,
                             @"code":codeStr};
    NSString *url =  @"https://api.instagram.com/oauth/access_token?scope=likes+relationships";
    [_manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary*)responseObject;
        NSLog(@"%@",resultDic);
        //获取用户信息
        NSString *userurl= [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/",resultDic[@"user"][@"id"]];
        NSDictionary *userParams = @{@"access_token":resultDic[@"access_token"]};
        
        [_manager GET:userurl parameters:userParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            //服务器登录
            [self loginWithParameters:userParams success:^(id response) {
                NSLog(@"login  %@",response);
                success(response);
            } failure:^(NSError *err) {
                failure(err);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//login
- (void)loginWithParameters:params
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                              url:@"email_login"
                           params:params
                          success:success
                          failure:failure];
}

@end
