//
//  MB_SelectRoleViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectRoleViewController.h"
#import "MB_WriteInfoViewController.h"

@interface MB_SelectRoleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelPro;
@property (weak, nonatomic) IBOutlet UIButton *buttonPro;
@property (weak, nonatomic) IBOutlet UILabel *labelAud;
@property (weak, nonatomic) IBOutlet UILabel *subLabelAud;
@property (weak, nonatomic) IBOutlet UIButton *buttonAud;
@property (weak, nonatomic) IBOutlet UIView *VIew1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation MB_SelectRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"select_role", nil);
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];

//    _buttonPro.layer.borderWidth = 1.5;
//    _buttonPro.layer.borderColor = [UIColor whiteColor].CGColor;
//    _buttonAud.layer.borderWidth = 1.5;
//    _buttonAud.layer.borderColor = [UIColor whiteColor].CGColor;
//    
//    _labelPro.text = @"i am a \nprofessional";
//    _labelAud.text = @"i am a \naudience";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [_VIew1 addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    [_view2 addGestureRecognizer:tap2];
    
}

- (void)tap1:(UITapGestureRecognizer *)tap {
    //专业用户
    MB_WriteInfoViewController *writeVC = [[MB_WriteInfoViewController alloc] init];
    writeVC.roleType = RoleTypeProfessional;
    [self.navigationController pushViewController:writeVC animated:YES];
}

- (void)tap2:(UITapGestureRecognizer *)tap {
    //观众
    MB_WriteInfoViewController *writeVC = [[MB_WriteInfoViewController alloc] init];
    writeVC.roleType = RoleTypeAudience;
    [self.navigationController pushViewController:writeVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)professionalBtnOnClick:(UIButton *)sender{
    //专业用户
    MB_WriteInfoViewController *writeVC = [[MB_WriteInfoViewController alloc] init];
    writeVC.roleType = RoleTypeProfessional;
    [self.navigationController pushViewController:writeVC animated:YES];
}

- (IBAction)audinceBtnOnClick:(UIButton *)sender {
    //观众
    MB_WriteInfoViewController *writeVC = [[MB_WriteInfoViewController alloc] init];
    writeVC.roleType = RoleTypeAudience;
    [self.navigationController pushViewController:writeVC animated:YES];
}


@end
