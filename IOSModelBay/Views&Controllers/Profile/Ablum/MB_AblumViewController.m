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

static NSString * const ReuseIdentifierAblum = @"ablum";
static NSString * const ReuseIdentifierTemplate = @"template";

@interface MB_AblumViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;
@property (nonatomic, strong) MB_AddAblumMenuView *menuView;


@end

@implementation MB_AblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.addView];
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    [self requestAblumListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        MB_AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierAblum forIndexPath:indexPath];
        cell.ablum = self.dataArray[indexPath.row];
        return cell;
    }else {
        MB_SignalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierTemplate forIndexPath:indexPath];
        cell.ablum = self.dataArray[indexPath.row];
        return cell;
    }
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
                [taleView setContentOffset:CGPointMake(0, 250) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == 250) {
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
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    if (self.menuView.isShowing) {
        self.menuView.isShowing = NO;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.menuView.frame;
            self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
        }];
    }else {
        self.menuView.isShowing = YES;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.menuView.frame;
            self.menuView.frame = CGRectMake(0, kWindowHeight - rect.size.height, kWindowWidth, rect.size.height);
        }];
    }
}

//添加相册
- (void)albumButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectPhotosViewController *vc = [[MB_SelectPhotosViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//添加模板
- (void)templateButtonOnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.menuView.frame;
        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
    }];
    MB_SelectTemplateViewController *vc = [[MB_SelectTemplateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getters & setters
- (UIView *)addView {
    if (_addView == nil) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
        _addView.backgroundColor = [UIColor grayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _addView.bounds;
        [button setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addView addSubview:button];
    }
    return _addView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addView.frame), kWindowWidth, CGRectGetHeight(self.containerViewRect) - CGRectGetMaxY(self.addView.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MB_AlbumTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierAblum];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SignalImageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierTemplate];
    }
    return _tableView;
}

- (UIView *)menuView {
    if (_menuView == nil) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MB_AddAblumMenuView" owner:nil options:nil] firstObject];
        _menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 150);
        _menuView.backgroundColor = [UIColor grayColor];
        _menuView.isShowing = YES;
        [_menuView.albumButton addTarget:self action:@selector(albumButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView.templateButton addTarget:self action:@selector(templateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuView;
}

@end
