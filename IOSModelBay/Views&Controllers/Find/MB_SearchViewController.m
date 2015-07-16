//
//  MB_SearchViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SearchViewController.h"
#import "MB_User.h"
#import "MB_UserTableViewCell.h"
#import "MB_InviteView.h"
#import "MB_InviteViewController.h"
#import "MB_UserViewController.h"
@import MessageUI;

@interface MB_SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, InviteViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *inviteLabel;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) MB_InviteView *inviteView;

@property (nonatomic, assign) NSInteger minId;//分页用的


@end

@implementation MB_SearchViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.listTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    MB_User *user = self.dataArray[indexPath.row];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self showLoginAlertIfNotLogin]) {
        MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
        userVC.user = self.dataArray[indexPath.row];
        userVC.comeFromType = ComeFromTypeUser;
        userVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    
    [textField resignFirstResponder];
    [MB_Utils shareUtil].fName = textField.text;
    
    self.listTableView.tableHeaderView = self.tableHeaderView;
    self.inviteLabel.text = [NSString stringWithFormat:@"invite %@",textField.text];
    
    //搜索用户
    NSMutableDictionary *params = [@{@"fname":textField.text,
                                     @"minId":@(0),
                                     @"count":@(10)} mutableCopy];
    //    if ([userDefaults boolForKey:kIsLogin]) {
    //        [params setObject:[userDefaults objectForKey:kID] forKey:@"id"];
    //        [params setObject:[userDefaults objectForKey:kID] forKey:@"token"];
    //    }
    
    [[AFHttpTool shareTool] findUserWithParameters:params success:^(id response) {
        NSLog(@"search list%@",response);
        [self endRefreshingForView:self.listTableView];
        if ([self statFromResponse:response] == 10000) {
            NSArray *userList = response[@"list"];
            if (userList == nil || [userList isKindOfClass:[NSNull class]] || userList.count <= 0) {
                [self showNoMoreMessageForview:self.listTableView];
                return;
            }
            
//            if (minId == 0) {
//                [self.dataArray removeAllObjects];
//            }
            
            self.minId = [response[@"minId"] integerValue];
            for (NSDictionary *dic in response[@"list"]) {
                MB_User *user = [[MB_User alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:user];
            }
            [self.listTableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
    return YES;
}


#pragma mark - InviteViewDelegate
-(void)inviteRightViewOnClick:(UIButton *)button {
    [self.inviteView removeFromSuperview];
    
    MB_InviteViewController *inviteVC = [[MB_InviteViewController alloc] init];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

-(void)textFieldReturnClick:(UITextField *)textField {
    //邀请
    NSLog(@"invite textField = %@",textField.text);
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [self presentViewController:mailVC animated:YES completion:nil];
    }else {
        NSLog(@"不可以发邮件");
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"mail error %@",error);
            break;
        case MFMailComposeResultSent:
            
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
- (void)cancelBtnOnClick:(UIButton *)btn {
    if ([self.textField.text isEqualToString:@""]) {
        //返回上一界面
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //清除内容
        self.textField.text = @"";
    }
}

- (void)inviteButtonOnClick:(UIButton *)button {
    NSString *string = [NSString stringWithFormat:@"Enter %@'s email",self.textField.text];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#a8a8a8") range:NSMakeRange(0, string.length)];
    self.inviteView.textField.attributedPlaceholder = attribute;
    [[UIApplication sharedApplication].keyWindow addSubview:self.inviteView];
    [self.inviteView.textField becomeFirstResponder];
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kWindowWidth, 50)];
        _searchView.backgroundColor = colorWithHexString(@"#5f5f5f");
        _searchView.tintColor = [UIColor whiteColor];
        
        //搜索图标
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, (CGRectGetHeight(_searchView.frame) - 24) / 2, 24, 24)];
        imageView.image = [UIImage imageNamed:@"ic_seach"];
        [_searchView addSubview:imageView];
        
        //输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 12, 0, CGRectGetWidth(_searchView.frame) - CGRectGetMaxX(imageView.frame) - 66 - 12, CGRectGetHeight(_searchView.frame))];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"search username"];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeStr.length)];
        textField.attributedPlaceholder = attributeStr;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = [UIColor whiteColor];
        textField.delegate = self;
        [textField becomeFirstResponder];
        self.textField = textField;
        [_searchView addSubview:textField];
        
        if (![[MB_Utils shareUtil].fName isEqualToString:@""]) {
            textField.text = [MB_Utils shareUtil].fName;
        }
        
        //取消按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), 0, 66, CGRectGetHeight(_searchView.frame))];
        [button setBackgroundColor:colorWithHexString(@"#444444")];
        [button setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:button];

    }
    return _searchView;
}

- (UIView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
        _tableHeaderView.backgroundColor = colorWithHexString(@"#f4f4f4");
        
        //邀请提示
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kWindowWidth - 12 - 64 - 20, CGRectGetHeight(_tableHeaderView.frame))];
        label.font = [UIFont fontWithName:@"CenturyGothic" size:15];
        label.textColor = colorWithHexString(@"#222222");
        [_tableHeaderView addSubview:label];
        self.inviteLabel = label;
        
        //邀请
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetMaxX(label.frame), (CGRectGetHeight(_tableHeaderView.frame) - 29) / 2, 64, 29);
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"CenturyGothic" size:15];
        [button setTitle:@"invite" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inviteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:button];
    }
    return _tableHeaderView;
}

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.layoutMargins = UIEdgeInsetsZero;
        _listTableView.tableFooterView = [[UIView alloc] init];
        
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MB_UserTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _listTableView;
}

- (MB_InviteView *)inviteView {
    if (_inviteView == nil) {
        _inviteView = [[MB_InviteView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) delegate:self];
    }
    return _inviteView;
}

@end
