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

//用户名校验
- (void)checkNameWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure;

//注册
- (void)registWithParameters:params
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure;

//获取用户动态
- (void)getNoticeWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure;

//获取推荐人员搜索 & 按条件搜索用户
- (void)findUserWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure;

//获取排行榜用户
- (void)getRankListWithParameters:params
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError* err))failure;

//获取用户详细信息
- (void)getUerDetailWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure;

//修改用户详细信息
- (void)updateUserDetailWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure;

//修改用户头像
- (void)updateUserPicWithParameters:params
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError* err))failure;

//修改用户背景
- (void)updateBackgroundWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure;

//获取用户作品集
- (void)getAblumWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure;

//获取作品集赞列表
- (void)getAblumLikesWithParameters:params
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError* err))failure;

//赞作品集
- (void)likeAblumWithParameters:params
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure;

//获取作品集评论列表
- (void)getAblumCommentsWithParameters:params
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError* err))failure;

//评论作品集
- (void)commentAblumWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure;

//发布作品集
- (void)addAblumWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure;

//上传图片
- (void)uploadPicWithParameters:params
                         images:(NSArray *)images
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure;

//获取用户留言列表
- (void)getMessagesWithParameters:params
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError* err))failure;

//添加用户留言
- (void)addMessageWithParameters:params
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError* err))failure;

//回复留言
- (void)replyMessageWithParameters:params
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure;

//获取收藏列表
- (void)getLikesWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure;

//添加收藏列表
- (void)addLikesWithParameters:params
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure;

//提交pushkey
- (void)updatePushKeyWithParameters:params
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError* err))failure;


@end
