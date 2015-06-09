//
//  MB_FilterViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_FilterViewController.h"
#import "MB_FilterCollectViewCell.h"

@interface MB_FilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation MB_FilterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.sexView];
    [self.view addSubview:self.collectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_FilterCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
//    cell.usernameLabel.text = @"songge";
    return cell;
}


#pragma mark - private methods
//点击性别选择按钮
- (void)sexBtnOnClick:(UIButton *)btn {
    for (UIButton *btn in self.sexView.subviews) {
        btn.selected = NO;
    }
    
    btn.selected = YES;
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 50)];
        _searchView.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        imageView.image = [UIImage imageNamed:@"a"];
        [_searchView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 50)];
        label.text = @"songge";
        [_searchView addSubview:label];
    }
    return _searchView;
}

- (UIView *)sexView {
    if (_sexView == nil) {
        _sexView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, 50)];
        _sexView.backgroundColor = [UIColor yellowColor];
        
        UIImage *image = [UIImage imageNamed:@"b"];
        CGFloat btnWidth = kWindowWidth/3;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor grayColor];
            button.frame = CGRectMake(btnWidth * i, 0, btnWidth, 50);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [button setTitle:@"songge" forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateSelected];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sexBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sexView addSubview:button];
        }
    }
    return _sexView;
}

- (UICollectionView *)collectView {
    
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sexView.frame), kWindowWidth, kWindowHeight - 49 - CGRectGetMaxY(self.sexView.frame)) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_FilterCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
