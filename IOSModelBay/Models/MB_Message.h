//
//  MB_Message.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_Message : NSObject

@property (nonatomic, strong) NSString * ucid;//评论id,用于回复
@property (nonatomic, strong) NSString * fid;//评论用户id
@property (nonatomic, strong) NSString * fname;//评论用户名
@property (nonatomic, strong) NSString * fpic;//评论用户头像
@property (nonatomic, strong) NSString * comment;//评论内容
@property (nonatomic, strong) NSString * createTime;//评论时间
@property (nonatomic, strong) NSString * state;//是否有回复:0.无;1.有(为1下列属性有效)
@property (nonatomic, strong) NSString * id;//用户id
@property (nonatomic, strong) NSString * reply;//回复内容
@property (nonatomic, strong) NSString * replyTime;//回复时间

@end
