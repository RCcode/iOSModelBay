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

@end

@implementation MB_TabBarViewController

-(void)viewDidAppear:(BOOL)animated {
    self.tabBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MB_FindViewController *findVC       = [[MB_FindViewController alloc] init];
    findVC.tabBarItem.image             = [UIImage imageNamed:@"a"];
    MB_BaseNavigationViewController *findNC       = [[MB_BaseNavigationViewController alloc] initWithRootViewController:findVC];
    
    MB_RankingViewController *rankingVC = [[MB_RankingViewController alloc] init];
    rankingVC.tabBarItem.image          = [UIImage imageNamed:@"a"];
    MB_BaseNavigationViewController *rankingNC    = [[MB_BaseNavigationViewController alloc] initWithRootViewController:rankingVC];
    
    MB_NoticeViewController *messageVC  = [[MB_NoticeViewController alloc] init];
    messageVC.tabBarItem.image          = [UIImage imageNamed:@"a"];
    MB_BaseNavigationViewController *messageNC    = [[MB_BaseNavigationViewController alloc] initWithRootViewController:messageVC];
    
    MB_UserViewController *userVC       = [[MB_UserViewController alloc] init];
    userVC.tabBarItem.image             = [UIImage imageNamed:@"a"];
    MB_BaseNavigationViewController *userNC       = [[MB_BaseNavigationViewController alloc] initWithRootViewController:userVC];
    
    self.viewControllers          = @[findNC, rankingNC, messageNC, userNC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
