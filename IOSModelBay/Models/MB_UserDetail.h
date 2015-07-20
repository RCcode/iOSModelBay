//
//  MB_UserDetail.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_UserDetail : NSObject

@property (nonatomic, assign) NSInteger uid;//用户id
@property (nonatomic, strong) NSString *name;//用户名
@property (nonatomic, strong) NSString *pic;//用户头像
@property (nonatomic, strong) NSString *backPic;//背景
@property (nonatomic, strong) NSString *careerId;//职业id,竖线分割:1|2|3
@property (nonatomic, assign) NSInteger state;//是否本平台用户:0.不是;1.是
@property (nonatomic, strong) NSString *bio;//描述
@property (nonatomic, assign) NSInteger gender;//性别:0.女;1.男;
@property (nonatomic, strong) NSString *country;//国家
@property (nonatomic, assign) NSInteger age;//年龄
@property (nonatomic, assign) NSInteger btype;//分享年龄:0.是;1.否
@property (nonatomic, strong) NSString *contact;//联系方式
@property (nonatomic, assign) NSInteger ctype;//分享联系方式:0.是;1.否
@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, assign) NSInteger etype;//分享游戏：0是；1否
@property (nonatomic, strong) NSString *website;//网站
@property (nonatomic, strong) NSString *experience;//经验
@property (nonatomic, assign) NSInteger height;//身高cm
@property (nonatomic, assign) NSInteger weight;//体重kg
@property (nonatomic, assign) NSInteger chest;//胸围cm
@property (nonatomic, assign) NSInteger waist;//腰围cm
@property (nonatomic, assign) NSInteger hips;//臀围cm
@property (nonatomic, strong) NSString *eyecolor;//眼睛颜色
@property (nonatomic, strong) NSString *skincolor;//皮肤颜色
@property (nonatomic, strong) NSString *haircolor;//头发颜色
@property (nonatomic, strong) NSString *shoesize;//鞋号
@property (nonatomic, strong) NSString *dress;//衣号

@property (nonatomic, strong) NSString *fareas;//专注领域|线分割:1|2|3

@property (nonatomic, strong) NSMutableArray *arrayModel;
@property (nonatomic, strong) NSMutableArray *arrayPhoto;

@end
