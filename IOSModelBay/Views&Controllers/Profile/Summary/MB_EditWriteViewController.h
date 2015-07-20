//
//  MB_EditAgeViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/14.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextBlock)(NSInteger index, NSString *text, BOOL hide);

@interface MB_EditWriteViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, copy) TextBlock blcok;

@end
