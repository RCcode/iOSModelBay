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
#import "MB_User.h"

@interface MB_FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, assign) NSInteger         minId;//分页用的

@property (nonatomic, assign) BOOL showLoginAuto;//是否自动弹出登录

@end

@implementation MB_FindViewController

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.showLoginAuto) {
        self.showLoginAuto = NO;
        [self showLoginAlert];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Discover", nil).uppercaseString;
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_screening"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnOnCLick:)];
    
    if (![userDefaults boolForKey:kIsLogin]) {
        //如果没有登录, 设置自动弹出登录页面
        self.showLoginAuto = YES;
    }
    
    [self.view addSubview:self.collectView];
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self findUserListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self showLoginAlertIfNotLogin]) {
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        userVC.comeFromType = ComeFromTypeUser;
        userVC.user = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}


#pragma mark - private methods
- (void)rightBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //跳转到筛选界面
    MB_FilterViewController *filterVC = [[MB_FilterViewController alloc] init];
    filterVC.type = FilterTypeFind;
    filterVC.hidesBottomBarWhenPushed = YES;
    filterVC.CompleteHandler = ^(){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    NSMutableDictionary *params = [@{@"fgender":@([MB_Utils shareUtil].fGender),
                                     @"fcareerId":[MB_Utils shareUtil].fCareerId,
                                     @"minId":@(minId),
                                     @"count":@(10)} mutableCopy];
    
    if ([userDefaults boolForKey:kIsLogin]) {
        [params setObject:[userDefaults objectForKey:kID] forKey:@"id"];
        [params setObject:[userDefaults objectForKey:kAccessToken] forKey:@"token"];
    }
    
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"find %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                //不出现自己
                if ([userDefaults boolForKey:kIsLogin] && user.fid == [[userDefaults objectForKey:kID] integerValue]) {
                    continue;
                }
                [self.dataArray addObject:user];
            }
            [self.collectView reloadData];
        }else if ([self statFromResponse:response] == 10501){
            //没有用户
            if (minId == 0) {
                [self.dataArray removeAllObjects];
                [self.collectView reloadData];
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
        CGFloat space = 4;
        CGFloat itemWidth  = (kWindowWidth - 3 * space) / 2;
        CGFloat itemHeight = itemWidth + 34;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) collectionViewLayout:layout];
        _collectView.bounces              = YES;
        _collectView.alwaysBounceVertical = YES;
        _collectView.backgroundColor      = colorWithHexString(@"#eeeeee");
        _collectView.delegate             = self;
        _collectView.dataSource           = self;
        _collectView.contentInset         = UIEdgeInsetsMake(64, 0, 49, 0);
        [_collectView registerNib:[UINib nibWithNibName:@"MB_UserCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
