//
//  MB_BaseViewController.m
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_BaseViewController.h"

@interface MB_BaseViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation MB_BaseViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UIScrollViewDelegate
static CGFloat startOffsetY;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return;//防止ChildViewController滑动隐藏导航栏
    }
    
    //这个判断为了消除刷新的影响
    if (scrollView.contentOffset.y >-64 && scrollView.contentOffset.y < scrollView.contentSize.height - kWindowHeight) {
        if (scrollView.contentOffset.y < startOffsetY - 60) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            startOffsetY = scrollView.contentOffset.y;
        }
        if (scrollView.contentOffset.y > startOffsetY + 60) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            startOffsetY = scrollView.contentOffset.y;
        }
    }
}


#pragma mark - Private Methods
- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addPullToRefreshWithActionHandler:actionHandler];
    scrollview.pullToRefreshView.originalTopInset = [self.parentViewController isKindOfClass:[UINavigationController class]]?64:0;
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

@end
