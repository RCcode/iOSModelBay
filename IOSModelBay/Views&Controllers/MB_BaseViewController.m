//
//  MB_BaseViewController.m
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_BaseViewController.h"

@interface MB_BaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation MB_BaseViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scrollCoordinator disable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollCoordinator enable];
}

#pragma mark - Private Methods
- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addPullToRefreshWithActionHandler:actionHandler];
    [scrollview.pullToRefreshView setArrowColor:scrollview.backgroundColor];
    [scrollview.pullToRefreshView setTitle:@"" forState:SVPullToRefreshStateAll];
    [scrollview.pullToRefreshView setCustomView:self.activityIndicatorView
                                       forState:SVPullToRefreshStateTriggered];
}

- (void)addFooterRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addInfiniteScrollingWithActionHandler:actionHandler];
    self.footerLabel.backgroundColor = scrollview.backgroundColor;
    [scrollview.infiniteScrollingView setCustomView:self.footerLabel
                                           forState:SVPullToRefreshStateStopped];
}

//结束头部刷新动画
- (void)endHeaderRefreshingForView:(UIScrollView *)scrollView {
    [scrollView.pullToRefreshView stopAnimating];
}

//结束尾部刷新动画
- (void)endFooterRefreshingForView:(UIScrollView *)scrollView {
    self.footerLabel.text = @"";
    [scrollView.infiniteScrollingView stopAnimating];
}

//结束头部和尾部刷新动画
- (void)endRefreshingForView:(UIScrollView *)scrollView {
    self.footerLabel.text = @"";
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [scrollView.pullToRefreshView stopAnimating];
    [scrollView.infiniteScrollingView stopAnimating];
}

//没有更多数据时调用
- (void)showNoMoreMessageForview:(UIScrollView *)scrollView {
    self.footerLabel.text = @"没有更多了";
}

- (void)HideNavigationBarWhenScrollUpForScrollView:(UIScrollView *)scrollView {
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = scrollView;
    self.scrollCoordinator.topView = self.navigationController.navigationBar;
    if (self.navigationItem.titleView) {
        self.scrollCoordinator.topViewItems = @[self.navigationItem.titleView]; 
    }
    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
}

- (NSInteger)statFromResponse:(id)response {
    NSInteger stat = [response[@"stat"] integerValue];
    NSString *errorMsg = nil;
    if (stat == 10001) {
        errorMsg = @"参数异常";
    }
    if (stat == 10002) {
        errorMsg = @"服务器异常";
    }
    if (stat == 10003) {
        errorMsg = @"操作失败";
    }
//    if (stat == 10004) {
//        errorMsg = @"无记录";
//    }
    if (stat == 10501) {
        errorMsg = @"无此用户";
    }
    [MB_Utils showAlertViewWithMessage:errorMsg];
    return stat;
}


#pragma mark - getters & setters
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (UILabel *)footerLabel {
    
    if (_footerLabel == nil) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 60)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footerLabel;
}

-(UIActivityIndicatorView *)activityIndicatorView {
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
        _titleLabel.text = @"MODELBAY";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
