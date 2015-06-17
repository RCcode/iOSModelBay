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

//记录筛选条件:名字 性别 职业
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString  *careerId;

@property (nonatomic, strong) NSDictionary *careerDic;

+ (void)showPromptWithText:(NSString *)text;

+ (void)showAlertViewWithMessage:(NSString *)string;

//+ (NSInteger)statFromResponse:(id)response;
@end
