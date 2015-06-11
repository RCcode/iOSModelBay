//
//  MB_WriteInfoViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_WriteInfoViewController.h"
#import "MB_SelectCareerViewController.h"

@interface MB_WriteInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation MB_WriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    _maleBtn.selected = YES;
    
    if (_roleType == RoleTypeAudience) {
        _maleBtn.hidden = YES;
        _femaleBtn.hidden = YES;
    }
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
        NSDictionary *params = @{@"id":[userDefaults objectForKey:kUid],
                                 @"name":_usernameTF.text};
        [[AFHttpTool shareTool] checkNameWithParameters:params success:^(id response) {
            NSLog(@"check username %@",response);
            if ([response[@"stat"] integerValue] == 10201) {
                //用户名已经存在
            }else{
                MB_SelectCareerViewController *careerVC = [[MB_SelectCareerViewController alloc] init];
                careerVC.username = _usernameTF.text;
                if (_maleBtn.selected) {
                    careerVC.sexType = SexTypeMale;
                }else{
                    careerVC.sexType = SexTypeFemale;
                }
                [self.navigationController pushViewController:careerVC animated:YES];
            }
        } failure:^(NSError *err) {
            
        }];
    }
}

@end
