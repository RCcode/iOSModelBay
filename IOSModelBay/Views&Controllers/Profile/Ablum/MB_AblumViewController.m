//
//  MB_SampleReelsViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AblumViewController.h"
#import "MB_UserViewController.h"
#import "MB_AlbumTableViewCell.h"
#import "MB_SignalImageTableViewCell.h"
#import "MB_Ablum.h"
#import "MB_ScanAblumViewController.h"
#import "MB_AddAblumMenuView.h"
#import "MB_SelectPhotosViewController.h"
#import "MB_SelectTemplateViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString * const ReuseIdentifierAblum = @"ablummm";
static NSString * const ReuseIdentifierTemplate = @"template";

@interface MB_AblumViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) MB_AddAblumMenuView *menuView;


@end

@implementation MB_AblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.addView];
    [self.view addSubview:self.tableView];
    
    [self addPullRefresh];
    [self requestAblumListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row %2 == 0) {
//        NSLog(@"111111%f",[tableView fd_heightForCellWithIdentifier:ReuseIdentifierAblum cacheByIndexPath:indexPath configuration:^(MB_AlbumTableViewCell *cell) {
//            [self configureCell:cell atIndexPath:indexPath];
//        }]);
//
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierAblum cacheByIndexPath:indexPath configuration:^(MB_AlbumTableViewCell *cell) {
        }];
//    }else {
//        NSLog(@"22222%f",[tableView fd_heightForCellWithIdentifier:ReuseIdentifierTemplate cacheByIndexPath:indexPath configuration:^(MB_SignalImageTableViewCell *cell) {
//            [self configureCell2:cell atIndexPath:indexPath];
//        }]);
//        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierTemplate cacheByIndexPath:indexPath configuration:^(MB_SignalImageTableViewCell *cell) {
//            [self configureCell2:cell atIndexPath:indexPath];
//        }];
//        return 0;
//    }
//    return 300;
}

- (void)configureCell:(MB_AlbumTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.ablum = [[MB_Ablum alloc] init];
    cell.label1.text = @"sfhhhhhhhhhhhhhhhhhhccdsksjd说的话就会受到疾病发生的爆发你的身份决定是否独守空房多少分阶段师傅的说法vkvsjvnncxnvxnmvnxcvxcvnmxcnvmncxvncnvmcxnvmxcnvmnxcnv     \n  xcnvxnvcxv";
    cell.label2.text = @"";
    cell.con2.constant = 0;
    cell.label3.text = @"";
    cell.con3.constant = 0;
}

- (void)configureCell2:(MB_SignalImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    cell.label1.text = @"sfhhhhhhhhhhhhhhhhhhccdsksjd说的话就会受到疾病发生的爆发你的身份决定是否独守空房多少分阶段师傅的说法vkvsjvnncxnvxnmvnxcvxcvnmxcnvmncxvncnvmcxnvmxcnvmnxcnv     \n  xcnvxnvcxv";
//    cell.label2.text = _text;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 2 == 0) {
        MB_AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierAblum forIndexPath:indexPath];
//        cell.ablum = self.dataArray[indexPath.row];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
//    }else {
//        MB_SignalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierTemplate forIndexPath:indexPath];
////        cell.ablum = self.dataArray[indexPath.row];
//        [self configureCell2:cell atIndexPath:indexPath];
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MB_ScanAblumViewController *scanVC = [[MB_ScanAblumViewController alloc] init];
//    scanVC.ablum = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:scanVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
static CGFloat startY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    UITableView *taleView = userVC.tableView;
    if (scrollView.dragging) {
        if (scrollView.contentOffset.y - startY > 0) {
            //向上拉
            if (taleView.contentOffset.y == -64) {
                [taleView setContentOffset:CGPointMake(0, topViewHeight - 20) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == topViewHeight - 20) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}


#pragma mark - private methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_AblumViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestAblumListWithMinId:0];
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf requestAblumListWithMinId:weakSelf.minId];
    }];
}

//请求影集列表
- (void)requestAblumListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"fid":@(6),
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getAblumWithParameters:params success:^(id response) {
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Ablum *ablum = [[MB_Ablum alloc] init];
                [ablum setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:ablum];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
}

//添加作品集
- (void)addButtonOnClick:(UIButton *)button{
    //使菜单出现
    self.menuView.isShowing = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.hidden = 0;
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight - rect.size.height, kWindowWidth, rect.size.height);
    }];
}

- (void)handleCoverViewTap:(UITapGestureRecognizer *)tap {
    //使菜单消失
    self.menuView.isShowing = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.hidden = 1;
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.menuView removeFromSuperview];
    }];
}

//添加相册
- (void)albumButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.hidden = YES;
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectPhotosViewController *vc = [[MB_SelectPhotosViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//添加模板
- (void)templateButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.hidden = YES;
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectTemplateViewController *vc = [[MB_SelectTemplateViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getters & setters
//上部的制作相册按钮
- (UIView *)addView {
    if (_addView == nil) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
        _addView.backgroundColor = colorWithHexString(@"#eeeeee");
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(21.0 / 2, 21.0 / 2, kWindowWidth - 21, 43);
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addView addSubview:button];
    }
    return _addView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addView.frame), kWindowWidth, CGRectGetHeight(self.containerViewRect) - CGRectGetMaxY(self.addView.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");

        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 10.5;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_AlbumTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ReuseIdentifierAblum];
//        [_tableView registerNib:[UINib nibWithNibName:@"MB_SignalImageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierTemplate];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//黑色半透明背景
-(UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _coverView.backgroundColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.3];
        _coverView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCoverViewTap:)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

//制作相册和模板的选项菜单
- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MB_AddAblumMenuView" owner:nil options:nil] firstObject];
        _menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 139);
        [_menuView.albumButton addTarget:self action:@selector(albumButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView.templateButton addTarget:self action:@selector(templateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuView;
}

@end
