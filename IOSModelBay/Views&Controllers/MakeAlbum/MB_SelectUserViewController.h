//
//  MB_SelectUserViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/17.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Collect.h"

typedef void(^SelectSuccessBlock)(MB_Collect * user);

@interface MB_SelectUserViewController : MB_BaseViewController

@property (nonatomic, copy) SelectSuccessBlock selectBlock;

@end
