//
//  MB_BaseViewController.m
//  IOSModelBay
//
//  Created by lisong on 15/6/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_BaseViewController.h"
#import "MB_LoginViewController.h"
#import "MB_SelectRoleViewController.h"
#import "MB_TabBarViewController.h"
#import "MB_MainViewController.h"

@interface MB_BaseViewController ()<UIAlertViewDelegate, NotLoginViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *footerLabel;

@property (nonatomic, strong) NSString *codeStr;

@end

@implementation MB_BaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.scrollCoordinator disable];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.scrollCoordinator enable];
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
//        if (buttonIndex == 1) {
//            [self presentLoginViewController];
//        }
    }else if(alertView.tag == 2000) {
        if (buttonIndex == 1) {
            //重试
            [self loginWitnCodeStr:_codeStr];
        }
    }
}

#pragma mark - NotLoginViewDelegate
- (void)notLoginViewOnClick:(UITapGestureRecognizer *)tap {
    [self showLoginAlert];
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
//    self.footerLabel.text = @"";
    [scrollView.infiniteScrollingView stopAnimating];
}

//结束头部和尾部刷新动画
- (void)endRefreshingForView:(UIScrollView *)scrollView {
    self.footerLabel.text = @"";
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [scrollView.pullToRefreshView stopAnimating];
    [scrollView.infiniteScrollingView stopAnimating];
}

//没有更多数据时调用
- (void)showNoMoreMessageForview:(UIScrollView *)scrollView {
    self.footerLabel.text = @"没有更多了";
}

//- (void)HideNavigationBarWhenScrollUpForScrollView:(UIScrollView *)scrollView {
//    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
//    self.scrollCoordinator.scrollView = scrollView;
//    self.scrollCoordinator.topView = self.navigationController.navigationBar;
//    if (self.navigationItem.titleView) {
//        self.scrollCoordinator.topViewItems = @[self.navigationItem.titleView]; 
//    }
//    self.scrollCoordinator.topViewMinimisedHeight = 20.0f;
//}

- (NSInteger)statFromResponse:(id)response {
    NSInteger stat = [response[@"stat"] integerValue];
//    NSString *errorMsg = nil;
//    if (stat == 10001) {
//        errorMsg = @"参数异常";
//    }
//    if (stat == 10002) {
//        errorMsg = @"服务器异常";
//    }
//    if (stat == 10003) {
//        errorMsg = @"操作失败";
//    }
//    if (stat == 10004) {
//        errorMsg = @"无记录";
//    }
//    if (stat == 10501) {
//        errorMsg = @"无此用户";
//    }
//    [MB_Utils showAlertViewWithMessage:errorMsg];
    return stat;
}

- (BOOL)showLoginAlertIfNotLogin {
    if ([userDefaults boolForKey:kIsLogin]) {
        return YES;
    }else {
        [self showLoginAlert];
        return NO;
    }
}

//弹出登录提示框
- (void)showLoginAlert {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"login" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"login", nil];
//    alert.tag = 1000;
//    alert.delegate = self;
//    [alert show];
    MB_MainViewController *mainVC = [[MB_MainViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:nil];
}

- (void)presentLoginViewController {
    MB_LoginViewController *loginVC = [[MB_LoginViewController alloc] initWithSuccessBlock:^(NSString *codeStr) {
        NSLog(@"ssss%@",codeStr);
        _codeStr = codeStr;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loginWitnCodeStr:codeStr];
    }];
    
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
}

- (void)loginWitnCodeStr:(NSString *)codeStr {
    [[AFHttpTool shareTool] loginWithCodeString:codeStr success:^(id response) {
        NSLog(@"%@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self statFromResponse:response] == 10100) {
            //未注册
            MB_SelectRoleViewController *selectRoleVC = [[MB_SelectRoleViewController alloc] init];
            MB_BaseNavigationViewController *na = [[MB_BaseNavigationViewController alloc] initWithRootViewController:selectRoleVC];
            [self presentViewController:na animated:YES completion:nil];
        }else if ([self statFromResponse:response] == 10000){
            //记录用户信息
            
            [userDefaults setObject:response[@"id"] forKey:kID];//模特平台用户唯一标识
            [userDefaults setObject:response[@"gender"] forKey:kGender];//性别:0.女;1.男
            [userDefaults setObject:response[@"name"] forKey:kName];//本平台登录用户名
            [userDefaults setObject:response[@"careerId"] forKey:kCareer];//职业id,竖线分割:1|2|3
            [userDefaults setObject:response[@"utype"] forKey:kUtype];//用户类型: 0,浏览;1:专业;
            [userDefaults setObject:response[@"pic"] forKey:kPic];//用户类型: 0,浏览;1:专业;
            [userDefaults setObject:response[@"backPic"] forKey:kBackPic];//用户类型: 0,浏览;1:专业;
            
            [userDefaults setBool:YES forKey:kIsLogin];
            [userDefaults synchronize];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInNotification object:nil];
            
            
            if ([self isKindOfClass:[MB_MainViewController class]]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showLoginFailedAlertView];
    }];
}

- (void)showLoginFailedAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"login_failed", nil) delegate:self cancelButtonTitle:LocalizedString(@"Cancel", nil) otherButtonTitles:LocalizedString(@"Retry", nil), nil];
    alert.tag = 2000;
    [alert show];
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
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (MB_NotLoginView *)notLoginView {
    if (_notLoginView == nil) {
        _notLoginView = [[MB_NotLoginView alloc] initWithFrame:self.view.bounds text:LocalizedString(@"login_insta", nil) delegate:self];
    }
    return _notLoginView;
}

@end
