//
//  MB_Comment.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_Comment : NSObject

@property (nonatomic, strong) NSString *fid;//赞用户id
@property (nonatomic, strong) NSString *fname;//赞用户名
@property (nonatomic, strong) NSString *ffullName;//赞用户全名
@property (nonatomic, strong) NSString *fpic;//赞用户头像
@property (nonatomic, strong) NSString *comment;//评论内容
@property (nonatomic, assign) NSTimeInterval createTime;//消息时间(时间戳)

@end