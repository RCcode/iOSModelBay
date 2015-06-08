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

@interface MB_UserViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *currentView;

@end

@implementation MB_UserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.containerView];
    [self addChildViewControllers];
    
    [self segmentControlOnClick:self.segmentControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)test {
    MB_InviteViewController*inviteVC = [[MB_InviteViewController alloc] init];
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
    messageVC.containerViewRect    = self.containerView.frame;
    likesVC.containerViewRect      = self.containerView.frame;
    
    [self addChildViewController:summaryVC];
    [self addChildViewController:ablumVC];
    [self addChildViewController:instragramVC];
    [self addChildViewController:messageVC];
    [self addChildViewController:likesVC];
}

- (void)segmentControlOnClick:(UISegmentedControl *)segmentControl {
    UIViewController *vc = self.childViewControllers[segmentControl.selectedSegmentIndex];
    [_currentView removeFromSuperview];
    [self.containerView addSubview:vc.view];
    _currentView = vc.view;
}

#pragma mark - getters & setters
- (UISegmentedControl *)segmentControl {
    if (_segmentControl == nil) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"a", @"b", @"c", @"d", @"e"]];
        _segmentControl.frame = CGRectMake(0, 300, windowWidth(), 50);
        self.segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentControlOnClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), windowWidth(), kViewHeight - CGRectGetMaxY(self.segmentControl.frame) + 64)];
        _containerView.backgroundColor = [UIColor blueColor];
    }
    return _containerView;
}

@end
