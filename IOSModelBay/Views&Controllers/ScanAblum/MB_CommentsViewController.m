//
//  MB_CommentsViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/19.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_CommentsViewController.h"
#import "MB_CommentTableViewCell.h"
#import "MB_Comment.h"
#import "MB_UserViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

static CGFloat const commentViewHeight = 50;

@interface MB_CommentsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_CommentsViewController

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Comments", nil);
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    
    [self.view addSubview:self.commentView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestCommentsListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:ReuseIdentifier cacheByIndexPath:indexPath configuration:^(MB_CommentTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(MB_CommentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MB_Comment *comment = self.dataArray[indexPath.row];
    cell.comment = comment;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self showLoginAlertIfNotLogin]) {
        MB_Comment *comment = self.dataArray[indexPath.row];
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        userVC.comeFromType = ComeFromTypeUser;
        MB_User *user  = [[MB_User alloc] init];
        user.fid       = comment.fid;
        user.fname     = comment.fname;
        user.fpic      = comment.fpic;
        user.fbackPic  = comment.fbackPic;
        user.uType     = comment.utype;
        user.state     = comment.state;
        user.fcareerId = comment.fcareerId;
        user.uid       = comment.fuid;
        userVC.user    = user;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:LocalizedString(@"Add_Reply", nil)]) {
        textView.text = @"";
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text && ![textView.text isEqualToString:@""]) {
        self.sendButton.enabled = YES;
    }else {
        self.sendButton.enabled = NO;
    }
}

#pragma mark - 键盘监听
- (void)keyBoardWillShow:(NSNotification *)noti {
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.commentView.frame;
    frame.origin.y = CGRectGetMinY(rect) - CGRectGetHeight(frame);
    self.commentView.frame = frame;
}

- (void)keyBoardWillHide:(NSNotification *)noti {
//    if (self.hidesBottomBarWhenPushed) {
        self.commentView.frame = CGRectMake(0, kWindowHeight - commentViewHeight, kWindowWidth, commentViewHeight);
//    }else {
//        self.commentView.frame = CGRectMake(0, kWindowHeight - 49 - 60, kWindowWidth, 60);
//    }
}

#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_CommentsViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestCommentsListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestCommentsListWithMinId:weakSelf.minId];
    }];
}

//获取评论列表
- (void)requestCommentsListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"ablId":@(self.ablum.ablId),//作品集id
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getAblumCommentsWithParameters:params success:^(id response) {
        NSLog(@"comments %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        if ([self statFromResponse:response] == 10000) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
                [self.tableView setContentOffset:CGPointMake(0, -64)];
            }
            
            self.minId = [response[@"minId"] integerValue];
            
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Comment *comment = [[MB_Comment alloc] init];
                [comment setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:comment];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

- (void)sendButtonOnClick:(UIButton *)button {
    [self.textView resignFirstResponder];
    self.sendButton.enabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.ablum.uid),
                             @"ablId":@(self.ablum.ablId),//作品集id
                             @"comment":self.textView.text};
    [[AFHttpTool shareTool] commentAblumWithParameters:params success:^(id response) {
        NSLog(@"comment send  %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self statFromResponse:response] == 10000) {
            self.textView.text = @"";
            [self requestCommentsListWithMinId:0];
        }else {
            self.sendButton.enabled = YES;
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.sendButton.enabled = YES;
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - commentViewHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset    = UIEdgeInsetsMake(64, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MB_CommentTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

- (UIView *)commentView {
    if (_commentView == nil) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - commentViewHeight, kWindowWidth, commentViewHeight)];
        [_commentView addSubview:self.textView];
        [_commentView addSubview:self.sendButton];
    }
    return _commentView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth - 50, commentViewHeight) textContainer:nil];
        _textView.text = LocalizedString(@"Add_Reply", nil);
        _textView.backgroundColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(kWindowWidth - 50, 0, 50, commentViewHeight);
        _sendButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1];
        _sendButton.enabled = NO;
        
        [_sendButton setTitle:LocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
