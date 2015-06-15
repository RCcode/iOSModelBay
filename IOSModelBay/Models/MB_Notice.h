//
//  MB_Notice.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

//动态
@interface MB_Notice : NSObject

@property (nonatomic, strong) NSString *mid;      //用于分页
@property (nonatomic, strong) NSString *mtype;    //消息类型:0.收藏;1.相片提起;2.赞相片;3.评论相片;4.留言;5.回复留言
@property (nonatomic, strong) NSString *fid;      //消息用户id
@property (nonatomic, strong) NSString *fname;    //消息用户名
//@property (nonatomic, strong) NSString *ffullName;//用户全名
//@property (nonatomic, strong) NSString *fgender;  //性别:0.女;1.男
@property (nonatomic, strong) NSString *fpic;     //消息用户头像
//@property (nonatomic, strong) NSString *fbackPic; //背景
//@property (nonatomic, strong) NSString *fcareerId;//职业id,竖线分割:1|2|3
@property (nonatomic, strong) NSString *mpic;     //评论关联图片.当mtype为1,2,3时生效
@property (nonatomic, strong) NSString *comment;  //mtype为4:评论内容,5:回复内容
@property (nonatomic, strong) NSString *create_time;//消息时间(时间戳)

@end
