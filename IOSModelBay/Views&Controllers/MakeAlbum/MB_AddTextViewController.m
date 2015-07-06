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
#import "MB_SelectPhotosViewController.h"
#import "MB_ScanImageViewController.h"

@import AssetsLibrary;

@interface MB_AddTextViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTitleTextField;

//@property (weak, nonatomic) IBOutlet UITextField *addDescTextField;

@property (weak, nonatomic) IBOutlet UITextView *addDescTextView;

@property (weak, nonatomic) IBOutlet UIView *imagesContainerView;

@property (nonatomic, strong) ALAssetsLibrary *assertLibrary;

@end

@implementation MB_AddTextViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"ADD TEXT";
    self.navigationItem.titleView = self.titleLabel;
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonOnClick:)];
    
    self.assertLibrary = [[ALAssetsLibrary alloc] init];
    [self refreshImagesContainerView];
//    //展示选择的图片
//    NSInteger countEveryLine = 5;
//    CGFloat imageWidth = (kWindowWidth - 6) / countEveryLine;
//    for (int i = 0; i <= self.urlArray.count; i ++) {
//        NSInteger row = i / countEveryLine;//所在行
//        NSInteger col = i % countEveryLine;//所在列
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col *(1 + imageWidth) + 1, row * (imageWidth + 1) + 1, imageWidth, imageWidth)];
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [imageView addGestureRecognizer:tap];
//        if (i == self.urlArray.count) {
//            imageView.image = [UIImage imageNamed:@"add_img"];
//        }else {
//            [self.assertLibrary assetForURL:self.urlArray[i] resultBlock:^(ALAsset *asset) {
////                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
////                UIImage *resultImage =[image setMaxResolution:480.0f imageOri:image.imageOrientation];
//                imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
//            } failureBlock:^(NSError *error) {
//                
//            }];
//        }
//        [self. imagesContainerView addSubview:imageView];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"ADD"]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"ADD";
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else {
        return YES;
    }
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//重新排列图片
- (void)refreshImagesContainerView {
    [self.imagesContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //展示选择的图片
    NSInteger countEveryLine = 5;
    CGFloat imageWidth = (kWindowWidth - 6) / countEveryLine;
    for (int i = 0; i <= self.urlArray.count; i ++) {
        NSInteger row = i / countEveryLine;//所在行
        NSInteger col = i % countEveryLine;//所在列
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col *(1 + imageWidth) + 1, row * (imageWidth + 1) + 1, imageWidth, imageWidth)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        if (i == self.urlArray.count) {
            imageView.image = [UIImage imageNamed:@"add_img"];
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
                             @"descr":self.addDescTextView.text,//影集描述
                             @"cover":@"",//封面图片,当atype为0时为内容
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
        MB_SelectPhotosViewController *selectVC = [[MB_SelectPhotosViewController alloc] init];
        [self.navigationController pushViewController:selectVC animated:YES];
    }else{
        //预览删除
        MB_ScanImageViewController *scanVC = [[MB_ScanImageViewController alloc] init];
        [self.assertLibrary assetForURL:self.urlArray[tap.view.tag] resultBlock:^(ALAsset *asset) {
            scanVC.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        } failureBlock:^(NSError *error) {
            
        }];
        scanVC.index = tap.view.tag + 1;
        scanVC.count = self.urlArray.count;
        scanVC.block = ^(NSInteger index){
            [self.urlArray removeObjectAtIndex:index - 1];
            [self refreshImagesContainerView];
        };
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}

#pragma mark - getters & setters

@end
