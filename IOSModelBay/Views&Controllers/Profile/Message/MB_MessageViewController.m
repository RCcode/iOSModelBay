//
//  MB_MessageViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MessageViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_MsgTableViewCell.h"
#import "MB_ReplyTableViewCell.h"
#import "MB_UserViewController.h"
#import "MB_Message.h"
#import "UIButton+WebCache.h"

static NSString * const ReuseIdentifierMsg = @"msg";
static NSString * const ReuseIdentifierReply = @"reply";

@interface MB_MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, assign) NSInteger replyIndex;//记录是回复谁

@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_MessageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.commentView];
    
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestMessageListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)configureCell:(MB_MsgTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MB_Message *message = self.dataArray[indexPath.section];
    cell.message = message;
    cell.nameButton.tag = indexPath.section;
    cell.userButton.tag = indexPath.section;
    [cell.userButton addTarget:self action:@selector(nameOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameButton addTarget:self action:@selector(nameOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.replyButton.tag = indexPath.section;
    [cell.replyButton addTarget:self action:@selector(replyOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    if (userVC.comeFromType == ComeFromTypeUser) {
        //看其他用户的留言不能点回复
        cell.replyButton.hidden = YES;
        cell.replyImage.hidden = YES;
    }else {
        cell.replyButton.hidden = NO;
        cell.replyImage.hidden = NO;
    }
}

- (void)configureCell2:(MB_ReplyTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MB_Message *message = self.dataArray[indexPath.section];
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    message.replyName = userVC.user.fname;
    message.replayPic = userVC.user.fpic;
    message.replayBackPic = userVC.user.fbackPic;
    message.replyCarerrId = userVC.user.fcareerId;
    message.replyState = userVC.user.state;
    message.replyUtype = userVC.user.uType;
    
    cell.message = message;
    cell.nameButton.tag = indexPath.section;
    cell.userButton.tag = indexPath.section;
    [cell.userButton addTarget:self action:@selector(nameOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameButton addTarget:self action:@selector(nameOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
//    cell.replyNameLabel.text = userVC.user.fname;
//    [cell.replyUserButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userVC.user.fpic] forState:UIControlStateNormal];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Message *message = self.dataArray[indexPath.section];
    if (message.state == StateTypeMessage) {
        NSLog(@"%f",[tableView fd_heightForCellWithIdentifier:ReuseIdentifierMsg cacheByIndexPath:indexPath configuration:^(MB_MsgTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }]);
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierMsg cacheByIndexPath:indexPath configuration:^(MB_MsgTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierReply cacheByIndexPath:indexPath configuration:^(MB_ReplyTableViewCell *cell) {
            [self configureCell2:cell atIndexPath:indexPath];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Message *message = self.dataArray[indexPath.section];
    if (message.state == StateTypeMessage) {
        MB_MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierMsg forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else {
        MB_ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierReply forIndexPath:indexPath];
        [self configureCell2:cell atIndexPath:indexPath];
        return cell;
    }
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
                [taleView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == topViewHeight - 64) {
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
        [weakSelf requestMessageListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestMessageListWithMinId:weakSelf.minId];
    }];
}

//获取留言列表
- (void)requestMessageListWithMinId:(NSInteger)minId {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"fid":@(userVC.user.fid),
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getMessagesWithParameters:params success:^(id response) {
        NSLog(@"messages: %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        if ([self statFromResponse:response] == 10000) {
            NSArray *array = response[@"list"];
            if (array == nil || [array isKindOfClass:[NSNull class]]) {
                [self showNoMoreMessageForview:self.tableView];
            }else {
                if (minId == 0) {
                    [self.dataArray removeAllObjects];
                }
                self.minId = [response[@"minId"] integerValue];
                for (NSDictionary *dic in array) {
                    MB_Message *message = [[MB_Message alloc] init];
                    [message setValuesForKeysWithDictionary:dic];
                    [self. dataArray addObject:message];
                }
                [self.tableView reloadData];
            }
        }else if ([self statFromResponse:response] == 10004) {
            [self showNoMoreMessageForview:self.tableView];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

//点击用户名和用户头像跳到用户个人页
- (void)nameOnClick:(UIButton *)button {
    if ([self showLoginAlertIfNotLogin]) {
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        MB_Message *message = self.dataArray[button.tag];
        userVC.comeFromType = ComeFromTypeUser;
        userVC.hidesBottomBarWhenPushed = YES;
        MB_User *user = [[MB_User alloc] init];
        user.fid = message.fid;
        user.fname = message.fname;
        user.fpic = message.fpic;
        user.fbackPic = message.fbackPic;
        user.fcareerId = message.fcareerId;
        user.uType = message.futype;
        user.state = message.state;
        userVC.user = user;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

//回复留言
- (void)replyOnClick:(UIButton *)button {
    self.replyIndex = button.tag;
    
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    [userVC showCommentView];
}

- (void)commentWitnComment:(NSString *)comment {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],//用户id
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(userVC.user.fid),//评论用户id
                             @"comment":comment};
    [[AFHttpTool shareTool] addMessageWithParameters:params success:^(id response) {
        NSLog(@"coment %@",response);
        if ([self statFromResponse:response] == 10000) {
            [MB_Utils showPromptWithText:@"success"];
//            [self requestMessageListWithMinId:0];
//            MB_Message *message = [[MB_Message alloc] init];
//            message.state = StateTypeMessage;
//            message.comment = comment;
//            message.createTime = 1000;
//            message.fid = userVC.user.fid;
//            message.fname = @"songge";
//            message.uid = 6;
//            [self.dataArray addObject:message];
//            [self.tableView reloadData];
        }else {
            [MB_Utils showPromptWithText:@"failed"];
        }
    } failure:^(NSError *err) {
        [MB_Utils showPromptWithText:@"failed"];
    }];
}

- (void)replywithReply:(NSString *)reply {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    
    MB_Message *message = self.dataArray[self.replyIndex];

    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],//用户id
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"ucid":@(message.ucid),//评论id
                             @"fid":@(message.fid),//评论用户id
                             @"reply":reply//评论
                            };
    [[AFHttpTool shareTool] replyMessageWithParameters:params success:^(id response) {
        NSLog(@"reply %@",response);
        if ([self statFromResponse:response] == 10000) {
            [userVC clearCommentText];
            message.reply = reply;
            message.replyTime = 100;
            message.state = StateTypeReply;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:self.replyIndex]] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            //回复失败
            [MB_Utils showPromptWithText:@"failed"];
        }
    } failure:^(NSError *err) {
        [MB_Utils showPromptWithText:@"failed"];
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
//        if (self.parentViewController.hidesBottomBarWhenPushed) {
//            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect) - 60) style:UITableViewStyleGrouped];
//        }else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
//        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10)];
        _tableView.tableHeaderView = view;
        _tableView.tableFooterView = view;
        _tableView.allowsSelection = NO;
        _tableView.sectionHeaderHeight = 10;
        _tableView.sectionFooterHeight = 0.5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_MsgTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierMsg];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierReply];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
