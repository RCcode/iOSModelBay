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
#import "MB_User.h"

@interface MB_RankingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_RankingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RANKING";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_screening"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnOnCLick:)];
    
    [self.view addSubview:self.tableView];
    [self HideNavigationBarWhenScrollUpForScrollView:self.tableView];
    [self addPullRefresh];
    
    //重置筛选条件
    [MB_Utils shareUtil].rGender = -1;
    [MB_Utils shareUtil].rCareerId = @"";
    
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
    return 300;
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
    
    cell.collectButton.tag = indexPath.row;
    if (indexPath.row %2 == 0) {
        cell.collectButton.selected = YES;
        cell.collectButton.backgroundColor = [UIColor redColor];
    }else {
        cell.collectButton.selected = NO;
        cell.collectButton.backgroundColor = [UIColor whiteColor];
    }
    [cell.collectButton addTarget:self action:@selector(collectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
                             @"count":@(10)};
    [[AFHttpTool shareTool] getRankListWithParameters:params success:^(id response) {
        NSLog(@"rank %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_User *user = [[MB_User alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:user];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
}

//点击收藏按钮
- (void)collectButtonOnClick:(UIButton *)button {
    button.selected = YES;
    button.backgroundColor = [UIColor redColor];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_RankingTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
