//
//  MB_User.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户
@interface MB_User : NSObject

@property (nonatomic, assign) NSInteger  fid;       //用户id
@property (nonatomic, assign) NSInteger  uid;       //第三方平台id
@property (nonatomic, assign) NSInteger  state;     //是否本平台用户:0.不是;1.是
@property (nonatomic, assign) NSInteger  fgender;   //性别:0.女;1.男
@property (nonatomic, assign) NSInteger  liked;     //被赞数
@property (nonatomic, strong) NSString  *fname;     //用户名
@property (nonatomic, strong) NSString  *ffullName; //用户全名
@property (nonatomic, strong) NSString  *fpic;      //用户头像
@property (nonatomic, strong) NSString  *fbackPic;  //背景
@property (nonatomic, strong) NSString  *fcareerId; //职业id,竖线分割:1|2|3

@property (nonatomic, strong) NSMutableArray *urlArray;

@end
