//
//  MB_AddTextViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AddTextViewController.h"

@interface MB_AddTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *addDescTextField;

@property (weak, nonatomic) IBOutlet UIView *imagesContainerView;

@end

@implementation MB_AddTextViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //展示选择的图片
    NSInteger countEveryLine = 5;
    CGFloat imageWidth = (kWindowWidth - 10) / countEveryLine;
    for (int i = 0; i < 9; i ++) {
        NSInteger row = i / countEveryLine;//所在行
        NSInteger col = i % countEveryLine;//所在列
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col *(2.5 + imageWidth), row * (imageWidth + 2.5), imageWidth, imageWidth)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        if (i == 8) {
            imageView.image = [UIImage imageNamed:@"a"];
        }else {
            imageView.image = [UIImage imageNamed:@"b"];
        }
        [self. imagesContainerView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods
- (void)handleTap:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",(long)tap.view.tag);
}

#pragma mark - getters & setters

@end
