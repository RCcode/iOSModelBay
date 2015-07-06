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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
    [self requestCommentsListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.usernameLabel.text = @"songge";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%s",__FUNCTION__);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%s",__FUNCTION__);
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s",__FUNCTION__);
    if (textView.text && ![textView.text isEqualToString:@""]) {
        self.sendButton.enabled = YES;
    }else {
        self.sendButton.enabled = NO;
    }
}


#pragma mark - private methods
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
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"ablId":@"",//作品集id
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getAblumCommentsWithParameters:params success:^(id response) {
        NSLog(@"comments %@",response);
        if ([self statFromResponse:response] == 10000) {
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
        
    }];
}

- (void)sendButtonOnClick:(UIButton *)button {
    [self.textView resignFirstResponder];
    NSLog(@"%@",self.textView.text);
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - commentViewHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.text = @"ssss";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(kWindowWidth - 50, 0, 50, commentViewHeight);
        _sendButton.backgroundColor = [UIColor grayColor];
        _sendButton.enabled = NO;
        
        [_sendButton setTitle:@"send" forState:UIControlStateNormal];
        [_sendButton setTitle:@"kong" forState:UIControlStateDisabled];
        [_sendButton addTarget:self action:@selector(sendButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
