//
//  MB_BaseViewController.h
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDFPeekabooCoordinator.h"

static NSString * const ReuseIdentifier = @"cell";

@interface MB_BaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (nonatomic, strong) UILabel *titleLabel;

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

//加入上滑隐藏导航栏
//- (void)HideNavigationBarWhenScrollUpForScrollView:(UIScrollView *)scrollView;

//获取服务器返回的状态码
- (NSInteger)statFromResponse:(id)response;

//没登陆弹出登陆框并返回NO,登录直接返回YES；
- (BOOL)showLoginAlertIfNotLogin;
//弹出登录提示框
- (void)showLoginAlert;
//登录提示框点击按钮代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

//弹出登录界面
- (void)presentLoginViewController;


@end
