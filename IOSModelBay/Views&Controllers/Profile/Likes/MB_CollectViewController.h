//
//  MB_ FavoritesViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"

@interface MB_CollectViewController : MB_BaseViewController

@property (nonatomic, assign) CGRect containerViewRect;
@property (nonatomic, strong) MB_User *user;

@end
