//
//  MB_UserViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserViewController.h"
#import "MB_UserSummaryViewController.h"
#import "MB_AblumViewController.h"
#import "MB_InstragramViewController.h"
#import "MB_MessageViewController.h"
#import "MB_LikesViewController.h"
#import "MB_SettingViewController.h"
#import "MB_InviteViewController.h"
#import "MB_SearchViewController.h"
#import "MB_UserInfoView.h"

@interface MB_UserViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MB_UserInfoView *userInfoView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) NSMutableArray *menuBtns;

@end

@implementation MB_UserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    [self.view addSubview:self.userInfoView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.containerView];
    [self addChildViewControllers];
    
    [self menuBtnOnClick:self.menuBtns[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"sss");
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    for (UIButton *btn in self.menuBtns) {
        btn.selected = NO;
    }
    
    ((UIButton *)self.menuBtns[page]).selected = YES;
}

#pragma mark - private methods
- (void)test {
//    MB_InviteViewController*inviteVC = [[MB_InviteViewController alloc] init];
//    [self.navigationController pushViewController:inviteVC animated:YES];
    MB_SearchViewController *inviteVC = [[MB_SearchViewController alloc] init];
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)addChildViewControllers {
    MB_UserSummaryViewController *summaryVC   = [[MB_UserSummaryViewController alloc] init];
    MB_AblumViewController *ablumVC           = [[MB_AblumViewController alloc] init];
    MB_InstragramViewController *instragramVC = [[MB_InstragramViewController alloc] init];
    MB_MessageViewController *messageVC       = [[MB_MessageViewController alloc] init];
    MB_LikesViewController *likesVC           = [[MB_LikesViewController alloc] init];
    
    summaryVC.containerViewRect    = self.containerView.frame;
    ablumVC.containerViewRect      = self.containerView.frame;
    instragramVC.containerViewRect = self.containerView.frame;
    instragramVC.uid = @"122345";
    messageVC.containerViewRect    = self.containerView.frame;
    likesVC.containerViewRect      = self.containerView.frame;
    
    [self addChildViewController:summaryVC];
    [self addChildViewController:ablumVC];
    [self addChildViewController:instragramVC];
    [self addChildViewController:messageVC];
    [self addChildViewController:likesVC];
    
    for (int i = 0; i < 5; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(kWindowWidth * i, 0, kWindowWidth, CGRectGetHeight(self.containerView.frame));
        [self.containerView addSubview:vc.view];
    }
    self.containerView.contentSize = CGSizeMake(kWindowWidth * 5, CGRectGetHeight(self.containerView.frame));
}

- (void)menuBtnOnClick:(UIButton *)btn {
    
    for (UIButton *btn in self.menuBtns) {
        btn.selected = NO;
    }
    btn.selected = YES;
    
    self.containerView.contentOffset = CGPointMake(CGRectGetWidth(self.containerView.frame) * btn.tag, 0);
}

#pragma mark - getters & setters

- (MB_UserInfoView *)userInfoView {
    if (_userInfoView == nil) {
        _userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"MB_UserInfoView" owner:nil options:nil] firstObject];
        _userInfoView.frame = CGRectMake(0, 64, kWindowWidth, 250);
    }
    return _userInfoView;
}

- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userInfoView.frame), kWindowWidth, 50)];
        CGFloat btnWidth = kWindowWidth / 5;
        for (int i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnWidth * i, 0, btnWidth, CGRectGetHeight(_menuView.frame));
            button.tag = i;
            [button setImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"b"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(menuBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuBtns addObject:button];
            [_menuView addSubview:button];
        }
    }
    return _menuView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame), windowWidth(), kWindowHeight - 49 - CGRectGetMaxY(self.menuView.frame))];
        _containerView.backgroundColor = [UIColor blueColor];
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
    }
    return _containerView;
}

- (NSArray *)menuBtns {
    if (_menuBtns == nil) {
        _menuBtns = [NSMutableArray arrayWithCapacity:0];
    }
    return _menuBtns;
}

@end
