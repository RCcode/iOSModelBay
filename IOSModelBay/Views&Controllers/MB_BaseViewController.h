//
//  MB_BaseViewController.h
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_NotLoginView.h"

//重用标识
static NSString * const ReuseIdentifier = @"cell";

@interface MB_BaseViewController : UIViewController

//通用数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
//导航栏标题
@property (nonatomic, strong) UILabel *titleLabel;
//未登录时的提示，点击弹出登录界面
@property (nonatomic, strong) MB_NotLoginView *notLoginView;

//没有数据时的提示
@property (nonatomic, strong) MB_NotLoginView *noResultView;

//添加下拉刷新
- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

//添加上拉加载更多
- (void)addFooterRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler;

//结束头部刷新动画
//- (void)endHeaderRefreshingForView:(UIScrollView *)scrollView;
//结束尾部刷新动画
//- (void)endFooterRefreshingForView:(UIScrollView *)scrollView;
//结束头部和尾部刷新动画
- (void)endRefreshingForView:(UIScrollView *)scrollView;
//没有更多数据时调用
- (void)showNoMoreMessageForview:(UIScrollView *)scrollView;

//获取服务器返回的状态码
- (NSInteger)statFromResponse:(id)response;

//没登陆弹出登录提示页面并返回NO,登录直接返回YES
- (BOOL)showLoginAlertIfNotLogin;
//弹出登录提示界面
- (void)showLoginAlert;
//弹出Instagram登录界面
- (void)presentLoginViewController;


@end
