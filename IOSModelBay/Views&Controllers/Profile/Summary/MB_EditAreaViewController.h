//
//  MB_EditAreaViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/15.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

//修改那个专注领域
typedef NS_ENUM(NSInteger, EditName){
    EditNameAreaModel,
    EditNameAreaPhoto
};

typedef void(^ChangeBlock)(NSMutableArray *array);

@interface MB_EditAreaViewController : MB_BaseViewController

@property (nonatomic, assign) EditName name;

@property (nonatomic, copy) ChangeBlock block;

@end
