//
//  MB_WriteInfoViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_WriteInfoViewController.h"
#import "MB_SelectCareerViewController.h"
#import "MB_TabBarViewController.h"
#import "MB_MainViewController.h"

@interface MB_WriteInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation MB_WriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Username", nil);
    self.navigationItem.titleView = self.titleLabel;
    self.welcomeLabel.text = LocalizedString(@"Welcome", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
    
    if (_roleType == RoleTypeProfessional) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
        _backImageView.image = [UIImage imageNamed:@"information_bg.jpg"];
        [_maleBtn setTitle:LocalizedString(@"Men", nil) forState:UIControlStateNormal];
        [_femaleBtn setTitle:LocalizedString(@"Women", nil) forState:UIControlStateNormal];
        _maleBtn.hidden = NO;
        _femaleBtn.hidden = NO;
        _maleBtn.selected = YES;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
        _backImageView.image = [UIImage imageNamed:@"information_bg2.jpg"];
        _maleBtn.hidden = YES;
        _femaleBtn.hidden = YES;
    }
    
    self.usernameTF.placeholder = LocalizedString(@"Username", nil);
    self.usernameTF.text = [userDefaults objectForKey:kUsername];
}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//点击男性
- (IBAction)maleBtnOnClick:(UIButton *)sender {
    _maleBtn.selected = YES;
    _femaleBtn.selected = NO;
}

//点击女性
- (IBAction)femaleBtnOnClick:(UIButton *)sender {
    _maleBtn.selected = NO;
    _femaleBtn.selected = YES;
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    if (_usernameTF.text == nil || [_usernameTF.text isEqualToString:@""]) {
        //请输入用户名
        [MB_Utils showAlertViewWithMessage:LocalizedString(@"Username_unavailable", nil)];
    }else{
        //验证用户名
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *params = @{@"name":_usernameTF.text};
        [[AFHttpTool shareTool] checkNameWithParameters:params success:^(id response) {
            NSLog(@"check username %@",response);
            if ([response[@"stat"] integerValue] == 10201) {
                //用户名已经存在
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [MB_Utils showAlertViewWithMessage:LocalizedString(@"Username_unavailable", nil)];
            }else if ([response[@"stat"] integerValue] == 10000){
                if (_roleType == RoleTypeProfessional) {
                    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    MB_SelectCareerViewController *careerVC = [[MB_SelectCareerViewController alloc] init];
                    careerVC.username = _usernameTF.text;
                    if (_maleBtn.selected) {
                        careerVC.sexType = SexTypeMale;
                    }else{
                        careerVC.sexType = SexTypeFemale;
                    }
                    [self.navigationController pushViewController:careerVC animated:YES];
                }else{
                    //注册
                    NSDictionary *params = @{@"uid":[userDefaults objectForKey:kUid],
                                             @"tplat":@(0),
                                             @"plat":@(2),
                                             @"ikey":@"a",
                                             @"akey":@"",
                                             @"fullName":[userDefaults objectForKey:kFullname],
                                             @"token":[userDefaults objectForKey:kAccessToken],
                                             @"utype":@(0),
                                             @"name":self.usernameTF.text,
                                             @"gender":@"",
                                             @"careerId":@"",
                                             @"pic":[userDefaults objectForKey:kPic]};
                    [[AFHttpTool shareTool] registWithParameters:params success:^(id response) {
                        NSLog(@"regist %@",response);
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                        if ([response[@"stat"] integerValue] == 10000) {
                            //记录用户信息
                            [userDefaults setObject:response[@"id"] forKey:kID];//模特平台用户唯一标识
                            [userDefaults setObject:@"" forKey:kGender];//性别:0.女;1.男
                            [userDefaults setObject:self.usernameTF.text forKey:kName];//本平台登录用户名
                            [userDefaults setObject:@"" forKey:kCareer];//职业id,竖线分割:1|2|3
                            [userDefaults setObject:@(0) forKey:kUtype];//用户类型: 0,浏览;1:专业;
                            [userDefaults setObject:response[@"pic"] forKey:kPic];//用户类型: 0,浏览;1:专业;
                            [userDefaults setObject:response[@"backPic"] forKey:kBackPic];//用户类型: 0,浏览;1:专业;
                            [userDefaults setBool:YES forKey:kIsLogin];
                            [userDefaults synchronize];
                            
//                            if ([self.presentingViewController isKindOfClass:[MB_MainViewController class]]) {
//                                NSLog(@"main");
//                                MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
//                                [self presentViewController:tabVC animated:YES completion:nil];
//                            }else {
//                                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInNotification object:nil];
                            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                    } failure:^(NSError *err) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    }];
                }
            }
        } failure:^(NSError *err) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }];
    }
}

@end
