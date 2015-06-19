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
#import "MB_UserViewController.h"
#import "JDFPeekabooCoordinator.h"
#import "MB_User.h"

@interface MB_FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, assign) NSInteger minId;//分页用的

@end

@implementation MB_FindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.title = @"MODELBAY";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(rightBarBtnOnCLick:)];
    
    [self.view addSubview:self.collectView];
    [self addPullRefresh];
    [self HideNavigationBarWhenScrollUpForScrollView:self.collectView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self findUserListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_User *user = self.dataArray[indexPath.row];
    cell.user = user;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.hidesBottomBarWhenPushed = YES;
    userVC.user = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - private methods
- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //跳转到筛选界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //跳转到筛选界面
    MB_FilterViewController *filterVC = [[MB_FilterViewController alloc] init];
    filterVC.CompleteHandler = ^(){
        [self findUserListWithMinId:0];
    };
    [self.navigationController pushViewController:filterVC animated:YES];
}

//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_FindViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf findUserListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.collectView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf findUserListWithMinId:weakSelf.minId];
    }];
}

//获取发现用户列表
- (void)findUserListWithMinId:(NSInteger)minId {
    NSMutableDictionary *params = [@{@"fgender":@([MB_Utils shareUtil].gender),
                                     @"fcareerId":[MB_Utils shareUtil].careerId?:@"",
                                     @"minId":@(minId),
                                     @"count":@(10)} mutableCopy];
//    if ([userDefaults boolForKey:kIsLogin]) {
//        [params setObject:[userDefaults objectForKey:kID] forKey:@"id"];
//        [params setObject:[userDefaults objectForKey:kID] forKey:@"token"];
//    }
    
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"list %@",response);
        [self endRefreshingForView:self.collectView];
        if ([self statFromResponse:response] == 10000) {
            NSArray *userList = response[@"list"];
            if (userList == nil || [userList isKindOfClass:[NSNull class]] || userList.count <= 0) {
                [self showNoMoreMessageForview:self.collectView];
                return;
            }
            
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
            
            self.minId = [response[@"minId"] integerValue];
            for (NSDictionary *dic in response[@"list"]) {
                MB_User *user = [[MB_User alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:user];
            }
            [self.collectView reloadData];
        }
    } failure:^(NSError *err) {
        [self endRefreshingForView:self.collectView];
    }];
}


#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kWindowWidth - 2.5) / 2;
        layout.minimumInteritemSpacing = 2.5;
        layout.minimumLineSpacing = 2.5;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49) collectionViewLayout:layout];
        _collectView.bounces = YES;
        _collectView.alwaysBounceVertical = YES;
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        _collectView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_collectView registerNib:[UINib nibWithNibName:@"MB_UserCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end