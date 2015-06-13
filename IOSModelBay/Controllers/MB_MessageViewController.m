//
//  MB_MessageViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MessageViewController.h"
#import "SVPullToRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_MsgTableViewCell.h"

@interface MB_MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_MessageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.tableView];
//    [self addPullRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataArray.count;
    return 9;
}

- (void)configureCell:(MB_MsgTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    cell.label1.text = @"sfhhhhhhhhhhhhhhhhhhccdsksjd说的话就会受到疾病发生的爆发你的身份决定是否独守空房多少分阶段师傅的说法vkvsjvnncxnvxnmvnxcvxcvnmxcnvmncxvncnvmcxnvmxcnvmnxcnv     \n  xcnvxnvcxv";
//    cell.label2.text = _text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:ReuseIdentifier cacheByIndexPath:indexPath configuration:^(MB_MsgTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_MessageViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf endFooterRefreshingForView:weakSelf.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefreshingForView:weakSelf.tableView];
        });
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf endHeaderRefreshingForView:weakSelf.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefreshingForView:weakSelf.tableView];
            [weakSelf showNoMoreMessageForview:weakSelf.tableView];
        });
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view =[[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MsgTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}


@end
