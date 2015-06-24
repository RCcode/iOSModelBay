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

static NSString * const ReuseIdentifierMsg = @"msg";
static NSString * const ReuseIdentifierReply = @"reply";

@interface MB_MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_MessageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    [self requestMessageListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
        cell.message = self.dataArray[indexPath.row];
        return cell;
    }else {
        MB_ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierReply forIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
        cell.message = self.dataArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:userVC animated:YES];
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
        [weakSelf requestMessageListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestMessageListWithMinId:weakSelf.minId];
    }];
}

//获取留言列表
- (void)requestMessageListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getMessagesWithParameters:params success:^(id response) {
        NSLog(@"messages: %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Message *message = [[MB_Message alloc] init];
                [message setValuesForKeysWithDictionary:dic];
                [self. dataArray addObject:message];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
}

//回复留言
- (void)replyMessage:(UIButton *)button {
    NSDictionary *params = @{@"id":@"",//用户id
                             @"ucid":@(6),//评论id
                             @"fid":@(6),//评论用户id
                             @"reply":@(10)//评论
                             };
    [[AFHttpTool shareTool] replyMessageWithParameters:params success:^(id response) {
        NSLog(@"reply %@",response);
    } failure:^(NSError *err) {
        
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
