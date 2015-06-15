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

//结束头部刷新动画
- (void)endHeaderRefreshingForView:(UIScrollView *)scrollView;
//结束尾部刷新动画
- (void)endFooterRefreshingForView:(UIScrollView *)scrollView;
//结束头部和尾部刷新动画
- (void)endRefreshingForView:(UIScrollView *)scrollView;

//没有更多数据时调用
- (void)showNoMoreMessageForview:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (NSInteger)statFromResponse:(id)response;

@end
