//
//  MB_InstragramViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_InstragramViewController.h"
#import "MB_UserCollectViewCell.h"
#import "MB_UserViewController.h"

@interface MB_InstragramViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, strong) NSString *maxId;
@property (nonatomic, assign) BOOL noMore;

@end

@implementation MB_InstragramViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectView];
    [self addPullRefresh];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self requestInstragramMediasListWithMaxId:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}


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
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_InstragramViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
        [weakSelf requestInstragramMediasListWithMaxId:nil];
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        if (weakSelf.noMore) {
            //没有更多了
            [weakSelf endRefreshingForView:weakSelf.collectView];
            [weakSelf showNoMoreMessageForview:weakSelf.collectView];
            return;
        }
        
        [weakSelf requestInstragramMediasListWithMaxId:weakSelf.maxId];
    }];
}

- (void)requestInstragramMediasListWithMaxId:(NSString *)maxId {
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/",_uid];
    
    NSMutableDictionary *params = [@{@"count": @(24),
                                     } mutableCopy];
    if ([userDefaults objectForKey:kAccessToken]) {
        [params setValue:[userDefaults objectForKey:kAccessToken] forKey:@"access_token"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"instragram %@",responseObject);
        [self endRefreshingForView:self.collectView];
        
        NSArray *dataArr = responseObject[@"data"];
        if ([responseObject[@"pagination"] allKeys].count == 0) {
            //下一页没有了
            self.noMore = YES;
        }else{
            //记录请求下一页需要的maxId
            self.maxId = responseObject[@"pagination"][@"next_max_id"];
        }
        
        //下拉刷新则清空数组
        if (maxId == nil) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in dataArr) {
            //model
        }
        [self.collectView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.collectView];
    }];
}


#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        NSLog(@"-----%f",self.view.frame.size.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
