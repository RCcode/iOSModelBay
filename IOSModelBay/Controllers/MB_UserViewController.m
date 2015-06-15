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

#import "MB_ScanAblumViewController.h"

@interface MB_UserViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self addChildViewControllers];
    
    [self menuBtnOnClick:self.menuBtns[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWindowHeight - CGRectGetHeight(self.menuView.frame);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.menuView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menuView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    cell.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:self.containerView];
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [super scrollViewDidScroll:scrollView];
    NSLog(@"%f %f %f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.bounds.size.height);

    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height + 49) {
        NSLog(@"%f %f %f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.bounds.size.height);

        [[NSNotificationCenter defaultCenter] postNotificationName:kCanScrollNotification object:[NSNumber numberWithBool:YES]];
    }
//    if (scrollView.contentOffset.y <= - (64 + CGRectGetHeight(self.userInfoView.frame))) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCanScrollNotification object:[NSNumber numberWithBool:NO]];
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
//    MB_SearchViewController *inviteVC = [[MB_SearchViewController alloc] init];
//    [self.navigationController pushViewController:inviteVC animated:YES];
    MB_ScanAblumViewController *inviteVC = [[MB_ScanAblumViewController alloc] init];
    inviteVC.hidesBottomBarWhenPushed = YES;
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
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.userInfoView;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (MB_UserInfoView *)userInfoView {
    if (_userInfoView == nil) {
        _userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"MB_UserInfoView" owner:nil options:nil] firstObject];
        _userInfoView.frame = CGRectMake(0, 64, kWindowWidth, 250);
    }
    return _userInfoView;
}

- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        _menuView.backgroundColor = [UIColor grayColor];
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
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - CGRectGetHeight(self.menuView.frame))];
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
