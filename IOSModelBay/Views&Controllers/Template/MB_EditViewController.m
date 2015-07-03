//
//  MB_EditViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_EditViewController.h"

@interface MB_EditViewController ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIView *menuView;

@end

@implementation MB_EditViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    [self.view addSubview:self.containView];
    [self.view addSubview:self.menuView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private methods
- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    
}


#pragma mark - getters & setters
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64 - CGRectGetHeight(self.menuView.frame))];
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 60, kWindowWidth, 60)];
        _menuView.backgroundColor = colorWithHexString(@"#222222");
        for (int  i = 0; i < 3; i ++) {
            CGFloat space = 55;
            CGFloat buttonWidth = (kWindowWidth - space * 4) / 3;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(space + (buttonWidth + space) * i, 0, buttonWidth, CGRectGetHeight(_menuView.frame));
            [button setImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
            [_menuView addSubview:button];
        }
    }
    return _menuView;
}

@end
