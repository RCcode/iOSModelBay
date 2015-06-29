//
//  MB_UserDetail.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_UserDetail : NSObject

@property (nonatomic, strong) NSString *id;//用户id
@property (nonatomic, strong) NSString *name;//用户名
@property (nonatomic, strong) NSString *pic;//用户头像
@property (nonatomic, strong) NSString *backPic;//背景
@property (nonatomic, strong) NSString *careerId;//职业id,竖线分割:1|2|3
@property (nonatomic, strong) NSString *state;//是否本平台用户:0.不是;1.是
@property (nonatomic, strong) NSString *bio;//描述
@property (nonatomic, strong) NSString *gender;//性别:0.女;1.男;-1隐藏
@property (nonatomic, strong) NSString *country;//国家
@property (nonatomic, strong) NSString *age;//年龄:-1隐藏
@property (nonatomic, strong) NSString *contact;//联系方式,null为隐藏
@property (nonatomic, strong) NSString *email;//邮箱, null为隐藏
@property (nonatomic, strong) NSString *website;//网站, null为隐藏
@property (nonatomic, strong) NSString *experience;//经验
@property (nonatomic, strong) NSString *height;//身高cm
@property (nonatomic, strong) NSString *weight;//体重kg
@property (nonatomic, strong) NSString *chest;//胸围cm
@property (nonatomic, strong) NSString *waist;//腰围cm
@property (nonatomic, strong) NSString *hips;//臀围cm
@property (nonatomic, strong) NSString *eyecolor;//眼睛颜色
@property (nonatomic, strong) NSString *skincolor;//皮肤颜色
@property (nonatomic, strong) NSString *haircolor;//头发颜色
@property (nonatomic, strong) NSString *shoesize;//鞋号
@property (nonatomic, strong) NSString *dress;//衣号

@end
