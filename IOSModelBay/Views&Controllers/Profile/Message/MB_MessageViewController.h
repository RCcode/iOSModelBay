//
//  MB_MessageViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_MessageViewController : MB_BaseViewController

@property (nonatomic, assign) CGRect containerViewRect;

//留言
- (void)commentWitnComment:(NSString *)comment;
//回复
- (void)replywithReply:(NSString *)reply;

@end
