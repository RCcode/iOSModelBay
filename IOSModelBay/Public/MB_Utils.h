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

+ (void)showPromptWithText:(NSString *)text;

+ (void)showAlertViewWithMessage:(NSString *)string;

//+ (NSInteger)statFromResponse:(id)response;
@end
