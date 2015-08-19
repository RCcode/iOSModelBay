//
//  MB_UserSummaryViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserSummaryViewController.h"
#import "MB_IntroduceTableViewCell.h"
#import "MB_SummaryTableViewCell.h"
#import "MB_EditSummaryViewController.h"
#import "MB_EditWriteViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_EditAreaViewController.h"

static NSString * const ReuseIdentifierIntroduce = @"introduce";
static NSString * const ReuseIdentifierSummary = @"summary";

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *detailDic;//用于记录修改值

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    self.titleLabel.text = LocalizedString(@"Edit", nil).uppercaseString;
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonOnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightBarButtonOnClick:)];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.dataArray.count;
    }else {
        return self.areaArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierIntroduce cacheByIndexPath:indexPath configuration:^(MB_IntroduceTableViewCell *cell) {
            [self configureCell2:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.section == 1) {
        return 43;
    }else {
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierSummary cacheByIndexPath:indexPath configuration:^(MB_SummaryTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}

- (void)configureCell2:(MB_IntroduceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([self.changeDetail.bio isEqualToString:@""]) {
        cell.label.text = LocalizedString(@"introduce", nil);
    }else {
        cell.label.text = self.changeDetail.bio;
    }
}

- (void)configureCell:(MB_SummaryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.areaArray[indexPath.row];
    cell.mainLabel.text = LocalizedString(title, nil);
    cell.mainLabelWidth.constant = 120;
    
    if ([title isEqualToString:@"areaModel"]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (NSString * string in self.changeDetail.arrayModel) {
            NSString *str = [NSString stringWithFormat:@"#%@",LocalizedString([[MB_Utils shareUtil].areaModel objectAtIndex:[string integerValue]], nil)];
            [array addObject: str];
        }
        cell.subLabel.text = [array componentsJoinedByString:@"  "];
    }else {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (NSString * string in self.changeDetail.arrayPhoto) {
        NSString *str = [NSString stringWithFormat:@"#%@",LocalizedString([[MB_Utils shareUtil].areaPhoto objectAtIndex:[string integerValue] - 100], nil)];
        [array addObject: str];
        }
        cell.subLabel.text = [array componentsJoinedByString:@"  "];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MB_IntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierIntroduce forIndexPath:indexPath];
        
        [self configureCell2:cell atIndexPath:indexPath];
        
        return cell;
        
    }else if (indexPath.section == 1){
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        cell.mainLabelWidth.constant = 80;
        NSString *keyName = self.dataArray[indexPath.row];
        cell.mainLabel.text = LocalizedString(keyName, nil);
        NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:keyName];
        cell.subLabel.text = [self getStringWithIndex:index detail:self.changeDetail];
        return cell;
    }else {
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 0:
        {
            //修改描述
            MB_EditWriteViewController *editVC = [[MB_EditWriteViewController alloc] init];
            editVC.text = self.changeDetail.bio;
            editVC.blcok = ^(NSInteger index, NSString *text,BOOL hide){
                self.changeDetail.bio = text;
                [self.detailDic setObject:text forKey:@"bio"];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:editVC animated:YES];
            break;
        }
            
        case 1:
        {
            NSString *title = self.dataArray[indexPath.row];
            NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:title];
            NSLog(@"index =  %ld",(long)index);
            
            switch (index) {
                case 15://age
                {
                    MB_EditWriteViewController *editVC = [[MB_EditWriteViewController alloc] init];
                    editVC.text = [NSString stringWithFormat:@"%ld",(long)self.changeDetail.age];
                    editVC.index = 15;
                    editVC.hide = self.changeDetail.btype;
                    editVC.blcok = ^(NSInteger index, NSString *text,BOOL hide){
                        self.changeDetail.age = [text integerValue];
                        self.changeDetail.btype = !hide;
                        [self.detailDic setObject:@([text integerValue]) forKey:@"birth"];
                        [self.detailDic setObject:hide?@(0):@(1) forKey:@"btype"];
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:editVC animated:YES];
                    break;
                }

                case 16://Contracts
                {
                    MB_EditWriteViewController *editVC = [[MB_EditWriteViewController alloc] init];
                    editVC.text = self.changeDetail.contact;
                    editVC.index = 16;
                    editVC.hide = self.changeDetail.ctype;
                    editVC.blcok = ^(NSInteger index, NSString *text,BOOL hide){
                        self.changeDetail.contact = text;
                        self.changeDetail.ctype = !hide;
                        [self.detailDic setObject:text forKey:@"contact"];
                        [self.detailDic setObject:hide?@(0):@(1) forKey:@"ctype"];
                        [self.tableView reloadData];
                };
                    [self.navigationController pushViewController:editVC animated:YES];
                    break;
                }

                case 17://Email
                {
                    MB_EditWriteViewController *editVC = [[MB_EditWriteViewController alloc] init];
                    editVC.text = self.changeDetail.email;
                    editVC.index = 17;
                    editVC.hide = self.changeDetail.etype;
                    editVC.blcok = ^(NSInteger index, NSString *text,BOOL hide){
                        self.changeDetail.email = text;
                        self.changeDetail.etype = !hide;
                        [self.detailDic setObject:text forKey:@"email"];
                        [self.detailDic setObject:hide?@(0):@(1) forKey:@"etype"];
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:editVC animated:YES];
                    break;
                }

                case 18://Website
                {
                    MB_EditWriteViewController *editVC = [[MB_EditWriteViewController alloc] init];
                    editVC.text = self.changeDetail.website;
                    editVC.index = 18;
                    editVC.blcok = ^(NSInteger index, NSString *text,BOOL hide){
                        self.changeDetail.website = text;
                        [self.detailDic setObject:text forKey:@"website"];
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:editVC animated:YES];
                    break;
                }

                default:
                {
                    MB_EditSummaryViewController *editVC = [[MB_EditSummaryViewController alloc] init];
                    editVC.index = index;
                    
                    //计算默认值
                    NSString *keyName = self.dataArray[indexPath.row];
                    NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:keyName];
                    editVC.optionIndex = [self getOptionIndexWithIndex:index detail:self.changeDetail];
                    editVC.blcok = ^(NSInteger index, NSInteger optionIndex){
                        NSLog(@"%ld,,,%ld",(long)index,(long)optionIndex);
                        [self changeValue:optionIndex ForKey:index];
                    };
                    editVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:editVC animated:YES];
                    break;
                }
            }
            
            break;
        }
            
        case 2:
        {
            MB_EditAreaViewController *editVC = [[MB_EditAreaViewController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            
            NSString *title = self.areaArray[indexPath.row];
            if ([title isEqualToString:@"areaModel"]) {
                //修改专注领域(模特)
                editVC.name = EditNameAreaModel;
                editVC.selectArray = self.changeDetail.arrayModel;
                editVC.block = ^(NSMutableArray *array) {
                    self.changeDetail.arrayModel = array;
                    
                    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
                    [allArray addObjectsFromArray:self.changeDetail.arrayModel];
                    [allArray addObjectsFromArray:self.changeDetail.arrayPhoto];
                    [self.detailDic setObject:[allArray componentsJoinedByString:@"|"] forKey:@"fareas"];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                };
                
            }else if ([title isEqualToString:@"areaPhoto"]){
                //修改专注领域(摄影师)
                editVC.name = EditNameAreaPhoto;
                
                NSMutableArray *bArray = [NSMutableArray arrayWithCapacity:0];
                for (NSString *aString in self.changeDetail.arrayPhoto) {
                    [bArray addObject:[NSString stringWithFormat:@"%ld",[aString integerValue] - 100]];
                }
                editVC.selectArray = bArray;
                
                editVC.block = ^(NSMutableArray *array) {
                    NSMutableArray *aArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSString *aString in array) {
                        [aArray addObject:@([aString integerValue] + 100)];
                    }
                    self.changeDetail.arrayPhoto = aArray;
                    
                    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
                    [allArray addObjectsFromArray:self.changeDetail.arrayModel];
                    [allArray addObjectsFromArray:self.changeDetail.arrayPhoto];
                    [self.detailDic setObject:[allArray componentsJoinedByString:@"|"] forKey:@"fareas"];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                };
            }

            [self.navigationController pushViewController:editVC animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - privtate methods
- (void)leftBarButtonOnClick:(UIBarButtonItem *)barButton {
    if (self.detailDic.allKeys.count > 3) {
        self.saveSuccessBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonOnClick:(UIBarButtonItem *)barButton {
    //更新用户信息到服务器
    self.tableView.separatorColor = colorWithHexString(@"#eeeeee");
    [self.detailDic setObject:[userDefaults objectForKey:kID] forKey:@"id"];
    [self.detailDic setObject:[userDefaults objectForKey:kAccessToken] forKey:@"token"];
    [[AFHttpTool shareTool] updateUserDetailWithParameters:self.detailDic success:^(id response) {
        NSLog(@"update user detail %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.saveSuccessBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }else {

        }
    } failure:^(NSError *err) {
        
    }];
}

- (NSString *)getStringWithIndex:(NSInteger)index detail:(MB_UserDetail *)detail{
    switch (index) {
        case 0:
            return [MB_Utils shareUtil].eyeColor[[detail.eyecolor integerValue]];
            break;
        case 1:
            return [MB_Utils shareUtil].skincolor[[detail.skincolor integerValue]];
            break;
        case 2:
            return [MB_Utils shareUtil].haircolor[[detail.haircolor integerValue]];
            break;
        case 3:
            return [MB_Utils shareUtil].shoesize[[detail.shoesize integerValue]];
            break;
        case 4:
            return [MB_Utils shareUtil].dress[[detail.dress integerValue]];
        case 5:
            return [MB_Utils shareUtil].height[detail.height];
            break;
        case 6:
            return [MB_Utils shareUtil].weight[detail.weight];
            break;
        case 7:
            return [MB_Utils shareUtil].chest[detail.chest];
            break;
        case 8:
            return [MB_Utils shareUtil].waist[detail.waist];
            break;
        case 9:
            return [MB_Utils shareUtil].hips[detail.hips];
            break;
            
        case 12:
            return [MB_Utils shareUtil].experience[[detail.experience integerValue]];
            break;
        case 13:
            return [MB_Utils shareUtil].gender[detail.gender + 1];
            break;
        case 14:
            return [MB_Utils shareUtil].country[[detail.country integerValue]];
            break;
        case 15:
        {
            if (detail.age == -1) {
                return @"";
            }else {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:detail.age];
                NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
                [formattor setDateFormat:@"YYYY"];
                NSString *str1 = [formattor stringFromDate:date];
                NSString *str2 = [formattor stringFromDate:[NSDate date]];
                NSString *age = [NSString stringWithFormat:@"%ld",(long)([str2 integerValue] - [str1 integerValue])];
                return age;
            }
            break;
        }
        case 16:
            return detail.contact;
            break;
        case 17:
            return detail.email;
            break;
        case 18:
            return detail.website;
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)getOptionIndexWithIndex:(NSInteger)index detail:(MB_UserDetail *)detail{
    switch (index) {
        case 0:
            return [detail.eyecolor integerValue];
            break;
        case 1:
            return [detail.skincolor integerValue];
            break;
        case 2:
            return [detail.haircolor integerValue];
            break;
        case 3:
            return [detail.shoesize integerValue];
            break;
        case 4:
            return [detail.dress integerValue];
        case 5:
            return detail.height;
            break;
        case 6:
            return detail.weight;
            break;
        case 7:
            return detail.chest;
            break;
        case 8:
            return detail.waist;
            break;
        case 9:
            return detail.hips;
            break;
            
        case 12:
            return [detail.experience integerValue];
            break;
        case 13:
            return detail.gender + 1;
            break;
        case 14:
            return [detail.country integerValue];
            break;
        default:
            return 0;
            break;
    }
}

- (void)changeValue:(NSInteger)optionIndex ForKey:(NSInteger)index{
    switch (index) {
        case 0:
            self.changeDetail.eyecolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"eyecolor"];
            break;
        case 1:
            self.changeDetail.skincolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"skincolor"];
            break;
        case 2:
            self.changeDetail.haircolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"haircolor"];
            break;
        case 3:
            self.changeDetail.shoesize = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"shoesize"];
            break;
        case 4:
            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"dress"];
            break;
        case 5:
            self.changeDetail.height = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"height"];
            break;
        case 6:
            self.changeDetail.weight = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"weight"];
            break;
        case 7:
            self.changeDetail.chest = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"chest"];
            break;
        case 8:
            self.changeDetail.waist = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"waist"];
            break;
        case 9:
            self.changeDetail.hips = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"hips"];
            break;
        case 12:
            self.changeDetail.experience = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"experience"];
            break;
        case 13:
            self.changeDetail.gender = optionIndex - 1;
            [self.detailDic setObject:@(optionIndex - 1) forKey:@"gender"];
            break;
        case 14:
            self.changeDetail.country = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"country"];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.5, 0, kWindowWidth - 21, kWindowHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.sectionHeaderHeight = 10.5;
        _tableView.sectionFooterHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = colorWithHexString(@"#eeeeee");
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -10.5);

        [_tableView registerNib:[UINib nibWithNibName:@"MB_IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierIntroduce];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierSummary];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.5)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
    }
    return _tableView;
}

- (NSMutableDictionary *)detailDic {
    if (!_detailDic) {
        _detailDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self.detailDic setObject:@(-1) forKey:@"btype"];
        [self.detailDic setObject:@(-1) forKey:@"ctype"];
        [self.detailDic setObject:@(-1) forKey:@"etype"];
    }
    return _detailDic;
}

@end
