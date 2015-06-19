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

static NSString * const ReuseIdentifierAblum = @"ablum";
static NSString * const ReuseIdentifierTemplate = @"template";

@interface MB_AblumViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MB_AblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    [self requestAblumList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        MB_AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierAblum forIndexPath:indexPath];
        return cell;
    }else {
        MB_SignalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierTemplate forIndexPath:indexPath];
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
        [weakSelf endFooterRefreshingForView:weakSelf.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefreshingForView:weakSelf.tableView];
        });
    }];
    
    [self addFooterRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"footer");
        [weakSelf endHeaderRefreshingForView:weakSelf.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefreshingForView:weakSelf.tableView];
            [weakSelf showNoMoreMessageForview:weakSelf.tableView];
        });
    }];
}

- (void)requestAblumList {
    
}

#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MB_AlbumTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierAblum];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SignalImageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierTemplate];
    }
    return _tableView;
}

@end
