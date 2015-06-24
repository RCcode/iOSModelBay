//
//  MB_MessageViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_NoticeViewController.h"
#import "MB_NoticeTableViewCell.h"
#import "MB_MessageTableViewCell.h"
#import "MB_Notice.h"

static NSString * const ReuseIdentifierNotice = @"notice";
static NSString * const ReuseIdentifierMessage = @"message";

@interface MB_NoticeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, assign) NSInteger       minId;

@end

@implementation MB_NoticeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

    [self addPullRefresh];
    [self HideNavigationBarWhenScrollUpForScrollView:self.tableView];
    
    [self requestNoticeListwithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row %2 == 0) {
        MB_NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierNotice forIndexPath:indexPath];
        MB_Notice *notice = self.dataArray[indexPath.row];
        cell.notice = notice;
        return cell;
    }else {
        MB_MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierMessage forIndexPath:indexPath];
        MB_Notice *notice = self.dataArray[indexPath.row];
        cell.notice = notice;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_NoticeViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestNoticeListwithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestNoticeListwithMinId:weakSelf.minId];
    }];
}

- (void)requestNoticeListwithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@(6),
                             @"token":@"abcde",
                             @"mId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getNoticeWithParameters:params success:^(id response) {
        NSLog(@"notice = %@",response);
        [self endRefreshingForView:self.tableView];
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Notice *notice = [[MB_Notice alloc] init];
                [notice setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:notice];
            }
            
            [self.tableView reloadData];
        }else if ([self statFromResponse:response] == 10004) {
            //无记录
            [self.tableView removeFromSuperview];
            self.view.backgroundColor = [UIColor greenColor];
        }
    } failure:^(NSError *err) {
        [self endRefreshingForView:self.tableView];
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        UIView *view =[[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierNotice];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MessageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierMessage];
    }
    return _tableView;
}

@end
