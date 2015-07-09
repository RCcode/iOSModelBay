//
//  MB_RankingViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_RankingViewController.h"
#import "MB_RankingTableViewCell.h"
#import "MB_FilterViewController.h"
#import "MB_UserViewController.h"
#import "MB_User.h"
#import "MB_InstragramModel.h"

@interface MB_RankingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_RankingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"RANKING";
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_screening"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnOnCLick:)];
    
    [self.view addSubview:self.tableView];
    [self HideNavigationBarWhenScrollUpForScrollView:self.tableView];
    [self addPullRefresh];
    
    //重置筛选条件
    [MB_Utils shareUtil].rGender = -1;
    [MB_Utils shareUtil].rCareerId = @"";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestRankingListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([userDefaults boolForKey:kIsLogin]) {
        return 263;
    }else {
        //没有登录的时候不显示instra的图片
        return 160;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_User *user = self.dataArray[indexPath.row];
    cell.user = user;
    
    //前三名显示排名标志
    if (indexPath.row < 3) {
        cell.rankImageView.hidden = NO;
        NSString *imageName = [NSString stringWithFormat:@"num%ld",(long)indexPath.row + 1];
        cell.rankImageView.image = [UIImage imageNamed:imageName];
    }else {
        cell.rankImageView.hidden = YES;
    }
    
    //第一名显示王冠
    if (indexPath.row == 0) {
        cell.firstImageView.hidden = NO;
    }else {
        cell.firstImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeUser;
    userVC.user = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:userVC animated:YES];
}


#pragma mark - private methods
- (void)rightBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    //跳转到筛选界面
    MB_FilterViewController *filterVC = [[MB_FilterViewController alloc] init];
    filterVC.type = FilterTypeRanking;
    filterVC.CompleteHandler = ^(){
        [self requestRankingListWithMinId:0];
    };
    [self.navigationController pushViewController:filterVC animated:YES];
}

//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_RankingViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestRankingListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestRankingListWithMinId:weakSelf.minId];
    }];
}

//获取排行列表
- (void)requestRankingListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@(6),
                             @"token":@"abcde",
                             @"fgender":@([MB_Utils shareUtil].rGender),
                             @"fcareerId":[MB_Utils shareUtil].rCareerId,
                             @"minId":@(minId),
                             @"count":@(3)};
    [[AFHttpTool shareTool] getRankListWithParameters:params success:^(id response) {
        NSLog(@"rank %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        if ([self statFromResponse:response] == 10000) {
            
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
            
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_User *user = [[MB_User alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                user.urlArray = [NSMutableArray arrayWithCapacity:1];
                [self.dataArray addObject:user];
                
                //请求instra图片
                if ([userDefaults boolForKey:kIsLogin] && user.urlArray.count <= 0) {
                    [self requestInstragramMediasListWithUesr:user];
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

//获取指定用户的Instragram图片
- (void)requestInstragramMediasListWithUid:(NSInteger)Uid {
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%ld/media/recent/",(long)Uid];
    NSMutableDictionary *params = [@{@"access_token":[userDefaults objectForKey:kAccessToken],
                                     @"count": @(10)} mutableCopy];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"instragram %@",responseObject);

        NSArray *dataArr = responseObject[@"data"];
        
        NSInteger index = -1;
        for (NSDictionary *dic in dataArr) {
            for (MB_User *user in self.dataArray) {
                if (user.uid == Uid) {
                    index = [self.dataArray indexOfObject:user];
                    [user.urlArray addObject:dic[@"images"][@"low_resolution"][@"url"]];
                }
            }
        }
        
        if (index != -1) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//获取指定用户的Instragram图片
- (void)requestInstragramMediasListWithUesr:(MB_User *)user {
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%ld/media/recent/",(long)user.uid];
    NSMutableDictionary *params = [@{@"access_token":[userDefaults objectForKey:kAccessToken],
                                     @"count": @(10)} mutableCopy];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"instragram %@",responseObject);
        
        NSArray *dataArr = responseObject[@"data"];
        
        for (NSDictionary *dic in dataArr) {
            [user.urlArray addObject:dic[@"images"][@"low_resolution"][@"url"]];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"instra err %@",error);
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_RankingTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
