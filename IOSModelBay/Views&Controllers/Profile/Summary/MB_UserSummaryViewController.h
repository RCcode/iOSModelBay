//
//  MB_UserSummaryViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"
#import "MB_UserViewController.h"
#import "MB_UserDetail.h"

typedef void(^SaveSuccessBlock)(void);
@interface MB_UserSummaryViewController : MB_BaseViewController

@property (nonatomic, strong) NSMutableArray *areaArray;//专注领域(包括模特或者摄影师或者没有)
@property (nonatomic, strong) MB_User *user;

@property (nonatomic, strong) MB_UserDetail *detail;
@property (nonatomic, strong) MB_UserDetail *changeDetail;

@property (nonatomic, copy) SaveSuccessBlock saveSuccessBlock;

@end
