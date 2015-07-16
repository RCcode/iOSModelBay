//
//  MB_SettingViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SettingViewController.h"
#import "MB_PrivateViewController.h"
#import "MB_MainViewController.h"

@import MessageUI;

#define kFeedbackEmail @"rcplatform.help@gmail.com"

#define kFollwUsInstagramAccount @"modelbayapp"
#define kFollwUsInstagramURL @"http://www.instagram.com/modelbayapp"

//#define kFollowUsFacebookAccount @"123455"
#define kFollowUsFacebookUrl @"https://www.facebook.com/pages/ModelBay/832690196767719"


@interface MB_SettingViewController ()<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MB_SettingViewController

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Setting", nil);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            // app名称 版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
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
            
            NSString *diveceInfo = [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@", app_Name, app_Version, deviceName, deviceSystemName, deviceSystemVer, language];
            
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            if(!picker) break;
            picker.mailComposeDelegate =self;
            NSString *subject = [NSString stringWithFormat:@"ModelBay %@ (iOS)", LocalizedString(@"Feedback", nil)];
            [picker setSubject:subject];
            [picker setToRecipients:@[kFeedbackEmail]];
            [picker setMessageBody:diveceInfo isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
            
            break;
        }
            
//        case 1:
//        {
//            MB_PrivateViewController *privateVC = [[MB_PrivateViewController alloc] init];
//            [self.navigationController pushViewController:privateVC animated:YES];
//            break;
//        }
            
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
            
        case 3:
        {
            if ([userDefaults boolForKey:kIsLogin]) {
                [userDefaults setBool:NO forKey:kIsLogin];
                MB_MainViewController *mainVC = [[MB_MainViewController alloc] init];
                [self presentViewController:mainVC animated:YES completion:nil];
            }else {
                [self presentLoginViewController];
            }
            break;
        }
        default:
            break;
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

//登录成功刷新界面
- (void)loginSuccess:(NSNotification *)noti {
    [self.listTableView reloadData];
}


#pragma mark - getters & setters
- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableHeaderView = [UIView new];
        _listTableView.tableFooterView = [UIView new];
        _listTableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _listTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return _listTableView;
}

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        if ([userDefaults boolForKey:kIsLogin]) {
            _titleArray = @[LocalizedString(@"Feedback", nil),  LocalizedString(@"Follow us on Instagram", nil), LocalizedString(@"Follow us on Facebook", nil), LocalizedString(@"Logout", nil)];
        }else {
            _titleArray = @[LocalizedString(@"Feedback", nil), LocalizedString(@"Follow us on Instagram", nil), LocalizedString(@"Follow us on Facebook", nil), LocalizedString(@"Login", nil)];
        }
    }
    return _titleArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
