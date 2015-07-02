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
    
    [self.view addSubview:self.collectView];
    
    [self addPullRefresh];
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestLikesListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                [taleView setContentOffset:CGPointMake(0, 230) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == 230) {
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
        [weakSelf requestLikesListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        [weakSelf requestLikesListWithMinId:weakSelf.minId];
    }];
}

//获取作品集列表
- (void)requestLikesListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] GetLikesWithParameters:params success:^(id response) {
        NSLog(@"likes: %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Collect *collect = [[MB_Collect alloc] init];
                [collect setValuesForKeysWithDictionary:dic];
                [self. dataArray addObject:collect];
            }
            [self.collectView reloadData];
        }
    } failure:^(NSError *err) {
        
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
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.containerViewRect.size.height) collectionViewLayout:layout];
        _collectView.backgroundColor = colorWithHexString(@"#eeeeee");
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_LikeCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
