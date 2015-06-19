//
//  MB_SearchViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SearchViewController.h"
#import "MB_UserTableViewCell.h"
#import "MB_InviteView.h"
#import "MB_InviteViewController.h"

@interface MB_SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, InviteViewDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *inviteLabel;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) MB_InviteView *inviteView;

@end

@implementation MB_SearchViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.listTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.usernameLabel.text = @"songge";
    return cell;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [searchBar resignFirstResponder];
    self.listTableView.tableHeaderView = self.tableHeaderView;
    self.inviteLabel.text = [NSString stringWithFormat:@"invite %@",searchBar.text];
    
    //搜索用户
    NSMutableDictionary *params = [@{@"fgender":@([MB_Utils shareUtil].gender),
                                     @"fcareerId":[MB_Utils shareUtil].careerId?:@"",
                                     @"minId":@(0),
                                     @"count":@(10)} mutableCopy];
    //    if ([userDefaults boolForKey:kIsLogin]) {
    //        [params setObject:[userDefaults objectForKey:kID] forKey:@"id"];
    //        [params setObject:[userDefaults objectForKey:kID] forKey:@"token"];
    //    }
    
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"search list%@",response);
        
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark - InviteViewDelegate
-(void)inviteRightViewOnClick:(UIButton *)button {
    [self.inviteView removeFromSuperview];
    MB_InviteViewController *inviteVC = [[MB_InviteViewController alloc] init];
    [self.navigationController pushViewController:inviteVC animated:YES];
}


#pragma mark - private methods
- (void)cancelBtnOnClick:(UIButton *)btn {
    if ([self.searchBar.text isEqualToString:@""]) {
        //返回上一界面
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //清除内容
        self.searchBar.text = @"";
    }
}

- (void)inviteButtonOnClick:(UIButton *)button {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inviteView];
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kWindowWidth, 50)];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth - 50, 50)];
        searchBar.placeholder = @"sas";
        if (![[MB_Utils shareUtil].name isEqualToString:@""]) {
            searchBar.text = [MB_Utils shareUtil].name;
        }
        searchBar.delegate = self;
        [searchBar becomeFirstResponder];
        [_searchView addSubview:searchBar];
        self.searchBar = searchBar;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBar.frame), 0, 50, 50)];
        [button setImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:button];
    }
    return _searchView;
}

- (UIView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        _tableHeaderView.backgroundColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth - 50, 50)];
        [_tableHeaderView addSubview:label];
        self.inviteLabel = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 50, 50);
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"invite" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inviteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:button];
    }
    return _tableHeaderView;
}

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 80;
        _listTableView.tableFooterView = [[UIView alloc] init];
        
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MB_UserTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _listTableView;
}

- (MB_InviteView *)inviteView {
    if (_inviteView == nil) {
        _inviteView = [[MB_InviteView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) delegate:self];

    }
    return _inviteView;
}

@end
