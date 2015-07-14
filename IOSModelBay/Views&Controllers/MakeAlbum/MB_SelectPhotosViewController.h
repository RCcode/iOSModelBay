//
//  MB_SelectPhotosViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger, SelectType) {
    SelectTypeOne,
    SelectTypeAll,
};

typedef void(^AddOneImageBlcok)(NSURL* url);

@interface MB_SelectPhotosViewController : MB_BaseViewController

@property (nonatomic, assign) SelectType type;

@property (nonatomic, copy) AddOneImageBlcok block;

@end
