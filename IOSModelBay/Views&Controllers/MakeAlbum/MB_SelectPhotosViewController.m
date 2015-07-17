//
//  MB_SelectPhotosViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectPhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MB_AddTextViewController.h"
#import "MB_selectPhotosCollectViewCell.h"

@interface MB_SelectPhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton         *menuButton;
@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, strong) ALAssetsLibrary  *assertLibrary;

@end

@implementation MB_SelectPhotosViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.menuButton;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    
    if (self.type == SelectTypeAll) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_confirm"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_selectPhotosCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    NSURL *url = self.dataArray[indexPath.row];
    [_assertLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        cell.backImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    } failureBlock:^(NSError *error) {
        
    }];
    cell.selected = [collectionView.indexPathsForSelectedItems containsObject:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectTypeAll) {
        NSArray  *array = self.collectView.indexPathsForSelectedItems;
        
        if (array.count > 9) {
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        if (array.count < 3) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
    }else {
        NSIndexPath *indexPath = [self.collectView.indexPathsForSelectedItems firstObject];
        NSURL *url = self.dataArray[indexPath.row];
        self.block(url);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectTypeAll) {
        NSArray  *array = self.collectView.indexPathsForSelectedItems;
        
        if (array.count < 3) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
    }else {
        
    }
}

#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    
//    if (self.type == SelectTypeAll) {
        MB_AddTextViewController *addTextVC = [[MB_AddTextViewController alloc] init];
        NSMutableArray *selectedArray = [NSMutableArray arrayWithCapacity:0];
        for (NSIndexPath *indexPath in self.collectView.indexPathsForSelectedItems) {
            [selectedArray addObject:self.dataArray[indexPath.row]];
        }
        addTextVC.urlArray = selectedArray;
        [self.navigationController pushViewController:addTextVC animated:YES];
//    }else {
//        NSIndexPath *indexPath = [self.collectView.indexPathsForSelectedItems firstObject];
//        NSURL *url = self.dataArray[indexPath.row];
//        self.block(url);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)getALlPhotosFromAlbum {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _assertLibrary = [[ALAssetsLibrary alloc] init];
    [_assertLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSLog(@"result  %@",result);
                    NSURL *urlstr=[result valueForProperty:ALAssetPropertyAssetURL];//图片的url
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
//    UIImagePickerController *imagePIcker = [[UIImagePickerController alloc] init];
//    imagePIcker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}


#pragma mark - getters & setters
- (UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, 100, 44);
        [_menuButton setTitle:LocalizedString(@"ALL_photo", nil) forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat space = 1;
        CGFloat itemWidth = (kWindowWidth - 2 * space) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) collectionViewLayout:layout];
        _collectView.backgroundColor = colorWithHexString(@"#ffffff");
        _collectView.alwaysBounceVertical = YES;
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        _collectView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_collectView registerNib:[UINib nibWithNibName:@"MB_selectPhotosCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
        
        if (self.type == SelectTypeAll) {
            _collectView.allowsMultipleSelection = YES;
        }else {
            _collectView.allowsMultipleSelection = NO;
        }
    }
    return _collectView;
}

@end
