//
//  MB_UserDetailViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/22.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"
#import "MB_UserViewController.h"

@interface MB_UserDetailViewController : MB_BaseViewController

@property (nonatomic, assign) CGRect containerViewRect;
@property (nonatomic, assign) ComeFromType comeFromType;
@property (nonatomic, strong) MB_User *user;

@end
