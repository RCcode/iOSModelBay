//
//  MB_SelectCareerViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SexType){
    SexTypeFemale = 0,
    SexTypeMale,
};

@interface MB_SelectCareerViewController : MB_BaseViewController

@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) SexType sexType;

@end
