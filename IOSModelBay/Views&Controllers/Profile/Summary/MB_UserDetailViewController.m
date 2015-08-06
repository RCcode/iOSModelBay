//
//  MB_UserDetailViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/22.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserDetailViewController.h"
#import "MB_IntroduceTableViewCell.h"
#import "MB_SummaryTableViewCell.h"
#import "MB_UserDetail.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_UserSummaryViewController.h"

static NSString * const ReuseIdentifierIntroduce = @"introduce";
static NSString * const ReuseIdentifierSummary = @"summary";

@interface MB_UserDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *editView;

@property (nonatomic, strong) NSMutableArray *areaArray;//专注领域(包括模特或者摄影师或者没有)

@property (nonatomic, strong) MB_UserDetail *detail;
@property (nonatomic, strong) MB_UserDetail *changeDetail;

@end

@implementation MB_UserDetailViewController

#pragma mark - life cycle
- (void)dealloc {
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestUserDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detail == nil) {
        //请求完成之前什么都不显示
        self.editView.hidden = YES;
        return 0;
    }else {
        self.editView.hidden = NO;
        return 3;
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    cell.sanjiaoImageView.hidden = YES;
    cell.mainLabelWidth.constant = 120;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        cell.sanjiaoImageView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
   
    if (indexPath.section == 1) {
        NSString *title = self.dataArray[indexPath.row];
        NSInteger index = [[MB_Utils shareUtil].mapArray indexOfObject:title];
        if (index == 18) {
            //点击网站打开链接
            if (![self.detail.website isEqualToString:@""]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detail.website]];
            }
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
            if (taleView.contentOffset.y == topViewHeight - 64 && scrollView.contentOffset.y < 0) {
                [taleView setContentOffset:CGPointMake(0, -64) animated:YES];
            }
        }
    }
}


#pragma mark - privtate methods
//添加上下拉刷新
- (void)addPullRefresh
{
    __weak MB_UserDetailViewController *weakSelf = self;
    
    [self addHeaderRefreshForView:self.tableView WithActionHandler:^{
        NSLog(@"header");
        [weakSelf requestUserDetail];
    }];
}

- (void)requestUserDetail {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.user.fid)};
    [[AFHttpTool shareTool] getUerDetailWithParameters:params success:^(id response) {
        NSLog(@"detail %@",response);
        [self endRefreshingForView:self.tableView];
        if ([self statFromResponse:response] == 10000) {
            
            self.detail = [[MB_UserDetail alloc] init];
            self.detail.arrayModel = [[NSMutableArray alloc] initWithCapacity:0];
            self.detail.arrayPhoto = [[NSMutableArray alloc] initWithCapacity:0];
            self.changeDetail = [[MB_UserDetail alloc] init];
            self.changeDetail.arrayModel = [NSMutableArray arrayWithCapacity:0];
            self.changeDetail.arrayPhoto = [NSMutableArray arrayWithCapacity:0];
            [self.detail setValuesForKeysWithDictionary:response];
            [self.changeDetail setValuesForKeysWithDictionary:response];
            
            for (NSString *string in [self.detail.fareas componentsSeparatedByString:@"|"]) {
                if ([string isEqualToString:@""]) {
                    continue;
                }
                if ([string integerValue] < 100) {
                    [self.detail.arrayModel addObject:string];
                    [self.changeDetail.arrayModel addObject:string];
                }else {
                    [self.detail.arrayPhoto addObject:string];
                    [self.changeDetail.arrayPhoto addObject:string];
                }
            }
            
            //instagram的信息
            if ([self.detail.website isEqualToString:@""] || [self.detail.bio isEqualToString:@""]) {
                //请求Instagram的代替
                [[AFHttpTool shareTool] instagramUserInfoWithUid:self.user.uid success:^(id response) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"instagram user = %@",response);
                    if ([self.detail.bio isEqualToString:@""]) {
                        self.detail.bio = response[@"data"][@"bio"];
                        self.changeDetail.bio = response[@"data"][@"bio"];
                    }
                    if ([self.detail.website isEqualToString:@""]) {
                        self.detail.website = response[@"data"][@"website"];
                        self.changeDetail.website = response[@"data"][@"website"];
                    }
                    
                    [self createMenuTitles];
                    [self.tableView reloadData];
                    
                } failure:^(NSError *err) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"%@",err);
                    [self createMenuTitles];
                    [self.tableView reloadData];
                }];
            }else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self createMenuTitles];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

- (void)createMenuTitles{
    [self.dataArray removeAllObjects];
    [self.areaArray removeAllObjects];
    
    [self.dataArray addObject:@"Gender"];
    [self.dataArray addObject:@"Country"];
    
    if (self.comeFromType == ComeFromTypeUser) {
        if (self.detail.btype == 0) {
            [self.dataArray addObject:@"Age"];
        }
    }else {
        [self.dataArray addObject:@"Age"];
    }
    
    //模特，新面孔
    for (NSString *string in @[@"1", @"2"]) {
        if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:string]) {
            for (NSString *string in @[@"Height", @"Weight", @"Chest", @"Waist", @"Hips", @"Eye Color", @"Skin Color", @"Hair Color", @"Shoes", @"Dress", @"Experiences"]) {
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
            for (NSString *string in @[@"Height", @"Weight", @"Chest", @"Waist", @"Hips", @"Eye Color", @"Skin Color", @"Hair Color", @"Experiences"]) {
                if (![self.dataArray containsObject:string]) {
                    [self.dataArray addObject:string];
                }
            }
            break;
        }
    }
    
    
    //不是观众就加个experience
    if (self.user.uType != 0) {
        if (![self.dataArray containsObject:@"Experiences"]) {
            [self.dataArray addObject:@"Experiences"];
        }
    }
    
    //最后加这几种
    if (self.comeFromType == ComeFromTypeUser) {
        if (self.detail.ctype == 0) {
            [self.dataArray addObject:@"Contracts"];
        }
        if (self.detail.etype == 0) {
            [self.dataArray addObject:@"Email"];
        }
    }else{
        [self.dataArray addObject:@"Contracts"];
        [self.dataArray addObject:@"Email"];
    }
    
    [self.dataArray addObject:@"Website"];
    
    for (NSString *string in @[@"1", @"13"]) {
        if ([[self.detail.careerId componentsSeparatedByString:@"|"] containsObject:string]) {
            //模特
            [self.areaArray addObject:@"areaModel"];
            break;
        }
    }
    
    if ([[self.detail.careerId componentsSeparatedByString:@"|"] containsObject:@"5"]) {
        [self.areaArray addObject:@"areaPhoto"];
    }
}

- (void)editButtonOnClick:(UIButton *)button {
    [MobClick event:@"Others" label:@"other_unfavor"];
    
    MB_UserSummaryViewController *summaryVC = [[MB_UserSummaryViewController alloc] init];
    summaryVC.user = self.user;
    summaryVC.dataArray = self.dataArray;
    summaryVC.areaArray = self.areaArray;
    summaryVC.detail = self.detail;
    summaryVC.changeDetail = self.changeDetail;
    summaryVC.hidesBottomBarWhenPushed = YES;
    summaryVC.saveSuccessBlock = ^(){
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:summaryVC animated:YES];
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
//            if ([detail.website isEqualToString:@""]) {
//                return [userDefaults objectForKey:kWebsite];
//            }else{
                return detail.website;
//            }
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.5, 0, kWindowWidth - 21, CGRectGetHeight(self.containerViewRect)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.sectionHeaderHeight = 10.5;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = colorWithHexString(@"#eeeeee");
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -10.5);
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierIntroduce];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SummaryTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierSummary];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.5)];
        [_tableView setTableFooterView:view];
        
        //如果是自己，可以显示编辑按钮
        MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
        if (userVC.comeFromType == ComeFromTypeSelf) {
            [_tableView setTableHeaderView:self.editView];
        }else {
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.5)];
        }
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
        [button setTitle:LocalizedString(@"Edit_detail", nil).uppercaseString forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:button];
    }
    return _editView;
}

- (NSMutableArray *)areaArray {
    if (!_areaArray) {
        _areaArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _areaArray;
}

@end
