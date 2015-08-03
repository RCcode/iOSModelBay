//
//  MB_SelectUserViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/17.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectUserViewController.h"
#import "MB_UserTableViewCell.h"
#import "MB_SearchViewController.h"

@interface MB_SelectUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_SelectUserViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestLikesListWithMinId:0];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {\
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    MB_Collect *collect = self.dataArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:collect.fpic]];
    cell.usernameLabel.text = collect.fname.uppercaseString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Collect *collect = self.dataArray[indexPath.row];
    self.selectBlock(collect);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_SelectUserViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestLikesListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"foot");
        [weakSelf requestLikesListWithMinId:weakSelf.minId];
    }];
}

//获取作品集列表
- (void)requestLikesListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":[userDefaults objectForKey:kID],
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getLikesWithParameters:params success:^(id response) {
        NSLog(@"likes: %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        
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
                [self.tableView reloadData];
            }
        }else if ([self statFromResponse:response] == 10004) {
            [self showNoMoreMessageForview:self.tableView];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

//点击搜索
- (void)handleTap:(UITapGestureRecognizer *)tap {
    MB_SearchViewController *searchVC = [[MB_SearchViewController alloc] init];
    searchVC.searchType = SearchTypeAblum;
    searchVC.selectUserVC = self;
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 49)];
        _searchView.backgroundColor = colorWithHexString(@"#444444");
        //添加点击手势,点击跳到搜索界面
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_searchView addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, (CGRectGetHeight(_searchView.frame) - 24) / 2, 24, 24)];
        imageView.image = [UIImage imageNamed:@"ic_seach"];
        [_searchView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 12, 0, CGRectGetWidth(_searchView.frame) - CGRectGetMaxX(imageView.frame) - 12, CGRectGetHeight(_searchView.frame))];
        label.font      = [UIFont systemFontOfSize:15];
        label.text      = LocalizedString(@"Search name", nil);
        label.textColor = [colorWithHexString(@"#ffffff") colorWithAlphaComponent:0.5];
        [_searchView addSubview:label];
    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
//        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_UserTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
