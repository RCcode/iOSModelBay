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

@property (nonatomic, strong) UIScrollView * backScrollView;
@property (nonatomic, strong) UIImageView  * titleImageView;
@property (nonatomic, strong) UIButton     * loginBtn;
@property (nonatomic, strong) UIButton     * skipBtn;

@end

@implementation MB_MainViewController

#pragma mark - life cycle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kLoginInNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.skipBtn];
}


#pragma mark - private methods
- (void)loginBtnOnClick:(UIButton *)btn{
    [self presentLoginViewController];
}

- (void)skipBtnOnClick:(UIButton *)btn{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
        [self presentViewController:tabVC animated:YES completion:nil];
    }
}

- (void)login:(NSNotification *)noti {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getters & setters
- (UIScrollView *)backScrollView{
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _backScrollView.pagingEnabled = YES;
        _backScrollView.bounces = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.contentSize = CGSizeMake(kWindowWidth * 4, 0);
        
        for (int i = 0; i < 5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowWidth, 0, kWindowWidth, CGRectGetHeight(_backScrollView.frame))];
            NSString *imageName = [NSString stringWithFormat:@"bg%d",i + 1];
            imageView.image = [UIImage imageNamed:imageName];
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
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.skipBtn.frame) - kWindowHeight * 44 / 568, kWindowWidth, kWindowHeight * 44 / 568)];
        _loginBtn.backgroundColor = colorWithHexString(@"#2e5e86");
        _loginBtn.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Medium" size:15];
        [_loginBtn setTitle:@"LOGIN WITH INSTRAGRAM" forState:UIControlStateNormal];
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
        [_skipBtn setTitle:@"SKIP >>" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
