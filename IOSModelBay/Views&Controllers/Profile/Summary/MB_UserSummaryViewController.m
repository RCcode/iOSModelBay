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
#import "MB_UserDetail.h"
#import "MB_EditSummaryViewController.h"
#import "MB_EditAgeViewController.h"

static NSString * const ReuseIdentifierIntroduce = @"introduce";
static NSString * const ReuseIdentifierSummary = @"summary";
//static NSString * const ReuseIdentifierIntroduce = @"introduce";

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *editView;

@property (nonatomic, strong) NSMutableDictionary *detailDic;//用于记录修改值
@property (nonatomic, strong) MB_UserDetail *detail;
@property (nonatomic, strong) MB_UserDetail *changeDetail;

@property (nonatomic, assign) BOOL editing;//标记是否是编辑状态

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    self.dataArray = [@[] mutableCopy];

    [self.view addSubview:self.tableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestUserDetail];
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
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 66;
    }else if (indexPath.section == 1) {
        return 43;
    }else {
        return 69;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MB_IntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierIntroduce forIndexPath:indexPath];
        
        if (self.editing) {
            cell.dashImageView.hidden = NO;
        }else{
            cell.dashImageView.hidden = YES;
        }
        cell.label.text = self.detail.bio;
        return cell;
        
    }else if (indexPath.section == 1){
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        if (self.editing) {
            //加虚线边框
            cell.dashLineImageView.hidden = NO;
            if (indexPath.row == self.dataArray.count - 1) {
                cell.dashLineImageView.image = [UIImage imageNamed:@"edit_sjieshao"];
            }else {
                cell.dashLineImageView.image = [UIImage imageNamed:@"edit_sjieshao_up"];
            }
        }else {
            //隐藏虚线边框
            cell.dashLineImageView.hidden = YES;
        }
        
//        cell.mainLabelWidth.constant = 60;
        
        NSString *keyName = self.dataArray[indexPath.row];
        cell.mainLabel.text = LocalizedString(keyName, nil);
        NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:keyName];
        cell.subLabel.text = [self getStringWithIndex:index + 1 detail:self.detail];
        return cell;
    }else {
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        
//        cell.mainLabelWidth.constant = 0;
        cell.mainLabel.text = @"fareas";
        cell.subLabel.text = @"#啊  #大的 #fffff ";
        
        if (self.editing) {
            cell.dashLineImageView.hidden = NO;
            cell.dashLineImageView.image = [UIImage imageNamed:@"edit_sjieshao"];
        }else {
            cell.dashLineImageView.hidden = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.editing) {
        switch (indexPath.section) {
            case 0:
            {
                //修改描述
                break;
            }
                
            case 1:
            {
                NSString *title = self.dataArray[indexPath.row];
                NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:title];
                NSLog(@"index =  %ld",(long)index);
                
                switch (index) {
                    case 1:
                        break;
                        
                    default:
                    {
                        MB_EditSummaryViewController *editVC = [[MB_EditSummaryViewController alloc] init];
                        editVC.index = index;
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
                //修改专注领域
                break;
            }
            default:
                break;
        }
    }
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
                [taleView setContentOffset:CGPointMake(0, topViewHeight - 64) animated:YES];
            }
        }else{
            //向下拉
            if (taleView.contentOffset.y == topViewHeight - 64) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}


#pragma mark - privtate methods
- (void)requestUserDetail {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.user.fid)};
    [[AFHttpTool shareTool] getUerDetailWithParameters:params success:^(id response) {
        NSLog(@"detail %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self statFromResponse:response] == 10000) {
            
            self.detail = [[MB_UserDetail alloc] init];
            [self.detail setValuesForKeysWithDictionary:response];
            [self.changeDetail setValuesForKeysWithDictionary:response];
            [self createMenuTitles];
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)createMenuTitles{
    
    if (self.comeFromType == ComeFromTypeUser) {
        if (self.detail.gender != -1) {
            [self.dataArray addObject:@"gender"];
        }
//        if (![self.detail.country isEqualToString:@""]) {
            [self.dataArray addObject:@"country"];
//        }
        if (self.detail.age != -1) {
            [self.dataArray addObject:@"age"];
        }
    }else {
        [self.dataArray addObject:@"gender"];
        [self.dataArray addObject:@"country"];
        [self.dataArray addObject:@"age"];
    }
    
    
    //模特，新面孔
    for (NSString *string in @[@"1", @"2"]) {
        if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:string]) {
            for (NSString *string in @[@"height", @"weight", @"chest", @"waist", @"hips", @"eyecolor", @"skincolor", @"haircolor", @"shoesize", @"dress", @"fareas", @"experience"]) {
                if (![self.dataArray containsObject:string]) {
                    [self.dataArray addObject:string];
                }
            }
            break;
        }
    }
    
    
    //演员，歌手，舞者
    for (NSString *string in @[@"2", @"3"]) {
        if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:string]) {
            for (NSString *string in @[@"height", @"weight", @"chest", @"waist", @"hips", @"eyecolor", @"skincolor", @"haircolor", @"experience"]) {
                if (![self.dataArray containsObject:string]) {
                    [self.dataArray addObject:string];
                }
            }
            break;
        }
    }
    
    //摄影师
    if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:@"4"]) {
        if (![self.dataArray containsObject:@"fareas"]) {
            [self.dataArray addObject:@"fareas"];
        }
    }
    
    //不是观众就加个experience
    if (self.user.uType != 0) {
        if (![self.dataArray containsObject:@"experience"]) {
            [self.dataArray addObject:@"experience"];
        }
    }
    
    //最后加这几种
    if (self.comeFromType == ComeFromTypeUser) {
        if (![self.detail.contact isEqualToString:@""]) {
            [self.dataArray addObject:@"contact"];
        }
        if (![self.detail.email isEqualToString:@""]) {
            [self.dataArray addObject:@"email"];
        }
        if (![self.detail.website isEqualToString:@""]) {
            [self.dataArray addObject:@"website"];
        }
    }else{
        [self.dataArray addObject:@"contact"];
        [self.dataArray addObject:@"email"];
        [self.dataArray addObject:@"website"];
    }
    
    NSLog(@"dataArray ==== %@",self.dataArray);
}

- (void)editButtonOnClick:(UIButton *)button {
    self.editing = !button.selected;
    [self.tableView reloadData];
    
    if (button.selected) {
        //更新用户信息到服务器
        self.tableView.separatorColor = colorWithHexString(@"#eeeeee");
        NSDictionary *params = @{@"id":@"",
                                 @"token":@""};
        [[AFHttpTool shareTool] updateUserDetailWithParameters:params success:^(id response) {
            NSLog(@"update user detail %@",response);
        } failure:^(NSError *err) {
            
        }];
    }else{
        self.tableView.separatorColor = [UIColor clearColor];
    }
    
    button.selected = !button.selected;
}

- (NSString *)getStringWithIndex:(NSInteger)index detail:(MB_UserDetail *)detail{
    switch (index) {
        case 1:
            return [MB_Utils shareUtil].eyeColor[[detail.eyecolor integerValue]];
            break;
        case 2:
            return [MB_Utils shareUtil].skincolor[[detail.skincolor integerValue]];
            break;
        case 3:
            return [MB_Utils shareUtil].haircolor[[detail.haircolor integerValue]];
            break;
        case 4:
            return [MB_Utils shareUtil].shoesize[[detail.shoesize integerValue]];
            break;
        case 5:
            return [MB_Utils shareUtil].dress[[detail.dress integerValue]];
        case 6:
            return [MB_Utils shareUtil].height[detail.height];
            break;
        case 7:
            return [MB_Utils shareUtil].weight[detail.weight];
            break;
        case 8:
            return [MB_Utils shareUtil].chest[detail.chest];
            break;
        case 9:
            return [MB_Utils shareUtil].waist[detail.waist];
            break;
        case 10:
            return [MB_Utils shareUtil].hips[detail.hips];
            break;
            //        case 11:
            //            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            //            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"fareasModel"];
            //            break;
            //        case 12:
            //            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            //            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"fareasPhoto"];
            //            break;
        
        default:
            return @"";
            break;
    }
}

- (void)changeValue:(NSInteger)optionIndex ForKey:(NSInteger)index{
    switch (index) {
        case 1:
            self.changeDetail.eyecolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"eyecolor"];
            break;
        case 2:
            self.changeDetail.skincolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"skincolor"];
            break;
        case 3:
            self.changeDetail.haircolor = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"haircolor"];
            break;
        case 4:
            self.changeDetail.shoesize = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"shoesize"];
            break;
        case 5:
            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"dress"];
            break;
        case 6:
            self.changeDetail.height = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"height"];
            break;
        case 7:
            self.changeDetail.weight = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"weight"];
            break;
        case 8:
            self.changeDetail.chest = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"chest"];
            break;
        case 9:
            self.changeDetail.waist = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"waist"];
            break;
        case 10:
            self.changeDetail.hips = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"hips"];
            break;
//        case 11:
//            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
//            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"fareasModel"];
//            break;
//        case 12:
//            self.changeDetail.dress = [NSString stringWithFormat:@"%ld",(long)optionIndex];
//            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"fareasPhoto"];
//            break;
        case 13:
            self.changeDetail.experience = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"experience"];
            break;
        case 14:
            self.changeDetail.gender = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"gender"];
            break;
        case 15:
            self.changeDetail.country = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"country"];
            break;
        case 16:
            self.changeDetail.age = optionIndex;
            [self.detailDic setObject:@(optionIndex) forKey:@"age"];
            break;
        case 17:
            self.changeDetail.contact = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"contact"];
            break;
        case 18:
            self.changeDetail.email = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"email"];
            break;
        case 19:
            self.changeDetail.website = [NSString stringWithFormat:@"%ld",(long)optionIndex];
            [self.detailDic setObject:[NSString stringWithFormat:@"%ld",(long)optionIndex] forKey:@"website"];
            break;
        default:
            break;
            
    }
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.5, 0, kWindowWidth - 21, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.sectionHeaderHeight = 10.5;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -10.5);
        _tableView.clipsToBounds = NO;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.5)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:self.editView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierIntroduce];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierSummary];
    }
    return _tableView;
}

- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 64)];
        _editView.backgroundColor = colorWithHexString(@"#eeeeee");
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, 10.5, _editView.frame.size.width, 43);
        button.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Medium" size:15];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [button setTitleColor:colorWithHexString(@"#222222") forState:UIControlStateNormal];
        [button setTitleColor:colorWithHexString(@"#ff4f42") forState:UIControlStateSelected];
        [button setTitle:@"EDIT" forState:UIControlStateNormal];
        [button setTitle:@"SAVE" forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
        [button setImage:[UIImage new] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(editButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:button];
    }
    return _editView;
}

- (NSMutableDictionary *)detailDic {
    if (!_detailDic) {
        _detailDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _detailDic;
}

@end
