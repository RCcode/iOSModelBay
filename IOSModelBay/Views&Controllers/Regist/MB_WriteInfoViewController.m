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

@interface MB_WriteInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation MB_WriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];
    
    if (_roleType == RoleTypeProfessional) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    }
    
    _maleBtn.selected = YES;
    
    if (_roleType == RoleTypeAudience) {
        _maleBtn.hidden = YES;
        _femaleBtn.hidden = YES;
    }
}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"请输入用户名");
    }else{
        //验证用户名
        NSDictionary *params = @{@"uid":[userDefaults objectForKey:kUid],
                                 @"name":_usernameTF.text};
        [[AFHttpTool shareTool] checkNameWithParameters:params success:^(id response) {
            NSLog(@"check username %@",response);
            if ([response[@"stat"] integerValue] == 10201) {
                //用户名已经存在
            }else{
                if (_roleType == RoleTypeProfessional) {
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
                                             @"ikey":@"ccccc",
                                             @"akey":@"",
                                             @"userName":[userDefaults objectForKey:kUsername],
                                             @"fullName":[userDefaults objectForKey:kFullname],
                                             @"token":[userDefaults objectForKey:kAccessToken],
                                             @"utype":@(1),
                                             @"name":@"lisong",
                                             @"gender":@"",
                                             @"careerId":@"",
                                             @"pic":[userDefaults objectForKey:kPic]};
                    [[AFHttpTool shareTool] registWithParameters:params success:^(id response) {
                        NSLog(@"regist %@",response);
                        if ([response[@"stat"] integerValue] == 10000) {
                            MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
                            [self presentViewController:tabVC animated:YES completion:nil];
                        }
                    } failure:^(NSError *err) {
                        
                    }];
                }
            }
        } failure:^(NSError *err) {
            
        }];
    }
}

@end
