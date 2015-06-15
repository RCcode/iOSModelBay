//
//  MB_UserSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserSummaryViewController.h"
#import "MB_SummaryTableViewCell.h"
#import "MB_UserViewController.h"
#import <CoreText/CoreText.h>

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canScrollNotification:) name:kCanScrollNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    }
    label.text = [NSString stringWithFormat:@"hello%ld",(long)section+1];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.mainLabel.text = @"介绍";
    cell.subLabel.text = @"拿到手都快考试的难度是女生的女生不得vsbdvsdvsdvsdvdsvsdvsdsfssjkjskasajsjdasdjkdsjfsdfjjdhfjsfdhs按时间等哈说不定你爸说的那是";
    
    
    if (indexPath.row == 2) {
        cell.subLabel.text = @"saasasnzcnczxcxzcxc";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
//    NSLog(@"dddddddddd%F",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y <= 0) {
//        NSLog(@"NNONONO");
//        scrollView.scrollEnabled = NO;
//    }
//}

#pragma mark - private methods
- (void)canScrollNotification:(NSNotification *)noti {
    NSLog(@"YES");
    self.tableView.scrollEnabled = YES;
}

#pragma mark - getters & setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
        
        UIView *view =[[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
