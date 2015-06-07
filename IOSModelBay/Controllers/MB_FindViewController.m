//
//  MB_FindViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_FindViewController.h"
#import "MB_UserCollectViewCell.h"
#import "MB_FilterViewController.h"

static NSString * const ReuseIdentifier = @"item";

@interface MB_FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation MB_FindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterBarBtnOnCLick:)];
    
    [self.view addSubview:self.collectView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    [self findUserList];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.usernameLabel.text = @"songge";
    return cell;
}

#pragma mark - private methods

- (void)filterBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //筛选
    MB_FilterViewController *filterVC = [[MB_FilterViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)addHeaderRefresh {
    __weak MB_FindViewController *weakSelf = self;
    [self.collectView addPullToRefreshWithActionHandler:^{
        NSLog(@"header");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"Header action");
            [weakSelf.collectView.pullToRefreshView stopAnimating];
        });
    }];
    self.collectView.pullToRefreshView.arrowColor = [UIColor clearColor];
    self.collectView.pullToRefreshView.textColor = [UIColor clearColor];
    //    _tableView.pullToRefreshView.titleLabel.textColor = [UIColor redColor];
    //    _tableView.pullToRefreshView.subtitleLabel.textColor = [UIColor clearColor];
    //    [_tableView.pullToRefreshView setTitle:@"" forState:SVPullToRefreshStateLoading];
    //    [_tableView.pullToRefreshView setSubtitle:@"" forState:SVPullToRefreshStateLoading];
}

- (void)addFooterRefresh {
    __weak MB_FindViewController *weakSelf = self;
    
    [self.collectView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"footer");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"foot action");
            [weakSelf.collectView.infiniteScrollingView stopAnimating];
            weakSelf.footerLabel.text = @"没有更多了";
        });
    }];
    [self.collectView.infiniteScrollingView setCustomView:_footerLabel
                                                 forState:SVPullToRefreshStateStopped];
}

- (void)findUserList {
    NSDictionary *params = @{@"minId":@(0),
                             @"count":@(10)};
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"list %@",response);
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark - getters & setters

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64 - 49)
                                          collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_UserCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    
    return _collectView;
}

- (UILabel *)footerLabel {
    if (_footerLabel == nil) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 60)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return _footerLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
