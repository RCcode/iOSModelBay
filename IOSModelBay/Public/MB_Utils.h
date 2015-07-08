//
//  MB_Utils.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_Utils : NSObject

+ (instancetype)shareUtil;

//记录发现页面筛选条件:名字 性别 职业
@property (nonatomic, strong) NSString  *fName;
@property (nonatomic, assign) NSInteger fGender;
@property (nonatomic, strong) NSString  *fCareerId;

//记录排行页面筛选条件: 性别 职业
@property (nonatomic, assign) NSInteger rGender;
@property (nonatomic, strong) NSString  *rCareerId;

//所有职业
@property (nonatomic, strong) NSDictionary *careerDic;

@property (nonatomic, strong) NSArray *eyeColor;//眼睛颜色
@property (nonatomic, strong) NSArray *skincolor;//肤色
@property (nonatomic, strong) NSArray *haircolor;//发色
@property (nonatomic, strong) NSArray *shoesize;//鞋号
@property (nonatomic, strong) NSArray *dress;//衣服号
@property (nonatomic, strong) NSArray *height;//身高
@property (nonatomic, strong) NSArray *weight;//体重
@property (nonatomic, strong) NSArray *chest;//胸围
@property (nonatomic, strong) NSArray *waist;//腰围
@property (nonatomic, strong) NSArray *hips;//臀围
//@property (nonatomic, strong) NSArray *careerDic;//专注领域-模特
//@property (nonatomic, strong) NSArray *careerDic;//专注领域-摄影师
@property (nonatomic, strong) NSArray *experience;//经验

+ (void)showPromptWithText:(NSString *)text;

+ (void)showAlertViewWithMessage:(NSString *)string;

//+ (NSInteger)statFromResponse:(id)response;


//用指定时区的时间戳算出当前时区应当显示的时间 timeZone格式：(+08)
+ (NSString *)dateWithTimeInterval:(double)timeInterval fromTimeZone:(NSString *)zone;
@end
