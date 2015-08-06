//
//  MB_SettingViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SettingViewController.h"
#import "MB_MainViewController.h"
#import "MB_TabBarViewController.h"

@import MessageUI;

@interface MB_SettingViewController ()<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UIView      *footView;
@property (nonatomic, strong) NSArray     *titleArray;

@end

@implementation MB_SettingViewController

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor     = colorWithHexString(@"#eeeeee");
    
    self.titleLabel.text          = LocalizedString(@"Setting", nil);
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginInNotification object:nil];
    
    [self.view addSubview:self.listTableView];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"FuturaStd-Book" size:17];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                // app名称 版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//                NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                //设备型号 系统版本
                NSString *deviceName = doDevicePlatform();
                NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
                NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
                
                //设备分辨率
                //            CGFloat scale = [UIScreen mainScreen].scale;
                //            CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
                //            CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
                //            NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
                
                //本地语言
                NSString *language = [[NSLocale preferredLanguages] firstObject];
                
                NSString *diveceInfo = [NSString stringWithFormat:@" %@, %@, %@ %@, %@", app_Version, deviceName, deviceSystemName, deviceSystemVer, language];
                
                //直接发邮件
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    if(!picker) break;
                    picker.mailComposeDelegate =self;
                    NSString *subject = [NSString stringWithFormat:@"ModelBay %@ (iOS)", LocalizedString(@"Feedback", nil)];
                    [picker setSubject:subject];
                    [picker setToRecipients:@[kFeedbackEmail]];
                    [picker setMessageBody:diveceInfo isHTML:NO];
                    [self presentViewController:picker animated:YES completion:nil];
                }else {
//                    [MB_Utils showAlertViewWithMessage:LocalizedString(@"Cant_Mail", nil)];
                    [MB_Utils showPromptWithText:LocalizedString(@"Cant_Mail", nil)];
                }
                
                break;
            }
                
            case 1:
            {
                NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@", kFollwUsInstagramAccount]];
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                    [[UIApplication sharedApplication] openURL:instagramURL];
                }else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFollwUsInstagramURL]];
                }
                break;
            }
                
            case 2:
            {
                //            @"fb://profile/93693583250"
                //            NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", kFollowUsFacebookAccount]];
                //            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                //                [[UIApplication sharedApplication] openURL:instagramURL];
                //            }else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFollowUsFacebookUrl]];
                //            }
                break;
            }
                
            default:
                break;
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
- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginButtonOnClick:(UIButton *)button {
    if ([userDefaults boolForKey:kIsLogin]) {
        
        //注销
        [userDefaults setBool:NO forKey:kIsLogin];
        
        //发送注销通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutNotification object:nil];
        
        //tabBar回到首页
        MB_TabBarViewController *tab = (MB_TabBarViewController *)self.tabBarController;
        [tab scrollToHome];
        
        //tabBar的所有页面回到首页
        for (UIViewController *vc in self.tabBarController.viewControllers) {
            UINavigationController *na = (UINavigationController *)vc;
            [na popToRootViewControllerAnimated:YES];
        }
        
    }else {
        //登录
        [self showLoginAlert];
    }
}

//登录成功刷新界面
- (void)loginSuccess:(NSNotification *)noti {
    [self.listTableView reloadData];
}


#pragma mark - getters & setters
- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, kWindowWidth - 24, kWindowHeight- 12 - 64) style:UITableViewStylePlain];
        _listTableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _listTableView.delegate        = self;
        _listTableView.dataSource      = self;
        _listTableView.tableHeaderView = [UIView new];
        _listTableView.tableFooterView = self.footView;
        _listTableView.contentInset    = UIEdgeInsetsMake(76, 0, 0, 0);
        _listTableView.scrollEnabled   = NO;
    }
    return _listTableView;
}

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[LocalizedString(@"Feedback", nil), LocalizedString(@"Follow us on Instagram", nil), LocalizedString(@"Follow us on Facebook", nil)];
    }
    return _titleArray;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
        UIButton *button = [MB_CustomButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor      = colorWithHexString(@"#ff6358");
        button.titleLabel.textColor = colorWithHexString(@"#ffffff");
        button.titleLabel.font      = [UIFont fontWithName:@"FuturaStd-Book" size:15];
        button.frame                = CGRectMake(0, 21, kWindowWidth - 24, 43);
        if ([userDefaults boolForKey:kIsLogin]) {
            [button setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
        }else{
            [button setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(loginButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:button];
    }
    return _footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
