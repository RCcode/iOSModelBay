//
//  MB_SearchViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SearchViewController.h"
#import "MB_UserTableViewCell.h"

@interface MB_SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UITableView *listTableView;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
  //搜索用户
    
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


#pragma mark - getters & setters

- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth - 50, 50)];
        searchBar.placeholder = @"sas";
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
        _tableHeaderView.backgroundColor = [UIColor redColor];
    }
    return _tableHeaderView;
}

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] init];
        
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MB_UserTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _listTableView;
}

@end
