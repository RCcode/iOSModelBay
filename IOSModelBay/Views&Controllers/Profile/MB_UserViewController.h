//
//  MB_UserViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"

@interface MB_UserViewController : MB_BaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MB_User *user;

@end
