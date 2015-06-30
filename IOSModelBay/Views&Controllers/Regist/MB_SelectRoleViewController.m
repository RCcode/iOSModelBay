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


@end

@implementation MB_SelectRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];

    _buttonPro.layer.borderWidth = 1.5;
    _buttonPro.layer.borderColor = [UIColor whiteColor].CGColor;
    _buttonAud.layer.borderWidth = 1.5;
    _buttonAud.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _labelPro.text = @"i am a \nprofessional";
    _labelAud.text = @"i am a \naudience";
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
