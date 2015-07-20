//
//  MB_Collect.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_Collect : NSObject

@property (nonatomic, assign) NSInteger fid;//用户id
@property (nonatomic, strong) NSString *fname;//用户名
@property (nonatomic, strong) NSString *fpic;//用户头像
//@property (nonatomic, strong) NSInteger *createTime;//评论时间
//@property (nonatomic, strong) NSString *ufid;
@property (nonatomic, assign) NSInteger fuid;//用户id(第三方用户标识)

@property (nonatomic, assign) NSInteger state;//是否本平台用户:0.不是;1.是
@property (nonatomic, assign) NSInteger utype;//用户类型: 0,浏览;1:专业
@property (nonatomic, strong) NSString *fbackPic;//背景
@property (nonatomic, strong) NSString *fcareerId;//职业id,竖线分割:1|2|3

@end
