//
//  MB_SelectTemplateViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectTemplateViewController.h"
#import "MB_IndicatorView.h"
#import "MB_EditViewController.h"

@interface MB_SelectTemplateViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MB_IndicatorView *indicatorView;

@end

@implementation MB_SelectTemplateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.indicatorView];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private methods
- (void)selectButtonOnClick:(UIButton *)button {
    MB_EditViewController *editVC = [[MB_EditViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.indicatorView setCurrentPage:currentPage];
}


#pragma mark - getters & setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64 - 49)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        for (int i = 0; i < 10; i ++) {
            //背景图
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth *i, 0, kWindowWidth, CGRectGetHeight(_scrollView.frame))];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"a"];
            [_scrollView addSubview:imageView];
            //模板图
            UIImageView *subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(39.0 / 2, 36, kWindowWidth - 39, CGRectGetHeight(imageView.frame) - 36 - 32 - 3)];
            subImageView.userInteractionEnabled = YES;
            subImageView.image = [UIImage imageNamed:@"b"];
            [imageView addSubview:subImageView];
        }
        _scrollView.contentSize = CGSizeMake(kWindowWidth * 10, 0);
    }
    return _scrollView;
}

//红色滚动指示器
- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[MB_IndicatorView alloc] initWithFrame:CGRectMake(39.0 / 2, CGRectGetMaxY(self.scrollView.frame) - 16 - 3, kWindowWidth - 39, 3) pageCount:10];
        _indicatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _indicatorView;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 49);
        _button.backgroundColor = colorWithHexString(@"#ff4f42");
        [_button setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:16];
        [_button setTitle:@"USE THIS TEMPLATE" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(selectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
