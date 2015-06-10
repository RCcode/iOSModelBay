//
//  MB_FindViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_FindViewController.h"
#import "MB_FilterViewController.h"
#import "MB_UserCollectViewCell.h"

@interface MB_FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation MB_FindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterBarBtnOnCLick:)];
    
    [self.view addSubview:self.collectView];
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self findUserList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.usernameLabel.text = @"songge";
    return cell;
}


#pragma mark - private methods

- (void)filterBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //跳转到筛选界面
    MB_FilterViewController *filterVC = [[MB_FilterViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_FindViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"header");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefreshingForView:weakSelf.collectView];
        });
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"footer");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf endRefreshingForView:weakSelf.collectView];
            [weakSelf showNoMoreMessage];
        });
    }];
}

//获取发现用户列表
- (void)findUserList {
    NSDictionary *params = @{@"minId":@(0),
                             @"count":@(10)};
    
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"list %@",response);
        [self endRefreshingForView:self.collectView];
    } failure:^(NSError *err) {
        [self endRefreshingForView:self.collectView];
    }];
}


#pragma mark - getters & setters

- (UICollectionView *)collectView {
    
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        CGFloat space = 2.5;
        CGFloat itemWidth = (kWindowWidth - 2.5) / 2;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 2.5;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64 - 49) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_UserCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
