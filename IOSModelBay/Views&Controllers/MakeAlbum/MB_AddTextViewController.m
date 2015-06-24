//
//  MB_AddTextViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AddTextViewController.h"
#import "UIImage+Utility.h"
#import "MB_LikersViewController.h"
@import AssetsLibrary;

@interface MB_AddTextViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *addDescTextField;

@property (weak, nonatomic) IBOutlet UIView *imagesContainerView;

@property (nonatomic, strong) ALAssetsLibrary *assertLibrary;

@end

@implementation MB_AddTextViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonOnClick:)];
    
    self.assertLibrary = [[ALAssetsLibrary alloc] init];
    //展示选择的图片
    NSInteger countEveryLine = 5;
    CGFloat imageWidth = (kWindowWidth - 10) / countEveryLine;
    for (int i = 0; i <= self.urlArray.count; i ++) {
        NSInteger row = i / countEveryLine;//所在行
        NSInteger col = i % countEveryLine;//所在列
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col *(2.5 + imageWidth), row * (imageWidth + 2.5), imageWidth, imageWidth)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        if (i == self.urlArray.count) {
            imageView.image = [UIImage imageNamed:@"a"];
        }else {
            [self.assertLibrary assetForURL:self.urlArray[i] resultBlock:^(ALAsset *asset) {
//                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
//                UIImage *resultImage =[image setMaxResolution:480.0f imageOri:image.imageOrientation];
                imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
            } failureBlock:^(NSError *error) {
                
            }];
        }
        [self. imagesContainerView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  NO;
}


#pragma mark - private methods
- (IBAction)modelButtonOnClick:(UIButton *)sender {
    MB_LikersViewController *likers = [[MB_LikersViewController alloc] init];
    [self.navigationController pushViewController:likers animated:YES];
}

- (IBAction)photographerButtonOnClick:(UIButton *)sender {
    
}

- (IBAction)hairstylistButtonOnClick:(UIButton *)sender {
    
}

- (IBAction)dresserButtonOnClick:(UIButton *)sender {
    
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    NSDictionary *params = @{@"id":@(6),//用户id
                             @"token":@"abcde",//token
                             @"atype":@(1),//影集分类:0.拼图;1.相片集
                             @"name":self.addTitleTextField.text,//影集名称
                             @"descr":self.addDescTextField.text,//影集描述
                             @"cover":[[self.urlArray firstObject] absoluteString],//封面图片,当atype为0时为内容
                             @"mId":@"",//模特id
                             @"mName":@"",//模特名
                             @"pId":@"",//摄影师id
                             @"pName":@"",//摄影师名
                             @"hId":@"",//发型师id
                             @"hName":@"",//发型师名
                             @"mkId":@"",//化妆师id
                             @"mkName":@""//化妆师名
                             };
    [[AFHttpTool shareTool] addAblumWithParameters:params success:^(id response) {
        
    } failure:^(NSError *err) {
        
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == self.urlArray.count) {
        //添加图片
        
    }else{
        
    }
}

#pragma mark - getters & setters

@end
