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
#import "MB_ReplyTableViewCell.h"
#import "MB_UserViewController.h"

static NSString * const ReuseIdentifierMsg = @"msg";
static NSString * const ReuseIdentifierReply = @"reply";

@interface MB_MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_MessageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataArray.count;
    return 1;
}

- (void)configureCell:(MB_MsgTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    cell.label1.text = @"sfhhhhhhhhhhhhhhhhhhccdsksjd说的话就会受到疾病发生的爆发你的身份决定是否独守空房多少分阶段师傅的说法vkvsjvnncxnvxnmvnxcvxcvnmxcnvmncxvncnvmcxnvmxcnvmnxcnv     \n  xcnvxnvcxv";
//    cell.label2.text = _text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:ReuseIdentifier cacheByIndexPath:indexPath configuration:^(MB_MsgTableViewCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
    
    return 168;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self configureCell:cell atIndexPath:indexPath];
    if (indexPath.section %2 == 0) {
        MB_MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierMsg forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }else {
        MB_ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierReply forIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
static CGFloat startY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    UITableView *taleView = userVC.tableView;
    if (scrollView.dragging) {
        if (scrollView.contentOffset.y - startY > 0) {
            //向上拉
            if (taleView.contentOffset.y == -64) {
                [taleView setContentOffset:CGPointMake(0, 250) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == 250) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10)];
//        _tableView.tableHeaderView = view;
//        _tableView.tableFooterView = view;
        _tableView.sectionHeaderHeight = 10;
        _tableView.sectionFooterHeight = 0;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MsgTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierMsg];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierReply];
    }
    
    return _tableView;
}


@end
