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
#import "MB_SelectPhotosViewController.h"
#import "MB_SelectTemplateViewController.h"
#import "MB_AddAblumMenuView.h"

@interface MB_CollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) MB_AddAblumMenuView *menuView;

@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_CollectViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.addView];
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

//添加作品集
- (void)addButtonOnClick:(UIButton *)button{
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    if (self.menuView.isShowing) {
        self.menuView.isShowing = NO;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.menuView.frame;
            self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
        }];
    }else {
        self.menuView.isShowing = YES;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.menuView.frame;
            self.menuView.frame = CGRectMake(0, kWindowHeight - rect.size.height, kWindowWidth, rect.size.height);
        }];
    }
}

//添加相册
- (void)albumButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectPhotosViewController *vc = [[MB_SelectPhotosViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//添加模板
- (void)templateButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectTemplateViewController *vc = [[MB_SelectTemplateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getters & setters
- (UIView *)addView {
    if (_addView == nil) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        _addView.backgroundColor = [UIColor redColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _addView.bounds;
        [button setImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addView addSubview:button];
    }
    return _addView;
}

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        NSLog(@"-----%f",self.view.frame.size.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kWindowWidth - 5) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = 2.5;
        layout.minimumInteritemSpacing = 2.5;
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addView.frame), kWindowWidth, self.containerViewRect.size.height - CGRectGetMaxY(self.addView.frame)) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_LikeCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MB_AddAblumMenuView" owner:nil options:nil] firstObject];
        _menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 150);
        _menuView.backgroundColor = [UIColor grayColor];
        _menuView.isShowing = YES;
        [_menuView.albumButton addTarget:self action:@selector(albumButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView.templateButton addTarget:self action:@selector(templateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuView;
}

@end
