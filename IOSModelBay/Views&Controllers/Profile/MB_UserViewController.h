//
//  MB_UserViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"

#define topViewHeight 186

typedef  NS_ENUM(NSInteger, ComeFromType) {
    ComeFromTypeSelf = 0,//看自己
    ComeFromTypeUser,//看其他用户
    ComeFromTypeAblum
};

@interface MB_UserViewController : MB_BaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) ComeFromType comeFromType;

@property (nonatomic, strong) MB_User *user;


@property (nonatomic, assign) NSInteger fid;

@property (nonatomic, assign) NSInteger menuIndex;//进来的时候默认选中哪个菜单按钮

- (void)showCommentView;
- (void)hideCommentView;
- (void)clearCommentText;

@end
