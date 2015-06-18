//
//  MB_SelectPhotosViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectPhotosViewController.h"
#import "MB_CareerCollectViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MB_AddTextViewController.h"

@interface MB_SelectPhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) ALAssetsLibrary *assertLibrary;

@end

@implementation MB_SelectPhotosViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.menuButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    [self.view addSubview:self.collectView];
    [self getALlPhotosFromAlbum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_CareerCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    NSURL *url = self.dataArray[indexPath.row];
    [_assertLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        cell.backImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    } failureBlock:^(NSError *error) {
        
    }];
    cell.careerLabel.hidden = YES;
    return cell;
}


#pragma mark - private methods
- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    MB_AddTextViewController *addTextVC = [[MB_AddTextViewController alloc] init];
    [self.navigationController pushViewController:addTextVC animated:YES];
}

- (void)getALlPhotosFromAlbum {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _assertLibrary = [[ALAssetsLibrary alloc] init];
    [_assertLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"%@",group);
//            NSLog(@"Name == %@",[group valueForProperty:ALAssetsGroupPropertyName]);
//            NSLog(@"Type == %@",[group valueForProperty:ALAssetsGroupPropertyType]);
//            NSLog(@"URL == %@",[group valueForProperty:ALAssetsGroupPropertyURL]);
//            NSLog(@"PersistentID == %@",[group valueForProperty:ALAssetsGroupPropertyPersistentID]);
//            CGImageRef imageRef = [group posterImage];
//            NSInteger number = [group numberOfAssets];
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSLog(@"result  %@",result);
                    NSURL *urlstr=[result valueForProperty:ALAssetPropertyAssetURL];//图片的url
//                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                    [self.dataArray addObject:urlstr];
                }
            }];
            [self.collectView reloadData];
        }
        if (stop) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)menuButtonOnClick:(UIButton *)button {
    UIImagePickerController *imagePIcker = [[UIImagePickerController alloc] init];
    imagePIcker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

#pragma mark - getters & setters
- (UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, 100, 44);
        [_menuButton setTitle:@"all photos" forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        NSLog(@"-----%f",self.view.frame.size.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.alwaysBounceVertical = YES;
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_CareerCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
