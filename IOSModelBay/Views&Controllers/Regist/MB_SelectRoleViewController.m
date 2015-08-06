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

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIView *VIew1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation MB_SelectRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"select_role", nil);
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];

    if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hans"] || [[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hant"]) {
        self.imageView1.image = [UIImage imageNamed:@"select_zhuanye_cn.jpg"];
        self.imageView2.image = [UIImage imageNamed:@"select_putong_cn.jpg"];
    }
    
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

@end
