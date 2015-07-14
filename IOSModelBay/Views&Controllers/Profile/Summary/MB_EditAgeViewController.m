//
//  MB_EditAgeViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/14.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_EditAgeViewController.h"

@interface MB_EditAgeViewController ()

@end

@implementation MB_EditAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:picker];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
