//
//  MB_Ablum.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

//作品集
@interface MB_Ablum : NSObject

@property (nonatomic, strong) NSString *ablId;  //相册id
@property (nonatomic, strong) NSString *uid;    //用户id
@property (nonatomic, strong) NSString *atype;  //影集分类:0.拼图;1.相片集
@property (nonatomic, strong) NSString *name;   //影集名称
@property (nonatomic, strong) NSString *descr;  //影集描述
@property (nonatomic, strong) NSString *cover;  //封面图片,当atype为0时为内容
@property (nonatomic, strong) NSString *mId;    //模特id
@property (nonatomic, strong) NSString *mName;  //模特名
@property (nonatomic, strong) NSString *pId;    //摄影师id
@property (nonatomic, strong) NSString *pName;  //摄影师名
@property (nonatomic, strong) NSString *hId;    //发型师id
@property (nonatomic, strong) NSString *hName;  //发型师名
@property (nonatomic, strong) NSString *mkId;   //化妆师id
@property (nonatomic, strong) NSString *mkName; //化妆师名
@property (nonatomic, strong) NSString *likes;  //赞个数
@property (nonatomic, strong) NSString *comments;//评论数
@property (nonatomic, strong) NSString *mlist;  //相片列表

@end
