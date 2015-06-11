//
//  MB_SelectCareerViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SexType){
    SexTypeMale,
    SexTypeFemale,
};

@interface MB_SelectCareerViewController : UIViewController

@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) SexType sexType;

@end
