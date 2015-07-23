//
//  MB_LoginViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginSuccessBlock)(NSString *codeStr);

@interface MB_LoginViewController : UIViewController

@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;//登录成功后的回调

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)success;

@end
