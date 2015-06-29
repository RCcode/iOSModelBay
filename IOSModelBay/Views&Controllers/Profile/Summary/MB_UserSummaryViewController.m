//
//  MB_UserSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserSummaryViewController.h"
#import "MB_SummaryTableViewCell.h"
#import "MB_UserDetail.h"

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) MB_UserDetail *detail;

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self requestUserDetail];
    
    if (self.comeFromType == ComeFromTypeUser) {
        self.dataArray = [@[@"介绍",@"性别",@"国家",@"年龄",@"联系方式",@"电话",@"电子邮件",@"网站"] mutableCopy];
        if ([self.user.fcareerId containsString:@"1"]) {
            self.dataArray = [@[@"介绍",@"性别",@"国家",@"年龄",@"经验",@"联系方式",@"电话",@"电子邮件",@"网站"] mutableCopy];
        }else {
            self.dataArray = [@[@"介绍",@"性别",@"国家",@"年龄",@"专注领域",@"经验",@"联系方式",@"电话",@"电子邮件",@"网站"] mutableCopy];
        }
    }else if (self.comeFromType == ComeFromTypeSelf) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.dataArray.count - 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.mainLabelWidth.constant = 0;
        cell.mainLabel.text = @"";
        cell.subLabel.text = @"穿不不不不不不不不不不不不不不不不不不嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻卡斯是是是是是是是是是是";
    }else {
        cell.mainLabelWidth.constant = 100;
        cell.mainLabel.text = self.dataArray[indexPath.row + 1];
//        cell.subLabel.text = [self.detailDic objectForKey:self.dataArray[indexPath.row + 1]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


#pragma mark - privtate methods
- (void)requestUserDetail {
    NSDictionary *params = @{@"id":@(6),
                             @"token":@"abcde",
                             @"fid":@(6)};
    [[AFHttpTool shareTool] getUerDetailWithParameters:params success:^(id response) {
        NSLog(@"detail %@",response);
        self.detail = [[MB_UserDetail alloc] init];
        self.detailDic = response;
//        [self.detail setValuesForKeysWithDictionary:response];
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
