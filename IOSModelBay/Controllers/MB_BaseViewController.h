//
//  MB_BaseViewController.h
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const ReuseIdentifier = @"cell";

@interface MB_BaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *footerLabel;

- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

- (void)addFooterRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

@end
