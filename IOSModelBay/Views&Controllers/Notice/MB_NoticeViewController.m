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
#import "MB_MessageReplyTableViewCell.h"
#import "MB_Notice.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_UserViewController.h"

static NSString * const ReuseIdentifierNotice  = @"notice";
static NSString * const ReuseIdentifierMessage = @"message";
static NSString * const ReuseIdentifierReply   = @"reply";

@interface MB_NoticeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, assign) NSInteger       minId;

@end

@implementation MB_NoticeViewController

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Activity", nil).uppercaseString;
    self.navigationItem.titleView = self.titleLabel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:kLoginOutNotification object:nil];
    
    if ([userDefaults boolForKey:kIsLogin]) {
        [self.view addSubview:self.tableView];
        [self addPullRefresh];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestNoticeListwithMinId:0];
    }else {
        [self.view addSubview:self.notLoginView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MB_Notice *notice = self.dataArray[indexPath.row];
    
    switch (notice.mtype) {
        case NoticeTypeMessage:
        case NoticeTypeReplay:
            return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierMessage cacheByIndexPath:indexPath configuration:^(MB_MessageTableViewCell *cell) {
                [self configureCell2:cell atIndexPath:indexPath];
            }];
            break;
            
        case NoticeTypeCollect:
        case NoticeTypeMention:
        case NoticeTypeLike:
        case NoticeTypeComment:
            return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierNotice cacheByIndexPath:indexPath configuration:^(MB_NoticeTableViewCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
            break;
            
        default:
            break;
    }
}

- (void)configureCell:(MB_NoticeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MB_Notice *notice = self.dataArray[indexPath.row];
    cell.notice = notice;
}

- (void)configureCell2:(MB_MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MB_Notice *notice = self.dataArray[indexPath.row];
    cell.notice = notice;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Notice *notice = self.dataArray[indexPath.row];
    switch (notice.mtype) {
        case NoticeTypeMessage:
        case NoticeTypeReplay:
        {
            MB_MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierMessage forIndexPath:indexPath];
            [self configureCell2:cell atIndexPath:indexPath];
            return cell;
        }
            
        case NoticeTypeCollect:
        case NoticeTypeMention:
        case NoticeTypeLike:
        case NoticeTypeComment:
        {
            MB_NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierNotice forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MB_Notice *notice = self.dataArray[indexPath.row];
    
    if ([self showLoginAlertIfNotLogin]) {
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        userVC.comeFromType = ComeFromTypeUser;
        userVC.hidesBottomBarWhenPushed = YES;
        
        MB_User *user  = [[MB_User alloc] init];
        user.fid       = notice.fid;
        user.fname     = notice.fname;
        user.fcareerId = notice.careerId;
        user.fpic      = notice.fpic;
        user.fbackPic  = notice.backPic;
        user.uType     = notice.utype;
        user.state     = notice.state;
        user.uid       = notice.fuid;
        userVC.user = user;
        
        switch (notice.mtype) {
            case NoticeTypeCollect:
            {
                userVC.menuIndex = 4;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            case NoticeTypeMention:
            {
                userVC.menuIndex = 2;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            case NoticeTypeLike:
            {
                userVC.menuIndex = 2;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            case NoticeTypeComment:
            {
                userVC.menuIndex = 2;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            case NoticeTypeMessage:
            {
                userVC.menuIndex = 3;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            case NoticeTypeReplay:
            {
                userVC.menuIndex = 3;
                [self.navigationController pushViewController:userVC animated:YES];
                break;
            }
            default:
                break;
        }

    }
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
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getNoticeWithParameters:params success:^(id response) {
        NSLog(@"notice = %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        
        if ([self statFromResponse:response] == 10000) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
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
            [self showNoMoreMessageForview:self.tableView];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

- (void)loginSuccess:(NSNotification *)noti {
    [self.notLoginView removeFromSuperview];
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestNoticeListwithMinId:0];
}

- (void)loginOutSuccess:(NSNotification *)noti {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    [self.view addSubview:self.notLoginView];
}

#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        
        UIView *view =[[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierNotice];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MessageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierMessage];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MessageReplyTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierReply];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
