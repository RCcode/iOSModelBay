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
#import "MB_SettingViewController.h"
#import "MB_CommentView.h"

#import <MessageUI/MessageUI.h>

//#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
//#define kToInstagramPath [kDocumentPath stringByAppendingPathComponent:@"NoCrop_Share_Image.igo"]
//#define kShareHotTags @""

@interface MB_UserViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIDocumentInteractionControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) MB_UserInfoView *userInfoView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) MB_CommentView *commentView;

@property (nonatomic, strong) NSMutableArray *menuBtns;
@property (nonatomic, strong) UIDocumentInteractionController *documetnInteractionController;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, assign) NSInteger type;//修改背景还是修改头像 1:头像 2:背景

@end

@implementation MB_UserViewController

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"My", nil);
    self.navigationItem.titleView = self.titleLabel;
    if (self.comeFromType == ComeFromTypeUser) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    }
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:kLoginOutNotification object:nil];
    
    if ([userDefaults boolForKey:kIsLogin]) {
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.commentView];
        
        [self addChildViewControllers];
        
        [self menuBtnOnClick:self.menuBtns[self.menuIndex]];
    }else {
        [self.view addSubview:self.notLoginView];
    }
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView) {
//        //    NSLog(@"%@  %@",NSStringFromCGRect(scrollView.frame), NSStringFromUIEdgeInsets(scrollView.contentInset));;
////        NSLog(@"www%@",NSStringFromCGPoint(scrollView.contentOffset));
//        if (self.scrollCoordinator.topView.frame.origin.y == -24) {
//            self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//        }else{
//            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        }
////        if (self.scrollCoordinator.topView.frame.origin.y >= -24 && self.scrollCoordinator.topView.frame.origin.y <= 20) {
////            self.tableView.contentInset = UIEdgeInsetsMake(self.scrollCoordinator.topView.frame.origin.y + 44, 0, 0, 0);
////        }
//    }
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (scrollView == self.tableView) {
            if (scrollView.contentOffset.y - startY > 0) {
                //向上拉
                if (scrollView.contentOffset.y != topViewHeight - 64) {
                    NSLog(@"dddddd");
                    [scrollView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
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
            if (scrollView.contentOffset.y != topViewHeight - 64) {
                NSLog(@"dddddd");
                [scrollView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
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
            if (self.comeFromType == ComeFromTypeUser) {
                self.commentView.hidden = NO;
            }else{
                self.commentView.hidden = YES;
            }
        }else{
            self.commentView.hidden = YES;
        }
    }
}


//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        //通过Instragram
//
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [self.view.layer renderInContext:context];
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
//        if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"没有安装Instragram" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            return;
//        }else {
//            //保存本地 如果已存在，则删除
//            if([[NSFileManager defaultManager] fileExistsAtPath:kToInstagramPath]){
//                [[NSFileManager defaultManager] removeItemAtPath:kToInstagramPath error:nil];
//            }
//            
//            NSData *imageData = UIImageJPEGRepresentation(img, 0.8);
//            [imageData writeToFile:kToInstagramPath atomically:YES];
//            NSLog(@"kToInstagramPath = %@",kToInstagramPath);
//            
//            //分享
//            NSURL *fileURL = [NSURL fileURLWithPath:kToInstagramPath];
//            _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
//            _documetnInteractionController.delegate = self;
//            _documetnInteractionController.UTI = @"com.instagram.exclusivegram";
//            _documetnInteractionController.annotation = @{@"InstagramCaption":kShareHotTags};
//            [_documetnInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//        }
//    }else if (buttonIndex == 1) {
//        //通过邮件
//        if ([MFMailComposeViewController canSendMail]) {
//            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
//            mailVC.mailComposeDelegate = self;
//            [self presentViewController:mailVC animated:YES completion:nil];
//        }else {
//            NSLog(@"不可以发邮件");
//        }
//    }
//}
//
//
//#pragma mark - MFMailComposeViewControllerDelegate
//- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
//    switch (result) {
//        case MFMailComposeResultCancelled:
//            
//            break;
//        case MFMailComposeResultSaved:
//            
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"mail error %@",error);
//            break;
//        case MFMailComposeResultSent:
//            
//            break;
//        default:
//            break;
//    }
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 键盘监听
- (void)keyBoardWillShow:(NSNotification *)noti {
    //滚到顶部
    if (self.tableView.contentOffset.y != topViewHeight - 64) {
        [self.tableView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
    }
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.commentView.frame;
    frame.origin.y = CGRectGetMinY(rect) - CGRectGetHeight(frame);
    self.commentView.frame = frame;
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    if (self.hidesBottomBarWhenPushed) {
        self.commentView.frame = CGRectMake(0, kWindowHeight - 60, kWindowWidth, 60);
    }else {
        self.commentView.frame = CGRectMake(0, kWindowHeight - 49 - 60, kWindowWidth, 60);
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://192.168.0.89:8082/ModelBayWeb/",@"user/updatePic.do"];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://model.rcplatformhk.net/ModelBayWeb/",@"user/updatePic.do"];
    
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken]};
    _manager = [AFHTTPRequestOperationManager manager];
    if (self.type == 1) {
        //修改头像
        AFHTTPRequestOperation *operation = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([self statFromResponse:responseObject] == 10000) {
                NSLog(@"pic success %@",responseObject);
                self.userInfoView.userImageView.image = image;
                if (responseObject[@"pic"] != nil && ![responseObject[@"pic"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setObject:responseObject[@"pic"] forKey:kPic];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ failed", operation);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
        }];
        
    }else if (self.type == 2){
        //修改背景
        AFHTTPRequestOperation *operation = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:imageData name:@"backPic" fileName:@"backPic.jpg" mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([self statFromResponse:responseObject] == 10000) {
                NSLog(@"backpic success");
                self.userInfoView.backImageView.image = image;
                if (responseObject[@"pic"] != nil && ![responseObject[@"pic"] isKindOfClass:[NSNull class]]) {
                [userDefaults setObject:responseObject[@"pic"] forKey:kBackPic];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ failed", operation);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    MB_SettingViewController *inviteVC = [[MB_SettingViewController alloc] init];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}


- (void)loginSuccess:(NSNotification *)noti {
    if (self.type == ComeFromTypeSelf) {
        MB_User *user = [[MB_User alloc] init];
        user.fid = [[userDefaults objectForKey:kID] integerValue];
        user.fname = [userDefaults objectForKey:kName];
        user.fcareerId = [userDefaults objectForKey:kCareer];
        user.fbackPic = [userDefaults objectForKey:kBackPic];
        user.fpic = [userDefaults objectForKey:kPic];
        user.uid = [[userDefaults objectForKey:kUid] integerValue];
        user.uType = [[userDefaults objectForKey:kUtype] integerValue];
        user.state = 1;
        self.user = user;
    }
    
    [self.notLoginView removeFromSuperview];
        
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
    
    [self addChildViewControllers];
    
    [self menuBtnOnClick:self.menuBtns[self.menuIndex]];
    
    [self.tableView setContentOffset:CGPointMake(0, -64)];
}

- (void)loginOutSuccess:(NSNotification *)noti {
    [self.tableView removeFromSuperview];
    _tableView = nil;
    _commentView = nil;
    _userInfoView = nil;
    _containerView = nil;
    _menuIndex = 0;
    
    [self.view addSubview:self.notLoginView];
}


- (void)addChildViewControllers {
    MB_UserSummaryViewController *summaryVC   = [[MB_UserSummaryViewController alloc] init];
    MB_AblumViewController *ablumVC           = [[MB_AblumViewController alloc] init];
    MB_InstragramViewController *instragramVC = [[MB_InstragramViewController alloc] init];
    MB_MessageViewController *messageVC       = [[MB_MessageViewController alloc] init];
    MB_CollectViewController *collectVC       = [[MB_CollectViewController alloc] init];
    
    summaryVC.containerViewRect    = self.containerView.frame;
    summaryVC.user = self.user;
    summaryVC.comeFromType = self.comeFromType;
    ablumVC.containerViewRect      = self.containerView.frame;
    ablumVC.user = self.user;
    instragramVC.containerViewRect = self.containerView.frame;
    instragramVC.uid = [NSString stringWithFormat:@"%ld",(long)self.user.uid];
    messageVC.containerViewRect    = self.containerView.frame;
    collectVC.containerViewRect    = self.containerView.frame;
    collectVC.user = self.user;
    
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


//点击菜单按钮
- (void)menuBtnOnClick:(UIButton *)btn {
    
    for (UIButton *btn in self.menuBtns) {
        btn.selected = NO;
    }
    btn.selected = YES;
    
    self.containerView.contentOffset = CGPointMake(CGRectGetWidth(self.containerView.frame) * btn.tag, 0);
    //如果滚动到第四个显示输入框
    if (self.containerView.contentOffset.x == self.containerView.frame.size.width * 3) {
        //自己的个人页的留言框需要点击回复再显示，奇特人的是滑到这页就显示
        if (self.comeFromType == ComeFromTypeUser) {
            self.commentView.hidden = NO;
        }else{
            self.commentView.hidden = YES;
        }
    }else{
        self.commentView.hidden = YES;
    }
}

//换背景
- (void)changeBackPic:(UITapGestureRecognizer *)tap {
    self.type = 2;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


//换头像
- (void)changePic:(UITapGestureRecognizer *)tap {
    self.type = 1;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//收藏此用户
- (void)collectionButtonOnClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        button.layer.borderColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.9].CGColor;
        button.backgroundColor = colorWithHexString(@"#ff4f42");
        
        NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                                 @"token":[userDefaults objectForKey:kAccessToken],
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
//    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Instra",@"mail", nil];
//    [action showInView:self.view];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [self presentViewController:mailVC animated:YES completion:nil];
    }else {
        NSLog(@"不可以发邮件");
    }
}

//发送留言或回复
- (void)sendButtonOnClick:(UIButton *)button {
    if (self.comeFromType == ComeFromTypeUser) {
        MB_MessageViewController *messageVC = self.childViewControllers[3];
        [messageVC commentWitnComment:self.commentView.textField.text];
    }else {
        [self hideCommentView];
        MB_MessageViewController *messageVC = self.childViewControllers[3];
        [messageVC replywithReply:self.commentView.textField.text];
    }
}

- (void)showCommentView {
    self.commentView.hidden = NO;
}

- (void)hideCommentView {
    self.commentView.hidden = YES;
}

- (void)clearCommentText {
    self.commentView.textField.text = @"";
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.tableHeaderView = self.userInfoView;
        
    }
    return _tableView;
}

- (MB_UserInfoView *)userInfoView {
    if (_userInfoView == nil) {
        _userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"MB_UserInfoView" owner:nil options:nil] firstObject];
        _userInfoView.frame = CGRectMake(0, 0, kWindowWidth, topViewHeight);
        _userInfoView.userImageView.userInteractionEnabled = YES;
        _userInfoView.backImageView.userInteractionEnabled = YES;
        [_userInfoView.userImageView sd_setImageWithURL:[NSURL URLWithString:_user.fpic] placeholderImage:nil];
        [_userInfoView.backImageView sd_setImageWithURL:[NSURL URLWithString:_user.fbackPic] placeholderImage:nil];
        if (self.comeFromType == ComeFromTypeSelf) {
            //添加换背景手势
            UITapGestureRecognizer *tapBackPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBackPic:)];
            [_userInfoView.coverView addGestureRecognizer:tapBackPic];
            //添加换头像手势
            UITapGestureRecognizer *tapPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePic:)];
            [_userInfoView.userImageView addGestureRecognizer:tapPic];
        }
        
        _userInfoView.nameLabel.text = _user.fname.uppercaseString;
        NSMutableArray *careerArr = [NSMutableArray arrayWithCapacity:0];
        for (NSString *career in [_user.fcareerId componentsSeparatedByString:@"|"]) {
            [careerArr addObject:[[MB_Utils shareUtil].careerDic objectForKey:career]?:@""];
        }
        _userInfoView.careerLabel.text = [careerArr componentsJoinedByString:@"  |  "];
        
        [_userInfoView.likeButton setTitle:LocalizedString(@"Favor", nil) forState:UIControlStateNormal];
        [_userInfoView.likeButton setTitle:LocalizedString(@"Favor", nil) forState:UIControlStateSelected];
        [_userInfoView.likeButton addTarget:self action:@selector(collectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userInfoView.inviteButton addTarget:self action:@selector(inviteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.comeFromType == ComeFromTypeSelf) {
            _userInfoView.inviteButton.hidden = YES;
            _userInfoView.likeButton.hidden = YES;

        }else{
            if (self.user.state == 0 && self.user.uType == 1 && [[userDefaults objectForKey:kUtype] integerValue] == 1) {
                _userInfoView.inviteButton.hidden = NO;
            }else{
                _userInfoView.likeLeading.constant = (kWindowWidth - 110) / 2;
                _userInfoView.inviteButton.hidden = YES;
            }
        }
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
            _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - CGRectGetHeight(self.menuView.frame) - 64)];
        }else{
            _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - CGRectGetHeight(self.menuView.frame) - 49 - 64)];
        }
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
    }
    return _containerView;
}

//添加留言的
- (UIView *)commentView {
    if (!_commentView) {
        if (self.hidesBottomBarWhenPushed) {
            _commentView = [[MB_CommentView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 60, kWindowWidth, 60)];
        }else {
            _commentView = [[MB_CommentView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 49 - 60, kWindowWidth, 60)];
        }
        
        _commentView.hidden = YES;
        _commentView.textField.delegate = self;
        [_commentView.sendButton addTarget:self action:@selector(sendButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
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
