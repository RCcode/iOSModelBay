//
//  MB_MainViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MainViewController.h"
#import "MB_TabBarViewController.h"
#import "MB_LoginViewController.h"
#import "MB_SelectRoleViewController.h"
#import "MB_User.h"


@interface MB_MainViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIButton    * loginBtn;
@property (nonatomic, strong) UIButton    * skipBtn;
@property (nonatomic, strong) NSString    *codeStr;

@end

@implementation MB_MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.skipBtn];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //重试
        [self loginWitnCodeStr:_codeStr];
    }
}

#pragma mark - private methods

- (void)loginBtnOnClick:(UIButton *)btn{
    MB_LoginViewController *loginVC = [[MB_LoginViewController alloc] initWithSuccessBlock:^(NSString *codeStr) {
        NSLog(@"ssss%@",codeStr);
        _codeStr = codeStr;
        [self loginWitnCodeStr:codeStr];
    }];
        
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
    
//    [self loginWitnCodeStr:@"123"];
}

- (void)loginWitnCodeStr:(NSString *)codeStr {
    [[AFHttpTool shareTool] loginWithCodeString:codeStr success:^(id response) {
        NSLog(@"%@",response);
        if ([self statFromResponse:response] == 10100) {
            //未注册
            MB_SelectRoleViewController *selectRoleVC = [[MB_SelectRoleViewController alloc] init];
            MB_BaseNavigationViewController *na = [[MB_BaseNavigationViewController alloc] initWithRootViewController:selectRoleVC];
            [self presentViewController:na animated:YES completion:nil];
        }else if ([self statFromResponse:response] == 10000){
            //记录用户信息
//            {
//            backPic = "<null>";
//            careerId = "<null>";
//            follow = 0;
//            followed = 0;
//            fullName = "<null>";
//            gender = 0;
//            id = 0;
//            mess = "<null>";
//            name = "<null>";
//            pic = "<null>";
//            stat = 10100;
//            userName = "<null>";
//            utype = 0;
//        }

            [userDefaults setObject:response[@"id"] forKey:kID];
            [userDefaults setObject:response[@"gender"] forKey:kGender];
            [userDefaults setObject:response[@"name"] forKey:kName];
            [userDefaults setObject:response[@"careerId"] forKey:kCareer];
            [userDefaults setObject:response[@"utype"] forKey:kUtype];
            [userDefaults setBool:YES forKey:kIsLogin];
            [userDefaults synchronize];
            
            MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
            [self presentViewController:tabVC animated:YES completion:nil];
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
        [self showLoginFailedAlertView];
    }];
}

- (void)showLoginFailedAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"login failed,retry?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
    [alert show];
}

- (void)skipBtnOnClick:(UIButton *)btn{
    MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
    [self presentViewController:tabVC animated:YES completion:nil];
}


#pragma mark - getters & setters

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        _backImageView.image = [UIImage imageNamed:@"a"];
    }
    return _backImageView;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _loginBtn.backgroundColor = [UIColor yellowColor];
        _loginBtn.center = CGPointMake(kWindowWidth/2, 300);
        [_loginBtn setTitle:@"login" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)skipBtn{
    if (_skipBtn == nil) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _skipBtn.backgroundColor = [UIColor yellowColor];
        _skipBtn.center = CGPointMake(kWindowWidth/2, 400);
        [_skipBtn setTitle:@"skip" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
