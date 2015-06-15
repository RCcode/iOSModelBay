//
//  MB_ FavoritesViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LikesViewController.h"
#import "MB_LikeCollectViewCell.h"

@interface MB_LikesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation MB_LikesViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectView];
    [self addPullRefresh];
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_LikeCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = @"songge";
    return cell;
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_LikesViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        
    }];
}

#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        NSLog(@"-----%f",self.view.frame.size.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kWindowWidth - 5) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = 2.5;
        layout.minimumInteritemSpacing = 2.5;
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.containerViewRect.size.height) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_LikeCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}


@end
