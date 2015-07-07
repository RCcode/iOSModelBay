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

@end
