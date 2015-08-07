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
#import "MB_ImageTableViewCell.h"

static NSString * const ReuseIdentifierInstagram = @"instagram";

@interface MB_InstragramViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSString *maxId;
@property (nonatomic, assign) BOOL noMore;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_InstragramViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectView];
    
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestInstragramMediasListWithMaxId:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_CareerCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_InstragramModel *model = self.dataArray[indexPath.row];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:model.images[@"standard_resolution"][@"url"]] placeholderImage:nil];
    cell.coverView.hidden = YES;
    cell.careerLabel.hidden = YES;
    cell.selectButton.hidden = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    self.tableView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.tableView];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWindowWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        MB_ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierInstagram forIndexPath:indexPath];
        cell.instaImageView.image = nil;
        [MBProgressHUD showHUDAddedTo:cell.instaImageView animated:YES];
        return cell;
    }else {
        MB_ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierInstagram forIndexPath:indexPath];
        [MBProgressHUD hideHUDForView:cell.instaImageView animated:YES];
        MB_InstragramModel *model = self.dataArray[indexPath.row];
        [cell.instaImageView sd_setImageWithURL:[NSURL URLWithString:model.images[@"standard_resolution"][@"url"]] placeholderImage:nil];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];}

#pragma mark - UIScrollViewDelegate
static CGFloat startY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.collectView) {
        startY = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectView) {
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y / kWindowWidth == self.dataArray.count) {
            [self requestInstragramMediasListWithMaxId:self.maxId];
        }else {
            [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.y / kWindowWidth inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_InstragramViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestInstragramMediasListWithMaxId:nil];
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        if (weakSelf.noMore) {
            //没有更多了
            [weakSelf endRefreshingForView:weakSelf.collectView];
            [weakSelf showNoMoreMessageForview:weakSelf.collectView];
            return;
        }
        NSLog(@"footer");
        [weakSelf requestInstragramMediasListWithMaxId:weakSelf.maxId];
    }];
}

- (void)requestInstragramMediasListWithMaxId:(NSString *)maxId {
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/",self.uid];
    NSMutableDictionary *params = [@{@"access_token":[userDefaults objectForKey:kAccessToken],
                                     @"count": @(18)} mutableCopy];
    if (maxId) {
        [params setValue:maxId forKey:@"max_id"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"instragram %@",responseObject);
        [self endRefreshingForView:self.collectView];
        
        NSArray *dataArr = responseObject[@"data"];
        if ([responseObject[@"pagination"] allKeys].count == 0) {
            //下一页没有了
            self.noMore = YES;
        }else{
            //记录请求下一页需要的maxId
            self.maxId = responseObject[@"pagination"][@"next_max_id"];
        }
        
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
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.collectView];
//        [MB_Utils showPromptWithText:LocalizedString(@"Loading_failed", nil)];
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
        _collectView.bounces = YES;
        _collectView.alwaysBounceVertical = YES;
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_CareerCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowHeight, kWindowWidth) style:UITableViewStylePlain];
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _tableView.center = [UIApplication sharedApplication].keyWindow.center;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled =YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MB_ImageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierInstagram];
    }
    return _tableView;
}

@end
