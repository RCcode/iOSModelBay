//
//  MB_TabBarViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_TabBarViewController.h"
#import "MB_BaseNavigationViewController.h"
#import "MB_FindViewController.h"
#import "MB_RankingViewController.h"
#import "MB_NoticeViewController.h"
#import "MB_UserViewController.h"

@interface MB_TabBarViewController ()

@property (nonatomic, strong) UIView *customTabBar;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation MB_TabBarViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBar addSubview:self.customTabBar];
    
    //使tabbar透明
    [self.tabBar setBackgroundImage:[UIImage new]];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MB_FindViewController *findVC = [[MB_FindViewController alloc] init];
    MB_BaseNavigationViewController *findNC = [[MB_BaseNavigationViewController alloc] initWithRootViewController:findVC];
    
    MB_RankingViewController *rankingVC = [[MB_RankingViewController alloc] init];
    MB_BaseNavigationViewController *rankingNC = [[MB_BaseNavigationViewController alloc] initWithRootViewController:rankingVC];
    
    MB_NoticeViewController *messageVC = [[MB_NoticeViewController alloc] init];
    MB_BaseNavigationViewController *messageNC = [[MB_BaseNavigationViewController alloc] initWithRootViewController:messageVC];
    
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    MB_User *user = [[MB_User alloc] init];
    user.fid = [[userDefaults objectForKey:kID] integerValue];
    user.fname = [userDefaults objectForKey:kName];
    user.fcareerId = [userDefaults objectForKey:kCareer];
    user.fbackPic = [userDefaults objectForKey:kBackPic];
    user.fpic = [userDefaults objectForKey:kPic];
    user.uid = [[userDefaults objectForKey:kUid] integerValue];
    user.uType = [[userDefaults objectForKey:kUtype] integerValue];
    user.state = 1;
    userVC.user = user;
    userVC.comeFromType = ComeFromTypeSelf;
    MB_BaseNavigationViewController *userNC = [[MB_BaseNavigationViewController alloc] initWithRootViewController:userVC];
    
    self.viewControllers = @[findNC, rankingNC, messageNC, userNC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tabBarButtonOnClick:(UIButton *)button {
//    if (button == self.selectedButton) {
//        UINavigationController *na = self.viewControllers[button.tag];
//        [na popToRootViewControllerAnimated:YES];
//        return;
//    }
    self.selectedButton.selected = NO;
    
    button.selected = YES;
    self.selectedButton = button;
    self.selectedIndex = button.tag;
    
    //修改指示条的位置
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.indicateView.frame;
        rect.origin.x = button.tag * rect.size.width;
        self.indicateView.frame = rect;
    }];
}

- (UIView *)customTabBar {
    if (_customTabBar == nil) {
        _customTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 49)];
        _customTabBar.backgroundColor = [colorWithHexString(@"#222222") colorWithAlphaComponent:0.95];
        
        NSArray *images = @[@"ic_discover",@"ic_ranking",@"ic_notice",@"ic_personal"];
        NSArray *images_h = @[@"ic_discover_h",@"ic_ranking_h",@"ic_notice_h",@"ic_personal_h"];
        CGFloat btnWidth = kWindowWidth / 4;
        CGFloat btnHeight = 49 - 3;
        for (int i = 0; i < 4; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setFrame:CGRectMake(btnWidth * i, 0, btnWidth, btnHeight)];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images_h[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(tabBarButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_customTabBar addSubview:button];
            
            if (i == 0) {
                button.selected = YES;
                self.selectedButton = button;
                //添加指示条
                [_customTabBar addSubview:self.indicateView];
            }
        }
    }
    return _customTabBar;
}

- (UIView *)indicateView {
    if (_indicateView == nil) {
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 49 - 3, kWindowWidth / 4, 3)];
        _indicateView.backgroundColor = colorWithHexString(@"#ff4f42");
    }
    return _indicateView;
}

@end
