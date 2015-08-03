//
//  MB_SearchViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_SelectUserViewController.h"

typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeUser,//从发现界面跳转过来
    SearchTypeAblum//影集添加相关人物
};

//typedef void(^SlectBlock)(NSInteger fid, NSString *fname);
@interface MB_SearchViewController : MB_BaseViewController

@property (nonatomic, assign)SearchType searchType;
//@property (nonatomic, copy)SlectBlock block;

@property (nonatomic, weak)MB_SelectUserViewController *selectUserVC;

@end
