//
//  MB_EditSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/6.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_EditSummaryViewController.h"
#import "MB_EditTableViewCell.h"
#import "MB_EditColorTableViewCell.h"

static NSString * const ReuseIdentifierOther = @"ReuseIdentifierOther";
static NSString * const ReuseIdentifierColor = @"ReuseIdentifierColor";

@interface MB_EditSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_EditSummaryViewController

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.optionIndex - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    
    NSArray *array = [[MB_Utils shareUtil].optionsDic objectForKey:@(_index)];
    self.dataArray = [array copy];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0 || self.index == 1 || self.index == 2) {
        MB_EditColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierColor forIndexPath:indexPath];
        cell.colorImageView.layer.cornerRadius = CGRectGetWidth(cell.colorImageView.frame) / 2;
        cell.colorImageView.layer.masksToBounds = YES;
        cell.colorImageView.backgroundColor = [UIColor redColor];
        
        NSString *colorString = self.dataArray[indexPath.row + 1];
        cell.nameLabel.text = colorString;
    
        if (indexPath.row + 1 == self.optionIndex) {
            cell.selectImageView.hidden = NO;
        }else {
            cell.selectImageView.hidden = YES;
        }
        
        if ([colorString isEqualToString:LocalizedString(@"Black", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#000000");
        }
        if ([colorString isEqualToString:LocalizedString(@"Blue", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#2f4ed6");
        }
        if ([colorString isEqualToString:LocalizedString(@"Brown", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#9a630b");
        }
        if ([colorString isEqualToString:LocalizedString(@"Green", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#39a14d");
        }
        if ([colorString isEqualToString:LocalizedString(@"Hazel", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#8f0d00");
        }
        if ([colorString isEqualToString:LocalizedString(@"White", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#ffffff");
            cell.colorImageView.layer.borderWidth = 1;
            cell.colorImageView.layer.borderColor = colorWithHexString(@"#a2a2a2").CGColor;
        }
        if ([colorString isEqualToString:LocalizedString(@"Olive", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#518b19");
        }
        if ([colorString isEqualToString:LocalizedString(@"Tanned", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#751208");
        }
        if ([colorString isEqualToString:LocalizedString(@"Blonde", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#f7e83e");
        }
        if ([colorString isEqualToString:LocalizedString(@"Grey", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#9e9e9e");
        }
        if ([colorString isEqualToString:LocalizedString(@"Red", nil)]) {
            cell.colorImageView.backgroundColor = colorWithHexString(@"#ff3a26");
        }
        
        if ([colorString isEqualToString:LocalizedString(@"Other", nil)]) {
            cell.colorImageView.hidden = YES;
        }else {
            cell.colorImageView.hidden = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        MB_EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierOther forIndexPath:indexPath];
        cell.nameLabel.text = self.dataArray[indexPath.row + 1];
        
        if (indexPath.row + 1 == self.optionIndex) {
            cell.selectedImageView.hidden = NO;
        }else {
            cell.selectedImageView.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _optionIndex = indexPath.row + 1;
    [self.tableView reloadData];
    self.blcok(self.index, self.optionIndex);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 12, kWindowWidth - 24, kWindowHeight - 12) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        _tableView.sectionHeaderHeight = 10.5;
//        _tableView.sectionFooterHeight = 0;
        
//        _tableView.layoutMargins = UIEdgeInsetsZero;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UIView *view = [[UIView alloc] init];
        [_tableView setTableFooterView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_EditTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierOther];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_EditColorTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierColor];
    }
    return _tableView;
}

@end
