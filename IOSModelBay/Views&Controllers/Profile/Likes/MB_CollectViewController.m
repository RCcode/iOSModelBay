//
//  MB_ FavoritesViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_CollectViewController.h"
#import "MB_LikeCollectViewCell.h"
#import "MB_UserViewController.h"
#import "MB_Collect.h"

@interface MB_CollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_CollectViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    [self.view addSubview:self.collectView];
    
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestLikesListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_LikeCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.collect = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MB_Collect *collect = self.dataArray[indexPath.row];
    
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeUser;
    userVC.hidesBottomBarWhenPushed = YES;
    
    MB_User *user = [[MB_User alloc] init];
    user.fid = collect.fid;
    user.fname = collect.fname;
    user.fpic = collect.fpic;
    user.fbackPic = collect.fbackPic;
    user.fcareerId = collect.fcareerId;
    user.state = collect.state;
    user.uType = collect.utype;
    user.uid = collect.fuid;
    user.liked = LikedTypeNone;
    userVC.user = user;
    [self.navigationController pushViewController:userVC animated:YES];
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
                [taleView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == topViewHeight - 64 && scrollView.contentOffset.y < 0) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_CollectViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestLikesListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"foot");
        [weakSelf requestLikesListWithMinId:weakSelf.minId];
    }];
}

//获取收藏列表
- (void)requestLikesListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.user.fid),
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getLikesWithParameters:params success:^(id response) {
        NSLog(@"likes: %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.collectView];
        if ([self statFromResponse:response] == 10000) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
            self.minId = [response[@"minId"] integerValue];
            if (response[@"list"] != nil && ![response[@"list"] isKindOfClass:[NSNull class]]) {
                NSArray *array = response[@"list"];
                for (NSDictionary *dic in array) {
                    MB_Collect *collect = [[MB_Collect alloc] init];
                    [collect setValuesForKeysWithDictionary:dic];
                    [self. dataArray addObject:collect];
                }
                [self.collectView reloadData];
                if (self.dataArray.count <= 0) {
                    self.collectView.backgroundView = self.noResultView;
                }else {
                    self.collectView.backgroundView = nil;
                }
            }
        }else if ([self statFromResponse:response] == 10004) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
                [self.collectView reloadData];
                self.collectView.backgroundView = self.noResultView;
            }else {
                [self showNoMoreMessageForview:self.collectView];
            }
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.collectView];
    }];
}


#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat space = 7.0 / 2.0;
        CGFloat itemWidth = (kWindowWidth - space * 4) / 3;
        CGFloat itemHeight = itemWidth + 27;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) collectionViewLayout:layout];
        _collectView.backgroundColor = colorWithHexString(@"#eeeeee");
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        _collectView.bounces         = YES;
        _collectView.alwaysBounceVertical = YES;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_LikeCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
