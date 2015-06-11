//
//  MB_UserSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserSummaryViewController.h"
#import "MB_SummaryTableViewCell.h"
#import <CoreText/CoreText.h>

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"%@",familyName);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for(NSString *fontName in fontNames){
            NSLog(@"\t|- %@",fontName);
        }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataArray.count;
    return 2;
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
    
//    cell.subLabel.font =     [UIFont systemFontOfSize:17.0 weight:UIFontDescriptorTraitBold];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods

#pragma mark - getters & setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view =[[UIView alloc] init];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

@end
