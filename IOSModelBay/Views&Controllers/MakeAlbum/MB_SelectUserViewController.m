//
//  MB_SelectUserViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/17.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectUserViewController.h"
#import "MB_UserTableViewCell.h"

@interface MB_SelectUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_SelectUserViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
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


#pragma mark - getters & setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_UserTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
