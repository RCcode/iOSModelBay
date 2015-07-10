//
//  MB_EditSummaryViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/6.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

//index代表修改那个属性，optionIndex代表修改为了那个值
typedef void(^changeBlock)(NSInteger index, NSInteger optionIndex);

@interface MB_EditSummaryViewController : MB_BaseViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) changeBlock blcok;

@end
