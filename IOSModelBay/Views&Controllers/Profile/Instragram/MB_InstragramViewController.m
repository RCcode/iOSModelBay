//
//  MB_InstragramViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_InstragramViewController.h"
#import "MB_UserViewController.h"
#import "MB_InstragramModel.h"
#import "MB_CareerCollectViewCell.h"

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
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_CareerCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_InstragramModel *model = self.dataArray[indexPath.row];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:model.images[@"standard_resolution"][@"url"]] placeholderImage:nil];
    cell.careerLabel.hidden = YES;
    cell.selectButton.hidden = YES;
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
                [taleView setContentOffset:CGPointMake(0, topViewHeight - 20) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == topViewHeight - 20) {
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
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/",self.uid];
    NSMutableDictionary *params = [@{@"access_token":[userDefaults objectForKey:kAccessToken],
                                     @"count": @(24)} mutableCopy];
    if (maxId) {
        [params setValue:maxId forKey:@"max_id"];
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
            MB_InstragramModel *model = [[MB_InstragramModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
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
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat space = 1;
        CGFloat itemWidth = (kWindowWidth - space * 2) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) collectionViewLayout:layout];
        _collectView.backgroundColor = colorWithHexString(@"#ffffff");
        _collectView.alwaysBounceVertical = YES;
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_CareerCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
