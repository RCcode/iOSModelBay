//
//  MB_FilterViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteHandler)(void);

@interface MB_FilterViewController : MB_BaseViewController

@property (nonatomic, copy) CompleteHandler CompleteHandler;

@end
