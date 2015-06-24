//
//  AFHttpTool.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/4.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "AFHttpTool.h"

//#define kBaseUrl             @"http://192.168.0.86:8082/ModelBay/"
#define kBaseUrl             @"http://192.168.0.89:8082/ModelBayWeb/"

#define kLoginUrl            @"user/login.do"
#define kCheckNameUrl        @"user/checkName.do"
#define kRegistUrl           @"user/register.do"
#define kGetNoticeUrl        @"user/getUserMessage.do"
#define kFindUserUrl         @"user/findUser.do"
#define kGetRankUrl          @"user/getRankList.do"
#define kGetUserDetailUrl    @"user/getUserDetail.do"
#define kUpdateUserDetailUrl @"user/updateUserDetail.do"
#define kUpdateUserPicUrl    @"user/updatUPic.do"
#define kUpdateBackgroudUrl  @"user/updateBackgroud.do"
#define kGetAblumUrl         @"ablum/getAblum.do"
#define kGetAblumLikesUrl    @"ablum/getAblumLikes.do"
#define kLikeAblumUrl        @"ablum/likeAblum.do"
#define kGetAblumCommentsUrl @"ablum/getAblumComments.do"
#define kCommentAblumUrl     @"ablum/commentAblum.do"
#define kAddAblumUrl         @"ablum/addAblum.do"
#define kUploadPicUrl        @"ablum/uploadPic.do"
#define kGetMessagesUrl      @"user/getComments.do"
#define kAddMessageUrl       @"user/addComment.do"
#define kReplyMessageUrl     @"user/replyComment.do"
#define kGetLikesUrl         @"user/getLikes.do"

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
            httpTool.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            httpTool.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
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
    url = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    NSLog(@"url = %@",url);
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
                         NSLog(@"sdsdsdsd%@",responseObj);
                         success(responseObj);
                     }
                 } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                     if (failure) {
                         NSLog(@"error == %@",error);
                         failure(error);
                     }
                 }];
                break;
            }
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
                          NSLog(@"error == %@",error);
                          failure(error);
                      }
                  }];
                break;
            }
        default:
            break;
    }
}

//instragram登录
- (void)loginWithCodeString:(NSString *)codeStr
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure {
    //获取token
    NSDictionary *params = @{@"client_id":kClientID,
                             @"client_secret":kClientSecret,
                             @"grant_type":@"authorization_code",
                             @"redirect_uri":kRedirectUri,
                             @"code":codeStr};
    NSString *url =  @"https://api.instagram.com/oauth/access_token?scope=relationships";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--%@",responseObject);
        
        [userDefaults setObject:responseObject[@"user"][@"id"] forKey:kUid];
        [userDefaults setObject:responseObject[@"user"][@"username"] forKey:kUsername];
        [userDefaults setObject:responseObject[@"user"][@"full_name"] forKey:kFullname];
        [userDefaults setObject:responseObject[@"user"][@"profile_picture"] forKey:kPic];
        [userDefaults setObject:responseObject[@"access_token"] forKey:kAccessToken];
        [userDefaults synchronize];
        
        //服务器登录
        NSDictionary *loginParams = @{@"uid":responseObject[@"user"][@"id"],
                                      @"tplat":@(0),
                                      @"plat":@(2),
                                      @"ikey":@"a",
                                      @"akey":@"a",
                                      @"fullName":responseObject[@"user"][@"full_name"],
                                      @"token":responseObject[@"access_token"]};
        NSLog(@"%@",loginParams);
        [self loginWithParameters:loginParams success:^(id response) {
            success(response);
            
        } failure:^(NSError *err) {
            failure(err);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//instragram登录
//- (void)loginWithCodeString:(NSString *)codeStr
//                    success:(void (^)(id response))success
//                    failure:(void (^)(NSError* err))failure {
////    //获取token
////    NSDictionary *params = @{@"client_id":kClientID,
////                             @"client_secret":kClientSecret,
////                             @"grant_type":@"authorization_code",
////                             @"redirect_uri":kRedirectUri,
////                             @"code":codeStr};
////    NSString *url =  @"https://api.instagram.com/oauth/access_token?scope=likes+relationships";
////    [_manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSLog(@"--%@",responseObject);
//    
//    NSString *uid = @"1";
//    NSString *username = @"a";
//    NSString *fullName = @"a";
//    NSString *imageUrl = @"http://img1.imgtn.bdimg.com/it/u=1887538964,2552017407&fm=21&gp=0.jpg";
//    
//        //服务器登录
//        NSDictionary *loginParams = @{@"uid":uid,
//                                      @"tplat":@(0),
//                                      @"plat":@(2),
//                                      @"ikey":@"a",
//                                      @"akey":@"a",
//                                      @"userName":username,
//                                      @"fullName":fullName,
//                                      @"token":@"abcde"};
//        NSLog(@"%@",loginParams);
//        [self loginWithParameters:loginParams success:^(id response) {
//            NSLog(@"login--%@",response);
//            
//            //记录用户信息
//            [userDefaults setObject:uid forKey:kUid];
//            [userDefaults setObject:username forKey:kUsername];
//            [userDefaults setObject:fullName forKey:kFullname];
//            [userDefaults setObject:imageUrl forKey:kPic];
//            [userDefaults setObject:@"abcde" forKey:kAccessToken];
//            [userDefaults setBool:YES forKey:kIsLogin];
//            [userDefaults synchronize];
//            
//            success(response);
//            
//        } failure:^(NSError *err) {
//            NSLog(@"%@",err);
//            failure(err);
//        }];
//        
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        failure(error);
////    }];
//}


//登录
- (void)loginWithParameters:params
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kLoginUrl
                     params:params
                    success:success
                    failure:failure];
}

//用户名校验
- (void)checkNameWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kCheckNameUrl
                     params:params
                    success:success
                    failure:failure];
}

//注册
- (void)registWithParameters:params
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kRegistUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取用户动态
- (void)getNoticeWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetNoticeUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取推荐人员搜索 & 按条件搜索用户
- (void)findUserWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kFindUserUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取排行榜用户
- (void)getRankListWithParameters:params
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetRankUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取用户详细信息
- (void)getUerDetailWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetUserDetailUrl
                     params:params
                    success:success
                    failure:failure];
}

//修改用户详细信息
- (void)updateUserDetailWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kUpdateUserDetailUrl
                     params:params
                    success:success
                    failure:failure];
}

//修改用户头像
- (void)updateUserPicWithParameters:params
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kUpdateUserPicUrl
                     params:params
                    success:success
                    failure:failure];
}

//修改用户背景
- (void)updateBackgroundWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kUpdateBackgroudUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取用户作品集
- (void)getAblumWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetAblumUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取作品集赞列表
- (void)getAblumLikesWithParameters:params
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetAblumLikesUrl
                     params:params
                    success:success
                    failure:failure];
}

//赞作品集
- (void)likeAblumWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kLikeAblumUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取作品集评论列表
- (void)getAblumCommentsWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetAblumCommentsUrl
                     params:params
                    success:success
                    failure:failure];
}

//评论作品集
- (void)commentAblumWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kCommentAblumUrl
                     params:params
                    success:success
                    failure:failure];
}

//发布作品集
- (void)addAblumWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kAddAblumUrl
                     params:params
                    success:success
                    failure:failure];
}

//上传图片
- (void)uploadPicWithParameters:params
                         images:(NSArray *)images
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,kUploadPicUrl];
    AFHTTPRequestOperation *operation = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < images.count; i ++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"anyImage_%d.jpg",i] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    NSLog(@"%@",operation);
    __weak AFHTTPRequestOperation *weakOpera = operation;
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%@",weakOpera);
        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
    }];
}

//获取用户留言列表
- (void)getMessagesWithParameters:params
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetMessagesUrl
                     params:params
                    success:success
                    failure:failure];
}

//添加用户留言
- (void)addMessageWithParameters:params
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kAddMessageUrl
                     params:params
                    success:success
                    failure:failure];
}

//回复留言
- (void)replyMessageWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kReplyMessageUrl
                     params:params
                    success:success
                    failure:failure];
}

//获取收藏列表
- (void)GetLikesWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure
{
    [self requestWihtMethod:RequestTypePost
                        url:kGetLikesUrl
                     params:params
                    success:success
                    failure:failure];
}


@end
