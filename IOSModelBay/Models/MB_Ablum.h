//
//  MB_Ablum.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AblumType) {
    AblumTypeTemplate = 0,
    AblumTypeCollect,
};

//作品集
@interface MB_Ablum : NSObject

@property (nonatomic, assign) NSInteger ablId;  //相册id
@property (nonatomic, assign) NSInteger uid;    //用户id
@property (nonatomic, assign) AblumType atype;  //影集分类:0.拼图;1.相片集
@property (nonatomic, strong) NSString *name;   //影集名称
@property (nonatomic, strong) NSString *descr;  //影集描述
@property (nonatomic, strong) NSString *cover;  //封面图片,当atype为0时为内容
@property (nonatomic, assign) NSInteger mId;    //模特id
@property (nonatomic, strong) NSString *mName;  //模特名
@property (nonatomic, assign) NSInteger pId;    //摄影师id
@property (nonatomic, strong) NSString *pName;  //摄影师名
@property (nonatomic, assign) NSInteger hId;    //发型师id
@property (nonatomic, strong) NSString *hName;  //发型师名
@property (nonatomic, assign) NSInteger mkId;   //化妆师id
@property (nonatomic, strong) NSString *mkName; //化妆师名
@property (nonatomic, assign) NSInteger likes;  //赞个数
@property (nonatomic, assign) NSInteger comments;//评论数
@property (nonatomic, strong) NSArray  *mList;  //相片列表

//mList =             (
//                     {
//                         ablId = 40;
//                         url = "http://192.168.0.86:8086/modelbay/7dc2240d-2c7f-43f9-af15-39dc7c90c505.png";
//                     }
//                     );

@end
