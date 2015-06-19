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

@interface MB_ScanAblumViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *descView;

@end

@implementation MB_ScanAblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.descView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)handleTap:(UITapGestureRecognizer *)tap {
    NSLog(@"tap");
    if (self.descView.superview) {
        [self.descView removeFromSuperview];
    }else{
        [self.view addSubview:self.descView];
    }
}

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

#pragma mark - getters & setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        
        for (int i = 0; i < 10; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowWidth, 0, kWindowWidth, kWindowHeight)];
            imageView.image = [UIImage imageNamed:@"a"];
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize = CGSizeMake(10 * kWindowWidth, CGRectGetHeight(_scrollView.frame));
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UIView *)descView {
    if (_descView == nil) {
        _descView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 100, kWindowWidth, 100)];
        _descView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
        descLabel.backgroundColor = [UIColor greenColor];
        descLabel.numberOfLines = 2;
        descLabel.text = @"djhjhjhjhjjxxxxcccccccccccccccccccc\ndsdslkdsdk";
        [descLabel sizeToFit];
        [_descView addSubview:descLabel];
        
        UILabel *descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel.frame), kWindowWidth, 15)];
        descLabel1.text = @"aaaa";
        descLabel1.backgroundColor = [UIColor yellowColor];
        [descLabel1 sizeToFit];
        [_descView addSubview:descLabel1];
        
        UILabel *descLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel1.frame), kWindowWidth, 0)];
        descLabel2.backgroundColor = [UIColor whiteColor];
        NSString *str1 = @"摄影师";
        NSString *str2 = @"lisong";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str1.length)];
        descLabel2.attributedText = str;
        [descLabel2 sizeToFit];
        [_descView addSubview:descLabel2];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(descLabel2.frame), 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(likesButtonOnCliclk:) forControlEvents:UIControlEventTouchUpInside];
        [_descView addSubview:button];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(CGRectGetMaxX(button.frame) + 50, CGRectGetMaxY(descLabel2.frame), 30, 30);
        [button2 setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(commentsButtonOnCliclk:) forControlEvents:UIControlEventTouchUpInside];
        [_descView addSubview:button2];
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(kWindowWidth - 30, CGRectGetMaxY(descLabel2.frame), 30, 30);
        [button3 setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(shareButtonOnCliclk:) forControlEvents:UIControlEventTouchUpInside];
        [_descView addSubview:button3];
        
        _descView.frame = CGRectMake(0, kWindowHeight - CGRectGetMaxY(button.frame), kWindowWidth, CGRectGetMaxY(button.frame));
    }
    return _descView;
}

@end
