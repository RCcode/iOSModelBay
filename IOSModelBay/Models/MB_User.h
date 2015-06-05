//
//  MB_User.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户
@interface MB_User : NSObject

//@property (nonatomic, strong) NSString *uid;      //模特平台用户唯一标识
//@property (nonatomic, strong) NSString *follow;   //收藏数
//@property (nonatomic, strong) NSString *followed; //被收藏数
//@property (nonatomic, strong) NSString *utype;    //用户类型: 0,浏览;1:专业;
//@property (nonatomic, strong) NSString *uname;    //本平台登录用户名
//@property (nonatomic, strong) NSString *gender;   //性别:0.女;1.男
//@property (nonatomic, strong) NSString *careerId; //职业id,竖线分割:1|2|3
//@property (nonatomic, strong) NSString *pic;      //头像
//@property (nonatomic, strong) NSString *backPic;  //背景

@property (nonatomic, strong) NSString *fid;       //赞用户id
@property (nonatomic, strong) NSString *fname;     //赞用户名
@property (nonatomic, strong) NSString *ffullName; //赞用户全名
@property (nonatomic, strong) NSString *fgender;   //性别:0.女;1.男
@property (nonatomic, strong) NSString *fpic;      //赞用户头像
@property (nonatomic, strong) NSString *fbackPic;  //背景
@property (nonatomic, strong) NSString *fcareerId; //职业id,竖线分割:1|2|3

@property (nonatomic, strong) NSString *comment;   //评论内容

@end
