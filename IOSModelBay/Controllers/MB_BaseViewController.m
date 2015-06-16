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
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UIScrollViewDelegate
static CGFloat startOffsetY;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startOffsetY = scrollView.contentOffset.y;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    NSLog(@"%f  %f  %f %f ",scrollView.contentSize.height,scrollView.contentOffset.y, startOffsetY,kWindowHeight);
//    if (![self.parentViewController isKindOfClass:[UINavigationController class]]) {
//        return;//防止ChildViewController滑动隐藏导航栏
//    }
//    
//    //这个判断为了消除刷新的影响
////    if (scrollView.contentOffset.y >-64 && scrollView.contentOffset.y < scrollView.contentSize.height - kWindowHeight) {
////    if (scrollView.contentOffset.y >-64 && scrollView.contentOffset.y < scrollView.contentSize.height - (kWindowHeight - 64 - 49)- 30) {
//    if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y < scrollView.contentSize.height - (kWindowHeight - 64 - 49)) {
//        if (scrollView.contentOffset.y < startOffsetY - 40) {
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//            startOffsetY = scrollView.contentOffset.y;
//        }
//        if (scrollView.contentOffset.y > startOffsetY + 40) {
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//            startOffsetY = scrollView.contentOffset.y;
//        }
//    }
//}


#pragma mark - Private Methods
- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addPullToRefreshWithActionHandler:actionHandler];
    scrollview.pullToRefreshView.originalTopInset = [self.parentViewController isKindOfClass:[UINavigationController class]]?64:0;
    if (self.automaticallyAdjustsScrollViewInsets == NO) {
        scrollview.pullToRefreshView.originalTopInset = 0;
    }
//    scrollview.pullToRefreshView.originalTopInset = self.automaticallyAdjustsScrollViewInsets?64:0;
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
    if (stat == 10004) {
        errorMsg = @"无记录";
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

@end
