//
//  MB_SampleReelsViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AblumViewController.h"
#import "MB_UserViewController.h"

@interface MB_AblumViewController ()

@end

@implementation MB_AblumViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource



#pragma mark - UIScrollViewDelegate
static CGFloat startY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    UITableView *taleView = userVC.tableView;
    if (scrollView.dragging) {
        if (scrollView.contentOffset.y - startY > 0) {
            //向上拉
            if (taleView.contentOffset.y == -64) {
                [taleView setContentOffset:CGPointMake(0, 250) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == 250) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}


#pragma mark - private methods

#pragma mark - getters & setters


@end
