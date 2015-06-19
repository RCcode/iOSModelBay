//
//  MB_MessageViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_NoticeViewController.h"
#import "MB_UserTableViewCell.h"
#import "JDFPeekabooCoordinator.h"

static CGFloat const menuBtnWidth = 150;

@interface MB_NoticeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton       *noticeBtn;
@property (nonatomic, strong) UIButton       *messageBtn;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) NSMutableArray *Array;
@property (nonatomic, strong) UIView         *tableHeaderView;

@end

@implementation MB_NoticeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableHeaderView];

    [self addPullRefresh];
    [self HideNavigationBarWhenScrollUpForScrollView:self.tableView];
    
    [self requestNoticeListwithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.usernameLabel.text = @"songge";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat topViewContentOffsetY = self.scrollCoordinator.topView.frame.origin.y;
    if (topViewContentOffsetY == 0) {
        return;
    }
//    NSLog(@"%f",topViewContentOffsetY);
    if (topViewContentOffsetY >= -24 && topViewContentOffsetY <= 20) {
            CGRect headerRect = self.tableHeaderView.frame;
            headerRect.origin.y = topViewContentOffsetY + 44;
            self.tableHeaderView.frame = headerRect;
//            NSLog(@"www%@",NSStringFromCGRect(self.tableHeaderView.frame));
    }else{
        
    }
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_NoticeViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf endFooterRefreshingForView:weakSelf.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)requestNoticeListwithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"mId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getMessagesWithParameters:params success:^(id response) {
        NSLog(@"notice = %@",response);
    } failure:^(NSError *err) {
        
    }];
}

- (void)noticeBtnOnClick:(UIButton *)button {
    self.messageBtn.selected = NO;
    button.selected = YES;
}

- (void)messageBtnOnClick:(UIButton *)button {
    self.noticeBtn.selected = NO;
    button.selected = YES;
}

#pragma mark - getters & setters

- (UIView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 60)];
        _tableHeaderView.backgroundColor = self.view.backgroundColor;
        [_tableHeaderView addSubview:self.messageBtn];
        [_tableHeaderView addSubview:self.noticeBtn];
        return _tableHeaderView;
    }
    return _tableHeaderView;
}

- (UIButton *)noticeBtn {
    if (_noticeBtn == nil) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeBtn.frame = CGRectMake((kWindowWidth - (menuBtnWidth * 2)) / 2, 5, menuBtnWidth, 40);
        [_noticeBtn setBackgroundImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
        [_noticeBtn setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateSelected];
        [_noticeBtn addTarget:self action:@selector(noticeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _noticeBtn.selected = YES;
    }
    return _noticeBtn;
}

- (UIButton *)messageBtn {
    if (_messageBtn == nil) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(CGRectGetMaxX(self.noticeBtn.frame), 5, menuBtnWidth, 40);
        [_messageBtn setBackgroundImage:[UIImage imageNamed:@"a"] forState:UIControlStateNormal];
        [_messageBtn setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateSelected];
        [_messageBtn addTarget:self action:@selector(messageBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.tableHeaderView.frame), 0, 0, 0);
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_UserTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end