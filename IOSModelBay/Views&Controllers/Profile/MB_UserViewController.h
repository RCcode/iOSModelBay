//
//  MB_UserViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"

typedef  NS_ENUM(NSInteger, ComeFromType) {
    ComeFromTypeUser,
    ComeFromTypeSelf
};

@interface MB_UserViewController : MB_BaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) ComeFromType comeFromType;

@property (nonatomic, strong) MB_User *user;

@end
