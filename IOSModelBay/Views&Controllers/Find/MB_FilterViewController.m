//
//  MB_FilterViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_FilterViewController.h"
#import "MB_FilterCollectViewCell.h"
#import "MB_SearchViewController.h"

@interface MB_FilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) NSMutableArray *sexBtnArray;
@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation MB_FilterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.sexView];
    [self.view addSubview:self.collectView];
    
//    [self sexBtnOnClick:self.sexBtnArray[0]];
//    if ([MB_Utils shareUtil].gender == 0) {
//        [self sexBtnOnClick:self.sexBtnArray[1]];
//    }
//    if ([MB_Utils shareUtil].gender == 0) {
//        [self sexBtnOnClick:self.sexBtnArray[2]];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_FilterCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    if ([[MB_Utils shareUtil].careerId isEqualToString:@""] && indexPath.row == 0) {
        //默认选中All
        cell.selected = YES;
    }else if ([[MB_Utils shareUtil].careerId integerValue] == indexPath.row) {
        //上次选中的
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [MB_Utils shareUtil].careerId = @"";
    }else {
        [MB_Utils shareUtil].careerId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    [collectionView reloadData];
}


#pragma mark - private methods
//点击性别选择按钮
- (void)handleTap:(UITapGestureRecognizer *)tap {
    MB_SearchViewController *searchVC = [[MB_SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)sexBtnOnClick:(UIButton *)btn {
    for (UIButton *btn in self.sexView.subviews) {
        btn.selected = NO;
    }
    
    btn.selected = YES;
    [MB_Utils shareUtil].gender = btn.tag - 1;
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
    self.CompleteHandler();
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 50)];
        _searchView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_searchView addGestureRecognizer:tap];
        
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
            button.tag = i;
            [button setTitle:@"songge" forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateSelected];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sexBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sexView addSubview:button];
            
            //默认选中第一个
            if ([MB_Utils shareUtil].gender == (i - 1)) {
                button.selected = YES;
            }
        }
    }
    return _sexView;
}

- (UICollectionView *)collectView {
    
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake((kWindowWidth - 2.5) / 2, 50);
        layout.minimumLineSpacing = 2.5;
        layout.minimumInteritemSpacing = 2.5;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sexView.frame), kWindowWidth, kWindowHeight - 49 - CGRectGetMaxY(self.sexView.frame)) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_FilterCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
