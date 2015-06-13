//
//  MB_RankingViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_RankingViewController.h"
#import "MB_RankingTableViewCell.h"

@interface MB_RankingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_RankingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - private methods

#pragma mark - getters & setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"MB_RankingTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
