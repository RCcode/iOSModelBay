//
//  MB_ScanAblumViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/13.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_ScanAblumViewController.h"
#import "MB_LikersViewController.h"
#import "MB_CommentsViewController.h"
#import "MB_AblumDescView.h"

#define startTag 100

@interface MB_ScanAblumViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate, AblumDescViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MB_AblumDescView *descView;

@end

@implementation MB_ScanAblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleLabel.text = [NSString stringWithFormat:@"VINCENT(%d/%d)",1,10];
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - AblumDescViewDelegate
- (void)likesButtonOnCliclk:(UIButton *)button {
    MB_LikersViewController *likersVC = [[MB_LikersViewController alloc] init];
    [self.navigationController pushViewController:likersVC animated:YES];
}

- (void)commentsButtonOnCliclk:(UIButton *)button {
    MB_CommentsViewController *commentsVC = [[MB_CommentsViewController alloc] init];
    [self.navigationController pushViewController:commentsVC animated:YES];
}

- (void)shareButtonOnCliclk:(UIButton *)button {
    
}

- (void)moreButtonOnClick:(UIButton *)button {
    NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    UIScrollView *scroll = (UIScrollView *)[self.scrollView viewWithTag:page + startTag];
    if (scroll.contentOffset.y == 0) {
        [scroll setContentOffset:CGPointMake(0, scroll.contentSize.height - scroll.frame.size.height) animated:YES];
    }else {
        [scroll setContentOffset:CGPointZero animated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:pan.view];
        NSLog(@"sss %@",NSStringFromCGPoint([pan translationInView:pan.view]));
        if (fabs(point.x) > fabs(point.y)) {
            NSLog(@"xxx");
            return YES;
        }else {
            NSLog(@"yyy");
            return NO;
        }
    }else {
        return NO;
    }
}


#pragma mark - private methods
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [pan translationInView:pan.view];
        
        UIScrollView *view = (UIScrollView *)pan.view;
        NSInteger page = view.contentOffset.x / view.frame.size.width;
        if (point.x < 0) {
            if (page + 1 < 10) {
                //横向滚动视图滚动到下一页
                [view setContentOffset:CGPointMake((page + 1) * view.frame.size.width, 0) animated:NO];
                //影集描述跟着移动到下一页
                [self.descView removeFromSuperview];
                UIScrollView *nextScroll = (UIScrollView *)[view viewWithTag:page + 1 + startTag];
                [nextScroll addSubview:self.descView];
                //修改标题
                self.titleLabel.text = [NSString stringWithFormat:@"VINCENT(%ld/%d)",page + 1 + 1,10];
                //当前页回到顶端
                UIScrollView *scroll = (UIScrollView *)[view viewWithTag:page + startTag];
                [scroll setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }else {
            if (page - 1 >= 0) {
                //横向滚动视图滚动到上一页
                [view setContentOffset:CGPointMake((page - 1) * view.frame.size.width, 0) animated:NO];
                //影集描述跟着移动到上一页
                [self.descView removeFromSuperview];
                UIScrollView *lastScroll = (UIScrollView *)[view viewWithTag:page - 1 + startTag];
                [lastScroll addSubview:self.descView];
                //修改标题
                self.titleLabel.text = [NSString stringWithFormat:@"VINCENT(%ld/%d)",page - 1 + 1,10];
                //当前页回到顶端
                UIScrollView *scroll = (UIScrollView *)[view viewWithTag:page + startTag];
                [scroll setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
    }
}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters & setters
//横向滚动视图
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64)];
        _scrollView.backgroundColor = [UIColor redColor];
//        _scrollView.pagingEnabled = YES;
//        _scrollView.delegate = self;
//        _scrollView.directionalLockEnabled = YES;
        _scrollView.scrollEnabled = NO;
        
        //创建子滚动视图
        for (int i = 0; i < 10; i ++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * kWindowWidth, 0, kWindowWidth, CGRectGetHeight(_scrollView.frame))];
            scrollView.backgroundColor = [UIColor greenColor];
            scrollView.directionalLockEnabled = YES;
            scrollView.tag = startTag + i;
            [_scrollView addSubview:scrollView];
            
            //第i页的图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(scrollView.frame) - 80)];
            imageView.userInteractionEnabled = YES;
            if (i %2 == 0) {
                imageView.image = [UIImage imageNamed:@"a"];
            }else {
                imageView.image = [UIImage imageNamed:@"b"];
            }
            [scrollView addSubview:imageView];
            
            //开始影集描述先加在第一页
            if (i == 0) {
                CGRect rect = self.descView.frame;
                rect.origin.y = CGRectGetMaxY(imageView.frame);
                self.descView.frame = rect;
                [scrollView addSubview:self.descView];
            }
            scrollView.contentSize = CGSizeMake(kWindowWidth, CGRectGetMaxY(imageView.frame) + CGRectGetHeight(self.descView.frame));
        }
        
        _scrollView.contentSize = CGSizeMake(10 * kWindowWidth, CGRectGetHeight(_scrollView.frame));
        //pan手势 用于横向的滚动视图换页
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan.delegate = self;
        [_scrollView addGestureRecognizer:pan];
    }
    return _scrollView;
}

//影集描述信息
- (UIView *)descView {
    if (_descView == nil) {
        _descView = [[MB_AblumDescView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 300)];
        _descView.delegate = self;
    }
    return _descView;
}

@end
