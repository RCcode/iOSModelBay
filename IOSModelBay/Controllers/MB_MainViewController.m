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
#import "MB_User.h"


@interface MB_MainViewController ()

@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIButton    * loginBtn;
@property (nonatomic, strong) UIButton    * skipBtn;

@end

@implementation MB_MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.skipBtn];
}


#pragma mark - private methods

- (void)loginBtnOnClick:(UIButton *)btn{
    MB_LoginViewController *loginVC = [[MB_LoginViewController alloc] initWithSuccessBlock:^(NSString *codeStr) {
        NSLog(@"ssss%@",codeStr);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFHttpTool shareTool] loginWithCodeString:codeStr success:^(id response) {
            NSLog(@"%@",response);
            MB_User *user = [[MB_User alloc] init];
            [user setValuesForKeysWithDictionary:response];
        } failure:^(NSError *err) {
            
        }];
    }];
        
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
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
        _skipBtn.titleLabel.textColor = [UIColor redColor];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
