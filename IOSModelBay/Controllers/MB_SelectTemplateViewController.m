//
//  MB_SelectTemplateViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectTemplateViewController.h"

@interface MB_SelectTemplateViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *button;

@end

@implementation MB_SelectTemplateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - private methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
}

- (void)handlePageControl:(UIPageControl *)pageControl {
    [self.scrollView setContentOffset:CGPointMake(pageControl.currentPage * CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}

#pragma mark - getters & setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64 - 50)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        for (int i = 0; i < 10; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth *i, 0, kWindowWidth, CGRectGetHeight(_scrollView.frame))];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"a"];
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize = CGSizeMake(kWindowWidth * 10, 0);
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 50, kWindowWidth, 50)];
        _pageControl.numberOfPages = 10;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 50);
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"select" forState:UIControlStateNormal];
//        [_button addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
