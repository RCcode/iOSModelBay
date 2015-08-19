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

@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) MB_AblumDescView *descView;//影集信息

@property (nonatomic, strong) NSMutableArray *descViewArray;

@end

@implementation MB_ScanAblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",1,(unsigned long)self.ablum.mList.count];
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
     
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - AblumDescViewDelegate
- (void)likeButtonOnClick:(UIButton *)button {
    //赞相册
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.ablum.uid),
                             @"ablId":@(self.ablum.ablId)};
    [[AFHttpTool shareTool] likeAblumWithParameters:params success:^(id response) {
        NSLog(@"like send %@", response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self statFromResponse:response] == 10000) {
            self.ablum.likes += 1;
            for (MB_AblumDescView *descView in self.descViewArray) {
                descView.likeCountLabel.text = [NSString stringWithFormat:@"%ld",self.ablum.likes];
            }
        }else {
            
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)likeCountLabelClick:(UITapGestureRecognizer *)tap {
    MB_LikersViewController *likersVC = [[MB_LikersViewController alloc] init];
    likersVC.ablum = self.ablum;
    [self.navigationController pushViewController:likersVC animated:YES];
}

- (void)commentButtonOnClick:(UIButton *)button {
    MB_CommentsViewController *commentsVC = [[MB_CommentsViewController alloc] init];
    commentsVC.ablum = self.ablum;
    [self.navigationController pushViewController:commentsVC animated:YES];
}

- (void)shareButtonOnClick:(UIButton *)button {
    
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //修改标题
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)(page + 1), (unsigned long)self.ablum.mList.count];
}


//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint point = [pan translationInView:pan.view];
//        if (fabs(point.x) > fabs(point.y)) {
//            return YES;
//        }else {
//            return NO;
//        }
//    }else {
//        return NO;
//    }
//}


#pragma mark - private methods
//- (void)handlePan:(UIPanGestureRecognizer *)pan
//{
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        CGPoint point = [pan translationInView:pan.view];
//        
//        UIScrollView *view = (UIScrollView *)pan.view;
//        NSInteger page = view.contentOffset.x / view.frame.size.width;
//        if (point.x < 0) {
//            if (page + 1 < self.ablum.mList.count) {
//                //横向滚动视图滚动到下一页
//                [view setContentOffset:CGPointMake((page + 1) * view.frame.size.width, 0) animated:NO];
//                //影集描述跟着移动到下一页
//                [self.descView removeFromSuperview];
//                UIScrollView *nextScroll = (UIScrollView *)[view viewWithTag:page + 1 + startTag];
//                [nextScroll addSubview:self.descView];
//                //修改标题
//                self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)(page + 1 + 1), (unsigned long)self.ablum.mList.count];
//                //当前页回到顶端
//                UIScrollView *scroll = (UIScrollView *)[view viewWithTag:page + startTag];
//                [scroll setContentOffset:CGPointMake(0, 0) animated:NO];
//            }
//        }else {
//            if (page - 1 >= 0) {
//                //横向滚动视图滚动到上一页
//                [view setContentOffset:CGPointMake((page - 1) * view.frame.size.width, 0) animated:NO];
//                //影集描述跟着移动到上一页
//                [self.descView removeFromSuperview];
//                UIScrollView *lastScroll = (UIScrollView *)[view viewWithTag:page - 1 + startTag];
//                [lastScroll addSubview:self.descView];
//                //修改标题
//                self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)(page - 1 + 1),(unsigned long)self.ablum.mList.count];
//                //当前页回到顶端
//                UIScrollView *scroll = (UIScrollView *)[view viewWithTag:page + startTag];
//                [scroll setContentOffset:CGPointMake(0, 0) animated:NO];
//            }
//        }
//    }
//}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters & setters
//横向滚动视图
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        //创建子滚动视图
        for (int i = 0; i < self.ablum.mList.count; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * kWindowWidth, 0, kWindowWidth, CGRectGetHeight(_scrollView.frame))];
            scrollView.directionalLockEnabled = YES;
            scrollView.tag = startTag + i;
            [_scrollView addSubview:scrollView];
            
            //第i页的图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(scrollView.frame) - 80)];
            imageView.backgroundColor        = placeholderColor;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode            = UIViewContentModeScaleAspectFit;
            NSString *imageName = [self.ablum.mList[i] objectForKey:@"url"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
            [scrollView addSubview:imageView];
            
            MB_AblumDescView *descView = [[MB_AblumDescView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), kWindowWidth, 300) ablum:self.ablum];
            descView.delegate = self;
            
            [scrollView addSubview:descView];
            [self.descViewArray addObject:descView];

            scrollView.contentSize = CGSizeMake(kWindowWidth, CGRectGetMaxY(imageView.frame) + CGRectGetHeight(descView.frame));
        }
        
        _scrollView.contentSize = CGSizeMake(self.ablum.mList.count * kWindowWidth, CGRectGetHeight(_scrollView.frame));
    }
    return _scrollView;
}

- (NSMutableArray *)descViewArray {
    if (!_descViewArray) {
        _descViewArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _descViewArray;
}

@end
