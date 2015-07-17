//
//  MB_LikersViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LikersViewController.h"
#import "MB_LikersTableViewCell.h"
#import "MB_Liker.h"
#import "MB_UserViewController.h"

@interface MB_LikersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_LikersViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Liker", nil);
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    [self requestLikesListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_LikersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_Liker *liker = self.dataArray[indexPath.row];
    cell.liker = liker;
    
    cell.collectButton.tag = indexPath.row;
    [cell.collectButton addTarget:self action:@selector(collectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self showLoginAlertIfNotLogin]) {
        MB_Liker *liker = self.dataArray[indexPath.row];
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        userVC.comeFromType = ComeFromTypeUser;
        MB_User *user = [[MB_User alloc] init];
        user.fid = liker.fid;
        user.fname = liker.fname;
        user.fpic = liker.fpic;
        user.uType = liker.utype;
        user.fbackPic = liker.fbackPic;
        user.state = liker.state;
        user.fcareerId = liker.careerId;
        userVC.user = user;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_LikersViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestLikesListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestLikesListWithMinId:weakSelf.minId];
    }];
}

- (void)requestLikesListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"ablId":@(self.ablum.ablId),//作品集id
                             @"minId":@(minId),
                             @"count":@(10),};
    [[AFHttpTool shareTool] getAblumLikesWithParameters:params success:^(id response) {
        NSLog(@"LIKERS %@",response);
        if ([self statFromResponse:response] == 10000) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Liker *liker = [[MB_Liker alloc] init];
                [liker setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:liker];
            }
            [self.tableView reloadData];
        }else if ([self statFromResponse:response] == 10004) {
            [self showNoMoreMessageForview:self.tableView];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)collectButtonOnClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        button.backgroundColor = colorWithHexString(@"#ff4f42");
        MB_Liker *liker = self.dataArray[button.tag];
        NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                                 @"token":[userDefaults objectForKey:kAccessToken],
                                 @"fid":@(liker.fid)};
        [[AFHttpTool shareTool] addLikesWithParameters:params success:^(id response) {
            NSLog(@"collect %@", response);
//            if ([self statFromResponse:response] == 10000) {
//                NSLog(@"关注成功");
//            }
//            if ([self statFromResponse:response] == 10201) {
//                NSLog(@"已经关注");
//            }
        } failure:^(NSError *err) {
            
        }];
    }
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 68;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_LikersTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}


@end
