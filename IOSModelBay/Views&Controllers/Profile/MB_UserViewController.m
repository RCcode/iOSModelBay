//
//  MB_UserViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserViewController.h"
#import "MB_UserSummaryViewController.h"
#import "MB_AblumViewController.h"
#import "MB_InstragramViewController.h"
#import "MB_MessageViewController.h"
#import "MB_CollectViewController.h"
#import "MB_UserInfoView.h"
#import <MessageUI/MessageUI.h>

//#import "MB_SettingViewController.h"
//#import "MB_InviteViewController.h"
//#import "MB_SearchViewController.h"
#import "MB_ScanAblumViewController.h"
#import "MB_SelectPhotosViewController.h"
//#import "MB_SelectTemplateViewController.h"
#import "MB_SelectRoleViewController.h"
#import "MB_SelectCareerViewController.h"
#import "MB_CommentView.h"

@interface MB_UserViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) MB_UserInfoView *userInfoView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) MB_CommentView *commentView;

@property (nonatomic, strong) NSMutableArray *menuBtns;

@end

@implementation MB_UserViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"VINCENT";
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
    
    [super HideNavigationBarWhenScrollUpForScrollView:self.tableView];
    [self addChildViewControllers];
    [self menuBtnOnClick:self.menuBtns[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWindowHeight - CGRectGetHeight(self.menuView.frame);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.menuView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menuView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    [cell.contentView addSubview:self.containerView];
    return cell;
}


#pragma mark - UIScrollViewDelegate
static CGFloat startY;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        startY = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        //    NSLog(@"%@  %@",NSStringFromCGRect(scrollView.frame), NSStringFromUIEdgeInsets(scrollView.contentInset));;
//        NSLog(@"www%@",NSStringFromCGPoint(scrollView.contentOffset));
        if (self.scrollCoordinator.topView.frame.origin.y == -24) {
            self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        }else{
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
//        if (self.scrollCoordinator.topView.frame.origin.y >= -24 && self.scrollCoordinator.topView.frame.origin.y <= 20) {
//            self.tableView.contentInset = UIEdgeInsetsMake(self.scrollCoordinator.topView.frame.origin.y + 44, 0, 0, 0);
//        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (scrollView == self.tableView) {
            if (scrollView.contentOffset.y - startY > 0) {
                //向上拉
                if (scrollView.contentOffset.y != topViewHeight - 20) {
                    NSLog(@"dddddd");
                    [scrollView setContentOffset:CGPointMake(0, topViewHeight - 20) animated:YES];
                }
            }else{
                //向下拉
                if (scrollView.contentOffset.y != -64) {
                    NSLog(@"aaaaaa");
                    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y - startY > 0) {
            //向上拉
            if (scrollView.contentOffset.y != topViewHeight - 20) {
                NSLog(@"dddddd");
                [scrollView setContentOffset:CGPointMake(0, topViewHeight - 20) animated:YES];
            }
        }else{
            //向下拉
            if (scrollView.contentOffset.y != -64) {
                NSLog(@"aaaaaa");
                [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
        for (UIButton *btn in self.menuBtns) {
            btn.selected = NO;
        }
        
        ((UIButton *)self.menuBtns[page]).selected = YES;
        
        //如果滚动到第四个显示输入框
        if (scrollView.contentOffset.x == scrollView.frame.size.width * 3) {
            self.commentView.hidden = NO;
        }else{
            self.commentView.hidden = YES;
        }
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //通过Instragram
    }else if (buttonIndex == 1) {
        //通过邮件
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            [self presentViewController:mailVC animated:YES completion:nil];
        }else {
            NSLog(@"不可以发邮件");
        }
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
- (void)test {
//    MB_InviteViewController*inviteVC = [[MB_InviteViewController alloc] init];
    
//    MB_SearchViewController *inviteVC = [[MB_SearchViewController alloc] init];
    
//    MB_SelectRoleViewController *inviteVC = [[MB_SelectRoleViewController alloc] init];
    
    MB_SelectPhotosViewController *inviteVC = [[MB_SelectPhotosViewController alloc] init];
    
//    MB_ScanAblumViewController *inviteVC = [[MB_ScanAblumViewController alloc] init];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)addChildViewControllers {
    MB_UserSummaryViewController *summaryVC   = [[MB_UserSummaryViewController alloc] init];
    MB_AblumViewController *ablumVC           = [[MB_AblumViewController alloc] init];
    MB_InstragramViewController *instragramVC = [[MB_InstragramViewController alloc] init];
    MB_MessageViewController *messageVC       = [[MB_MessageViewController alloc] init];
    MB_CollectViewController *collectVC           = [[MB_CollectViewController alloc] init];
    
    summaryVC.containerViewRect    = self.containerView.frame;
    summaryVC.user = self.user;
    summaryVC.comeFromType = self.comeFromType;
    ablumVC.containerViewRect      = self.containerView.frame;
    instragramVC.containerViewRect = self.containerView.frame;
    instragramVC.uid = [userDefaults objectForKey:kUid];
    messageVC.containerViewRect    = self.containerView.frame;
    collectVC.containerViewRect    = self.containerView.frame;
    
    [self addChildViewController:instragramVC];
    [self addChildViewController:summaryVC];
    [self addChildViewController:ablumVC];
    [self addChildViewController:messageVC];
    [self addChildViewController:collectVC];
    
    for (int i = 0; i < 5; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(kWindowWidth * i, 0, kWindowWidth, CGRectGetHeight(self.containerView.frame));
        [self.containerView addSubview:vc.view];
    }
    
    self.containerView.contentSize = CGSizeMake(kWindowWidth * 5, CGRectGetHeight(self.containerView.frame));
}

- (void)menuBtnOnClick:(UIButton *)btn {
    
    for (UIButton *btn in self.menuBtns) {
        btn.selected = NO;
    }
    btn.selected = YES;
    
    self.containerView.contentOffset = CGPointMake(CGRectGetWidth(self.containerView.frame) * btn.tag, 0);
    //如果滚动到第四个显示输入框
    if (self.containerView.contentOffset.x == self.containerView.frame.size.width * 3) {
        self.commentView.hidden = NO;
    }else{
        self.commentView.hidden = YES;
    }
}

//收藏此用户
- (void)collectionButtonOnClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        button.layer.borderColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.9].CGColor;
        
        NSDictionary *params = @{@"id":@(6),
                                 @"token":@"abcde",
                                 @"fid":@(self.user.fid)};
        [[AFHttpTool shareTool] addLikesWithParameters:params success:^(id response) {
            NSLog(@"collect %@", response);
//            if ([self statFromResponse:response] == 10000) {
//                NSLog(@"关注成功");
//            }
//            if ([self statFromResponse:response] == 10201) {
//                NSLog(@"已经关注");
//            }
        } failure:^(NSError *err) {
            
        }];
    }
}

//邀请此用户
- (void)inviteButtonOnClick:(UIButton *)button {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Instra",@"mail", nil];
    [action showInView:self.view];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.tableHeaderView = self.userInfoView;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (MB_UserInfoView *)userInfoView {
    if (_userInfoView == nil) {
        _userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"MB_UserInfoView" owner:nil options:nil] firstObject];
        _userInfoView.frame = CGRectMake(0, 0, kWindowWidth, topViewHeight);
        [_userInfoView.userImageView sd_setImageWithURL:[NSURL URLWithString:_user.fpic] placeholderImage:nil];
        [_userInfoView.backImageView sd_setImageWithURL:[NSURL URLWithString:_user.fbackPic] placeholderImage:nil];
        _userInfoView.nameLabel.text = _user.fname;
        NSMutableArray *careerArr = [NSMutableArray arrayWithCapacity:0];
        for (NSString *career in [_user.fcareerId componentsSeparatedByString:@"|"]) {
            [careerArr addObject:[[MB_Utils shareUtil].careerDic objectForKey:career]?:@""];
        }
        _userInfoView.careerLabel.text = [careerArr componentsJoinedByString:@"  |  "];
        
        [_userInfoView.likeButton addTarget:self action:@selector(collectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userInfoView.inviteButton addTarget:self action:@selector(inviteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userInfoView;
}

- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
        _menuView.backgroundColor = colorWithHexString(@"#222222");
        
        NSArray *images = @[@"ic_instagram",@"ic_information",@"ic_set",@"ic_message",@"ic_collection"];
        NSArray *images_h  = @[@"ic_instagram_h",@"ic_information_h",@"ic_set_h",@"ic_message_h",@"ic_collection_h"];
        CGFloat btnWidth = kWindowWidth / 5;
        for (int i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnWidth * i, 0, btnWidth, CGRectGetHeight(_menuView.frame));
            button.tag = i;
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images_h[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(menuBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuBtns addObject:button];
            [_menuView addSubview:button];
        }
    }
    return _menuView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        if (self.hidesBottomBarWhenPushed) {
            _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - CGRectGetHeight(self.menuView.frame) - 20)];
        }else{
            _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - CGRectGetHeight(self.menuView.frame) - 49 - 20)];
        }
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
    }
    return _containerView;
}

//添加留言的
- (UIView *)commentView {
    if (!_commentView) {
        _commentView = [[MB_CommentView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 49 - 60, kWindowWidth, 60)];
//        _commentView.backgroundColor = [UIColor greenColor];
        _commentView.hidden = YES;
    }
    return _commentView;
}

- (NSArray *)menuBtns {
    if (_menuBtns == nil) {
        _menuBtns = [NSMutableArray arrayWithCapacity:0];
    }
    return _menuBtns;
}

@end
