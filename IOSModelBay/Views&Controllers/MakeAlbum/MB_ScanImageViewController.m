//
//  MB_ScanImageViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/6.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_ScanImageViewController.h"

@interface MB_ScanImageViewController ()

@end

@implementation MB_ScanImageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.index,(long)self.count];
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64)];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//删除这张图片
- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    self.block(self.index);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
