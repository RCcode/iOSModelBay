//
//  MB_EditSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/6.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_EditSummaryViewController.h"

@interface MB_EditSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger optionIndex;

@end

@implementation MB_EditSummaryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dong" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    
    NSArray *array = [[MB_Utils shareUtil].optionsDic objectForKey:@(_index)];
    self.dataArray = [array copy];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _optionIndex = indexPath.row;
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    self.blcok(self.index, self.optionIndex);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        _tableView.sectionHeaderHeight = 10.5;
//        _tableView.sectionFooterHeight = 0;
        
//        _tableView.layoutMargins = UIEdgeInsetsZero;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UIView *view = [[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
