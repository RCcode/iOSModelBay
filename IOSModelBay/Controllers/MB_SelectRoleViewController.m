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

@end

@implementation MB_SelectRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)professionalBtnOnClick:(UIButton *)sender{
    //专业用户
    MB_WriteInfoViewController *writeVC = [[MB_WriteInfoViewController alloc] init];
    [self.navigationController pushViewController:writeVC animated:YES];
}

- (IBAction)audinceBtnOnClick:(UIButton *)sender {
    //观众
    
}


@end
