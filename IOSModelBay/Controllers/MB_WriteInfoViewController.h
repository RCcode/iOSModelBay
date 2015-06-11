//
//  MB_WriteInfoViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RoleType){
    RoleTypeProfessional,
    RoleTypeAudience
};

@interface MB_WriteInfoViewController : UIViewController

@property (nonatomic, assign) RoleType roleType;

@end
