//
//  MB_Message.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StateType) {
    StateTypeMessage = 0,//没有回复
    StateTypeReply//有回复
};

@interface MB_Message : NSObject

@property (nonatomic, assign) NSInteger  ucid;//评论id,用于回复
@property (nonatomic, assign) NSInteger  fid;//评论用户id
@property (nonatomic, assign) NSInteger  fuid;//第三方id
@property (nonatomic, strong) NSString * fname;//评论用户名
@property (nonatomic, strong) NSString * fpic;//评论用户头像
@property (nonatomic, strong) NSString * fbackPic;//评论用户头像
@property (nonatomic, strong) NSString * fcareerId;//评论用户头像
@property (nonatomic, assign) NSInteger  futype;//评论用户id
@property (nonatomic, assign) NSInteger  fstate;//评论用户id

@property (nonatomic, strong) NSString * comment;//评论内容
@property (nonatomic, assign) NSInteger  createTime;//评论时间
@property (nonatomic, assign) StateType  state;//是否有回复:0.无;1.有(为1下列属性有效)
@property (nonatomic, assign) NSInteger  uid;//用户id
@property (nonatomic, assign) NSInteger  ruid;//第三方id
@property (nonatomic, strong) NSString * reply;//回复内容
@property (nonatomic, assign) NSInteger  replyTime;//回复时间

@property (nonatomic, strong) NSString * rname;
@property (nonatomic, strong) NSString * rpic;
@property (nonatomic, strong) NSString * rbackPic;
@property (nonatomic, assign) NSInteger  rutype;
@property (nonatomic, assign) NSInteger  rstate;
@property (nonatomic, strong) NSString * rcareerId;


@end
