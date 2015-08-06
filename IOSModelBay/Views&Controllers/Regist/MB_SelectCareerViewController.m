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
#import "MB_MainViewController.h"

@interface MB_SelectCareerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation MB_SelectCareerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"Career", nil);
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemOnClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClick:)];
    
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
    cell.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"in%ld.jpg",(long)(indexPath.row + 1)]];
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectButton.selected = [self.selectedArray containsObject:self.dataArray[indexPath.row]];
    if ([self.selectedArray containsObject:self.dataArray[indexPath.row]]) {
        cell.coverView.backgroundColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.5];
        cell.careerLabel.textColor = [UIColor whiteColor];
    }
    else{
        cell.coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        cell.careerLabel.textColor = [UIColor blackColor];
    }
    cell.careerLabel.text = [[MB_Utils shareUtil].careerDic objectForKey:self.dataArray[indexPath.row]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_CareerCollectViewCell *cell = (MB_CareerCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self selectButtonOnClick:cell.selectButton];
}

#pragma mark - private methods
- (void)selectButtonOnClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [self.selectedArray removeObject:self.dataArray[button.tag]];
    }else{
        if (self.selectedArray.count >= 3) {
            [MB_Utils showAlertViewWithMessage:LocalizedString(@"max_select", nil)];
            return;
        }else{
            [self.selectedArray addObject:self.dataArray[button.tag]];
        }
    }
    [self.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]]];
}

- (void)leftBarButtonItemOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemOnClick:(UIBarButtonItem *)barButton {
    if (self.selectedArray.count < 1) {
        [MB_Utils showAlertViewWithMessage:LocalizedString(@"min_select", nil)];
    }else if (self.selectedArray.count > 3){
        [MB_Utils showAlertViewWithMessage:LocalizedString(@"max_select", nil)];
    }else{
        //注册
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *params = @{@"uid":[userDefaults objectForKey:kUid],
                                 @"tplat":@(0),
                                 @"plat":@(2),
                                 @"ikey":@"a",
                                 @"akey":@"",
                                 @"fullName":[userDefaults objectForKey:kFullname],
                                 @"token":[userDefaults objectForKey:kAccessToken],
                                 @"utype":@(1),
                                 @"name":self.username,
                                 @"gender":@(self.sexType),
                                 @"careerId":[self.selectedArray componentsJoinedByString:@"|"],
                                 @"pic":[userDefaults objectForKey:kPic]};
        [[AFHttpTool shareTool] registWithParameters:params success:^(id response) {
            NSLog(@"regist %@",response);
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            if ([response[@"stat"] integerValue] == 10000) {
                //记录用户信息
                [userDefaults setObject:response[@"id"] forKey:kID];//模特平台用户唯一标识
                [userDefaults setObject:@(self.sexType) forKey:kGender];//性别:0.女;1.男
                [userDefaults setObject:self.username forKey:kName];//本平台登录用户名
                [userDefaults setObject:[self.selectedArray componentsJoinedByString:@"|"] forKey:kCareer];//职业id,竖线分割:1|2|3
                [userDefaults setObject:@(1) forKey:kUtype];//用户类型: 0,浏览;1:专业;
                [userDefaults setObject:response[@"pic"] forKey:kPic];//用户类型: 0,浏览;1:专业;
                [userDefaults setObject:response[@"backPic"] forKey:kBackPic];//用户类型: 0,浏览;1:专业;
                
                [userDefaults setBool:YES forKey:kIsLogin];
                [userDefaults synchronize];

                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInNotification object:nil];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
//            else if ([response[@"stat"] integerValue] == 1) {
//                //已经注册
//            }
        } failure:^(NSError *err) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }];
    }
}


#pragma mark - getters & setters
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kWindowWidth - 6) / 2;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64) collectionViewLayout:layout];
        _collectView.backgroundColor = colorWithHexString(@"#eeeeee");
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
