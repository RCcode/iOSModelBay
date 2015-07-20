//
//  MB_Comment.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_Comment : NSObject

@property (nonatomic, assign) NSInteger fid;//赞用户id
@property (nonatomic, strong) NSString *fname;//赞用户名
@property (nonatomic, strong) NSString *ffullName;//赞用户全名
@property (nonatomic, strong) NSString *fpic;//赞用户头像
@property (nonatomic, strong) NSString *comment;//评论内容
@property (nonatomic, assign) NSInteger create_time;//消息时间(时间戳)

@property (nonatomic, strong) NSString *fbackPic;//赞用户头像
@property (nonatomic, assign) NSInteger utype;//用户类型: 0,浏览;1:专业
@property (nonatomic, assign) NSInteger state;//是否本平台用户:0.不是;1.是
@property (nonatomic, strong) NSString *careerId;//职业id,竖线分割:1|2|3

@property (nonatomic, assign) NSInteger fuid;//用户id(第三方用户标识)

@end
