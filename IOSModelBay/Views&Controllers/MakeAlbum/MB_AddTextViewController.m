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
#import "MB_SelectUserViewController.h"

@import AssetsLibrary;

@interface MB_AddTextViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *addDescTextView;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (nonatomic, assign) NSInteger mId;//模特id
@property (nonatomic, assign) NSInteger pId;//摄影师id
@property (nonatomic, assign) NSInteger hId;//发型师id
@property (nonatomic, assign) NSInteger mkId;//化妆师id

@property (nonatomic, strong) NSString *mName;//模特名
@property (nonatomic, strong) NSString *pName;//摄影师名
@property (nonatomic, strong) NSString *hName;//发型师名
@property (nonatomic, strong) NSString *mkName;//化妆师名

@property (weak, nonatomic) IBOutlet UIView *imagesContainerView;
@property (nonatomic, strong) ALAssetsLibrary *assertLibrary;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSMutableDictionary *progressDic;

@end

@implementation MB_AddTextViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    self.titleLabel.text = LocalizedString(@"Add description", nil);
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    self.mId = -1;
    self.pId = -1;
    self.hId = -1;
    self.mkId = -1;
    self.mName = @"";
    self.pName = @"";
    self.hName = @"";
    self.mkName = @"";
    
    self.addTitleTextField.placeholder = LocalizedString(@"Title", nil);
    self.addDescTextView.text = LocalizedString(@"Description", nil);
    
    [self.button1 setTitle:LocalizedString(@"Model", nil) forState:UIControlStateNormal];
    [self.button2 setTitle:LocalizedString(@"Photographer", nil) forState:UIControlStateNormal];
    [self.button3 setTitle:LocalizedString(@"Makeup Artist", nil) forState:UIControlStateNormal];
    [self.button4 setTitle:LocalizedString(@"Hair Stylist", nil) forState:UIControlStateNormal];
    

    self.assertLibrary = [[ALAssetsLibrary alloc] init];
    [self refreshImagesContainerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:LocalizedString(@"Description", nil)]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = LocalizedString(@"Description", nil);
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = LocalizedString(@"Description", nil);
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }else {
//        return YES;
//    }
//}


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
            if (self.urlArray.count == 9) {
                imageView.hidden = YES;
            }else {
                imageView.image = [UIImage imageNamed:@"add_img"];
            }
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
    if (sender.selected) {
        sender.selected = NO;
        self.mId = -1;
        self.mName = @"";
    }else {
        MB_SelectUserViewController *selectVC = [[MB_SelectUserViewController alloc] init];
        selectVC.selectBlock = ^(MB_Collect *user){
            NSString *title = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Model", nil),user.fname];
            [sender setTitle:title forState:UIControlStateSelected];
            sender.selected = YES;
            self.mId = user.fid;
            self.mName = user.fname;
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

- (IBAction)photographerButtonOnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        self.pId = -1;
        self.pName = @"";
    }else {
        MB_SelectUserViewController *selectVC = [[MB_SelectUserViewController alloc] init];
        selectVC.selectBlock = ^(MB_Collect *user){
            NSString *title = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Photographer", nil),user.fname];
            [sender setTitle:title forState:UIControlStateSelected];
            sender.selected = YES;
            self.pId = user.fid;
            self.pName = user.fname;
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

- (IBAction)hairstylistButtonOnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        self.hId = -1;
        self.hName = @"";
    }else {
        MB_SelectUserViewController *selectVC = [[MB_SelectUserViewController alloc] init];
        selectVC.selectBlock = ^(MB_Collect *user){
            NSString *title = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Makeup Artist", nil),user.fname];
            [sender setTitle:title forState:UIControlStateSelected];
            sender.selected = YES;
            self.hId = user.fid;
            self.hName = user.fname;
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

- (IBAction)dresserButtonOnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        self.mkId = -1;
        self.mkName = @"";
    }else {
        MB_SelectUserViewController *selectVC = [[MB_SelectUserViewController alloc] init];
        selectVC.selectBlock = ^(MB_Collect *user){
            NSString *title = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Hair Stylist", nil),user.fname];
            [sender setTitle:title forState:UIControlStateSelected];
            sender.selected = YES;
            self.mkId = user.fid;
            self.mkName = user.fname;
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    //显示进度
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabelText = LocalizedString(@"Uploading", nil);
    hud.detailsLabelFont = [UIFont systemFontOfSize:17.0];
    hud.mode = MBProgressHUDModeDeterminate;
    
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],//用户id
                             @"token":[userDefaults objectForKey:kAccessToken],//token
                             @"atype":@(1),//影集分类:0.拼图;1.相片集
                             @"name":self.addTitleTextField.text,//影集名称
                             @"descr":self.addDescTextView.text,//影集描述
                             @"cover":@"",//封面图片,当atype为0时为内容
                             @"mId":@(self.mId),//模特id
                             @"mName":self.mName,//模特名
                             @"pId":@(self.pId),//摄影师id
                             @"pName":self.pName,//摄影师名
                             @"hId":@(self.hId),//发型师id
                             @"hName":self.hName,//发型师名
                             @"mkId":@(self.mkId),//化妆师id
                             @"mkName":self.mkName//化妆师名
                             };
    [[AFHttpTool shareTool] addAblumWithParameters:params success:^(id response) {
        NSLog(@"%@",response);
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
                    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://model.rcplatformhk.net/ModelBayWeb/",@"ablum/uploadPic.do"];
                    
                    AFHTTPRequestOperation *operation = [_manager POST:url parameters:uploadParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                        [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%ld.jpg",(unsigned long)[self.urlArray indexOfObject:url]] mimeType:@"image/jpeg"];
                        
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (_manager.operationQueue.operationCount == 0) {
                            
                            hud.detailsLabelText = LocalizedString(@"Uplaod Success", nil);
                            [hud hide:YES afterDelay:0.7];
                        }
                        NSLog(@"success");
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@ failed", operation);
                        
                        if (_manager.operationQueue.operationCount == 0) {
                            
                            hud.detailsLabelText = LocalizedString(@"Upload Failure", nil);
                            [hud hide:YES afterDelay:0.7];
                        }
                    }];
                    
                    __weak NSMutableDictionary *dic = self.progressDic;
                    __weak NSNumber *index = [uploadParams objectForKey:@"sort"];
                    __weak NSMutableArray *allArray = self.urlArray;
                    __weak MBProgressHUD *weakHub = hud;
                    [dic setObject:@(0) forKey:index];
                    
                    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        
                        double progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
                        NSLog(@"pro  %f",progress);
                        [dic setObject:@(progress) forKey:index];
                        
                        NSArray *array = [dic allValues];
                        
                        double sum = 0;
                        for (NSNumber *num in array) {
                            sum += [num doubleValue];
                        }
                        NSLog(@"progressDic = %@",dic);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakHub.progress = sum / allArray.count;
                        });
                        
                    }];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }else {
            hud.detailsLabelText = LocalizedString(@"Upload Failure", nil);
            [hud hide:YES afterDelay:0.7];
            
            [self deleteAblumWithAblId:[response[@"ablId"] integerValue]];
        }
    } failure:^(NSError *err) {
        hud.detailsLabelText = LocalizedString(@"Upload Failure", nil);
        [hud hide:YES afterDelay:0.7];
    }];
}

//删除影集
- (void)deleteAblumWithAblId:(NSInteger)ablId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"adlId":@(ablId)};
    
    [[AFHttpTool shareTool] deleteAblumWithParameters:params success:^(id response) {
        NSLog(@"delete ablum: %@",response);
        if ([self statFromResponse:response] == 10000) {
            
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if (tap.view.tag == self.urlArray.count) {
        //添加图片
        if (self.urlArray.count >= 9) {
            return;
        }
        MB_SelectPhotosViewController *selectVC = [[MB_SelectPhotosViewController alloc] init];
        selectVC.type = SelectTypeOne;
        selectVC.block = ^(NSURL *url) {
            [self.urlArray addObject:url];
            [self refreshImagesContainerView];
        };
        
        [self.navigationController pushViewController:selectVC animated:YES];
    }else{
        //预览删除
        if (self.urlArray.count <= 3) {
            return;
        }
        
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
- (NSDictionary *)progressDic {
    if (!_progressDic) {
        _progressDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _progressDic;
}

@end
