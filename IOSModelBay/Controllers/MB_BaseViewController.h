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

//添加下拉刷新
- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

//添加上拉加载更多
- (void)addFooterRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

//结束刷新动画
- (void)endRefreshingForView:(UIScrollView *)scrollView;

//没有更多数据时调用
- (void)showNoMoreMessage;

@end
