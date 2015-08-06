//
//  MB_MainViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MainViewController.h"
#import "MB_TabBarViewController.h"
#import "MB_LoginViewController.h"
#import "MB_SelectRoleViewController.h"
#import "MB_User.h"

@interface MB_MainViewController ()

@property (nonatomic, strong) UIScrollView * backScrollView;//背景滚动视图
@property (nonatomic, strong) UIImageView  * titleImageView;
@property (nonatomic, strong) UIButton     * loginBtn;
@property (nonatomic, strong) UIButton     * skipBtn;

@end

@implementation MB_MainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.skipBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private methods
- (void)loginBtnOnClick:(UIButton *)btn{
    [MobClick event:@"Startup" label:@"startup_signup"];
    
    [self presentLoginViewController];
}

- (void)skipBtnOnClick:(UIButton *)btn{
    [MobClick event:@"Startup" label:@"startup_skip"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getters & setters
- (UIScrollView *)backScrollView{
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _backScrollView.pagingEnabled                  = YES;
        _backScrollView.bounces                        = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.contentSize                    = CGSizeMake(kWindowWidth * 4, 0);
        
        for (int i = 0; i < 5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowWidth, 0, kWindowWidth, CGRectGetHeight(_backScrollView.frame))];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d.jpg",i + 1]];
            [_backScrollView addSubview:imageView];
            
        }
    }
    return _backScrollView;
}

- (UIImageView *)titleImageView {
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWindowWidth - 235) / 2, kWindowHeight * 64 / 568, 235, 133)];
        _titleImageView.image = [UIImage imageNamed:@"title"];
    }
    return _titleImageView;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [[MB_CustomButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.skipBtn.frame) - kWindowHeight * 44 / 568, kWindowWidth, kWindowHeight * 44 / 568)];
        _loginBtn.backgroundColor = colorWithHexString(@"#2e5e86");
        _loginBtn.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Medium" size:15];
        [_loginBtn setTitle:LocalizedString(@"login_insta", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)skipBtn{
    if (_skipBtn == nil) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kWindowHeight - kWindowHeight * 52 / 568, kWindowWidth, kWindowHeight * 52 / 568)];
        _skipBtn.backgroundColor = [UIColor clearColor];
        _skipBtn.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Medium" size:15];
        [_skipBtn setTitle:[NSString stringWithFormat:@"%@ >>",LocalizedString(@"Skip", nil)] forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

@end
