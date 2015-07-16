//
//  MB_Notice.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NoticeType) {
    NoticeTypeCollect = 0,//收藏
    NoticeTypeMention,//提到
    NoticeTypeLike,//赞照片
    NoticeTypeComment,//评论照片
    NoticeTypeMessage,//留言
    NoticeTypeReplay//回复留言
};

//动态
@interface MB_Notice : NSObject

@property (nonatomic, assign) NSInteger mid;      //用于分页
@property (nonatomic, assign) NoticeType mtype;   //消息类型:0.收藏;1.相片提起;2.赞相片;3.评论相片;4.留言;5.回复留言
@property (nonatomic, assign) NSInteger fid;      //消息用户id
@property (nonatomic, strong) NSString *fname;    //消息用户名
@property (nonatomic, strong) NSString *fpic;     //消息用户头像
@property (nonatomic, strong) NSString *careerId; //职业
@property (nonatomic, strong) NSString *backPic;  //背景图

@property (nonatomic, strong) NSString *mpic;     //评论关联图片,当mtype为1,2,3时生效
@property (nonatomic, strong) NSString *comment;  //mtype为4:评论内容,5:回复内容
@property (nonatomic, assign) NSTimeInterval createTime;//消息时间(时间戳)

@property (nonatomic, assign) NSInteger utype;//用户类型: 0,浏览;1:专业
@property (nonatomic, assign) NSInteger state;//是否本平台用户:0.不是;1.是

@end
