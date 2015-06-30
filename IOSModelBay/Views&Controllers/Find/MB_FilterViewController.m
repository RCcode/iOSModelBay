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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonOnClick:)];
    
    if (self.type == FilterTypeFind) {
        [self.view addSubview:self.searchView];
    }
    
    [self.view addSubview:self.sexView];
    [self.view addSubview:self.collectView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_FilterCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ins%ld",indexPath.row + 1]];
    if (self.type == FilterTypeFind) {
        if ([[MB_Utils shareUtil].fCareerId isEqualToString:@""] && indexPath.row == 0) {
            //默认选中All
            cell.selected = YES;
        }else if ([[MB_Utils shareUtil].fCareerId integerValue] == indexPath.row) {
            //上次选中的
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    }else {
        if ([[MB_Utils shareUtil].rCareerId isEqualToString:@""] && indexPath.row == 0) {
            //默认选中All
            cell.selected = YES;
        }else if ([[MB_Utils shareUtil].rCareerId integerValue] == indexPath.row) {
            //上次选中的
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == FilterTypeFind) {
        if (indexPath.row == 0) {
            [MB_Utils shareUtil].fCareerId = @"";
        }else {
            [MB_Utils shareUtil].fCareerId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
    }else {
        if (indexPath.row == 0) {
            [MB_Utils shareUtil].rCareerId = @"";
        }else {
            [MB_Utils shareUtil].rCareerId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
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
    if (self.type == FilterTypeFind) {
        [MB_Utils shareUtil].fGender = btn.tag - 1;
    }else {
        [MB_Utils shareUtil].rGender = btn.tag - 1;
    }
}

- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
    self.CompleteHandler();
}


#pragma mark - getters & setters
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 49)];
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
        if (self.type == FilterTypeFind) {
            _sexView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kWindowWidth, 61)];
        }else {
            _sexView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 61)];
        }
        _sexView.backgroundColor = [UIColor whiteColor];
        
        UIImage *image = [UIImage imageNamed:@"ic_cz"];
        CGFloat btnWidth = kWindowWidth/3;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnWidth * i, 0, btnWidth, 61);
            button.tag = i;
            button.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 10);
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:@"lojsongge" forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateSelected];
            [button setTitleColor:colorWithHexString(@"#8e8e8e") forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"#ff4f42") forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sexBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sexView addSubview:button];
            
            if (self.type == FilterTypeFind) {
                if ([MB_Utils shareUtil].fGender == (i - 1)) {
                    button.selected = YES;
                }
            }else {
                if ([MB_Utils shareUtil].rGender == (i - 1)) {
                    button.selected = YES;
                }
            }
        }
    }
    return _sexView;
}

- (UICollectionView *)collectView {
    
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat space = 2;
        CGFloat itemWidth = (kWindowWidth - 3 * space) / 2;
        CGFloat itemHeight = itemWidth * 128 / 314;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sexView.frame), kWindowWidth, kWindowHeight - 49 - CGRectGetMaxY(self.sexView.frame)) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_FilterCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

@end
