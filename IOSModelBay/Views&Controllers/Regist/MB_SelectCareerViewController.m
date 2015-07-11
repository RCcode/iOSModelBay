//
//  MB_SelectCareerViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SelectCareerViewController.h"
#import "MB_CareerCollectViewCell.h"
#import "MB_TabBarViewController.h"

@interface MB_SelectCareerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation MB_SelectCareerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemOnClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemOnClick:)];
    
    [self.view addSubview:self.collectView];
    
    //所有职业ID
    NSArray *array = [[MB_Utils shareUtil].careerDic allKeys];
    //按照ID升序排序
    self.dataArray = [[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *a = obj1;
        NSString *b = obj2;
        return [a compare:b options:NSNumericSearch];
    }] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_CareerCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"in%ld",indexPath.row + 1]];
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectButton.selected = [self.selectedArray containsObject:self.dataArray[indexPath.row]];
    if ([self.selectedArray containsObject:self.dataArray[indexPath.row]]) {
        cell.coverView.backgroundColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.5];
    }
    else{
        cell.coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    cell.careerLabel.text = [[MB_Utils shareUtil].careerDic objectForKey:self.dataArray[indexPath.row]];
    return cell;
}


#pragma mark - private methods
- (void)selectButtonOnClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [self.selectedArray removeObject:self.dataArray[button.tag]];
    }else{
        if (self.selectedArray.count >= 3) {
            [MB_Utils showAlertViewWithMessage:@"最多三个最少一个"];
            return;
        }else{
            [self.selectedArray addObject:self.dataArray[button.tag]];
        }
    }
    [self.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]]];
//    [self.collectView reloadData];
}

- (void)leftBarButtonItemOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemOnClick:(UIBarButtonItem *)barButton {
    if (self.selectedArray.count < 1 || self.selectedArray.count > 3) {
        [MB_Utils showAlertViewWithMessage:@"最多三个最少一个"];
    }else{
        //注册
        NSDictionary *params = @{@"uid":[userDefaults objectForKey:kUid],
                                 @"tplat":@(0),
                                 @"plat":@(2),
                                 @"ikey":@"a",
                                 @"fullName":[userDefaults objectForKey:kFullname],
                                 @"token":[userDefaults objectForKey:kAccessToken],
                                 @"utype":@(1),
                                 @"name":self.username,
                                 @"gender":@(self.sexType),
                                 @"careerId":[self.selectedArray componentsJoinedByString:@"|"],
                                 @"pic":[userDefaults objectForKey:kPic]};
        [[AFHttpTool shareTool] registWithParameters:params success:^(id response) {
            NSLog(@"regist %@",response);
            if ([response[@"stat"] integerValue] == 10000) {
                MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
                [self presentViewController:tabVC animated:YES completion:nil];
            }
        } failure:^(NSError *err) {
            
        }];
    }
}


#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kWindowWidth - 2.5) / 2;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumInteritemSpacing = 2.5;
        layout.minimumLineSpacing = 2.5;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64) collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor redColor];
        _collectView.delegate        = self;
        _collectView.dataSource      = self;
        [_collectView registerNib:[UINib nibWithNibName:@"MB_CareerCollectViewCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectView;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

@end
