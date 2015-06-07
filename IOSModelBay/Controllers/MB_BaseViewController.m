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

@end

@implementation MB_BaseViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - private methods

- (void)addHeaderRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addPullToRefreshWithActionHandler:actionHandler];
    [scrollview.pullToRefreshView setArrowColor:self.view.backgroundColor];
    [scrollview.pullToRefreshView setTitle:@"" forState:SVPullToRefreshStateAll];
    [scrollview.pullToRefreshView setCustomView:self.activityIndicatorView
                                       forState:SVPullToRefreshStateTriggered];
}

- (void)addFooterRefreshForView:(UIScrollView *)scrollview
              WithActionHandler:(void (^)(void))actionHandler {
    
    [scrollview addInfiniteScrollingWithActionHandler:actionHandler];
    [scrollview.infiniteScrollingView setCustomView:self.footerLabel
                                           forState:SVPullToRefreshStateStopped];
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
        _footerLabel.backgroundColor = self.view.backgroundColor;
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
