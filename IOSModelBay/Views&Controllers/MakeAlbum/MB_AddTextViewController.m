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

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

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
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],//用户id
                             @"token":[userDefaults objectForKey:kAccessToken],//token
                             @"atype":@(1),//影集分类:0.拼图;1.相片集
                             @"name":self.addTitleTextField.text,//影集名称
                             @"descr":self.addDescTextView.text,//影集描述
                             @"cover":@"",//封面图片,当atype为0时为内容
                             @"mId":@(-1),//模特id
                             @"mName":@"",//模特名
                             @"pId":@(-1),//摄影师id
                             @"pName":@"",//摄影师名
                             @"hId":@(-1),//发型师id
                             @"hName":@"",//发型师名
                             @"mkId":@(-1),//化妆师id
                             @"mkName":@""//化妆师名
                             };
    [[AFHttpTool shareTool] addAblumWithParameters:params success:^(id response) {
        NSLog(@"%@",response);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([self statFromResponse:response] == 10000) {
            //上传图片
            _manager = [AFHTTPRequestOperationManager manager];            
            for (NSURL *url in self.urlArray) {
                [self.assertLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                    
                    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
                    NSDictionary *uploadParams = @{@"id":[userDefaults objectForKey:kID],
                                                   @"token":[userDefaults objectForKey:kAccessToken],
                                                   @"ablId":response[@"ablId"],
                                                   @"sort":@([self.urlArray indexOfObject:url])};
                    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://192.168.0.89:8082/ModelBayWeb/",@"ablum/uploadPic.do"];
                    AFHTTPRequestOperation *operation = [_manager POST:url parameters:uploadParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                        [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%ld.jpg",(unsigned long)[self.urlArray indexOfObject:url]] mimeType:@"image/jpeg"];
                        
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"success");
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@ failed", operation);
                        [MB_Utils showPromptWithText:[NSString stringWithFormat:@"第%lu张失败",(unsigned long)[self.urlArray indexOfObject:url]]];
                    }];
                    
                    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
                    }];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MB_Utils showPromptWithText:@"失败"];
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == self.urlArray.count) {
        //添加图片
        MB_SelectPhotosViewController *selectVC = [[MB_SelectPhotosViewController alloc] init];
        selectVC.type = SelectTypeOne;
        selectVC.block = ^(NSURL *url) {
            NSLog(@"add url %@",url);
            [self.urlArray addObject:url];
            [self refreshImagesContainerView];
        };
        
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
