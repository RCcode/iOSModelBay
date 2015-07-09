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

static NSString * const ReuseIdentifierIntroduce = @"introduce";
static NSString * const ReuseIdentifierSummary = @"summary";
//static NSString * const ReuseIdentifierIntroduce = @"introduce";

@interface MB_UserSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) MB_UserDetail *detail;

@property (nonatomic, assign) BOOL editing;//标记是否是编辑状态

@end

@implementation MB_UserSummaryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");

    [self.view addSubview:self.tableView];
    [self requestUserDetail];
    
//    if (self.comeFromType == ComeFromTypeUser) {
//        
//    }else if (self.comeFromType == ComeFromTypeSelf) {
//        
//    }
    
//    @property (nonatomic, strong) NSString *bio;//描述
//    @property (nonatomic, strong) NSString *gender;//性别:0.女;1.男;-1隐藏
//    @property (nonatomic, strong) NSString *country;//国家
//    @property (nonatomic, strong) NSString *age;//年龄:-1隐藏
//    @property (nonatomic, strong) NSString *contact;//联系方式,null为隐藏
//    @property (nonatomic, strong) NSString *email;//邮箱, null为隐藏
//    @property (nonatomic, strong) NSString *website;//网站, null为隐藏
//    @property (nonatomic, strong) NSString *experience;//经验
//    @property (nonatomic, strong) NSString *height;//身高cm
//    @property (nonatomic, strong) NSString *weight;//体重kg
//    @property (nonatomic, strong) NSString *chest;//胸围cm
//    @property (nonatomic, strong) NSString *waist;//腰围cm
//    @property (nonatomic, strong) NSString *hips;//臀围cm
//    @property (nonatomic, strong) NSString *eyecolor;//眼睛颜色
//    @property (nonatomic, strong) NSString *skincolor;//皮肤颜色
//    @property (nonatomic, strong) NSString *haircolor;//头发颜色
//    @property (nonatomic, strong) NSString *shoesize;//鞋号
//    @property (nonatomic, strong) NSString *dress;//衣号
    
    
    self.dataArray = [@[] mutableCopy];
    
    if (self.detail.gender != -1) {
        [self.dataArray addObject:@"性别"];
    }
    
    [self.dataArray addObject:@"国家"];
    
    if (self.detail.age != -1) {
        [self.dataArray addObject:@"年龄"];
    }
    
    
    //模特，新面孔
    for (NSString *string in @[@"1", @"2"]) {
        if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:string]) {
            for (NSString *string in @[@"身高", @"体重", @"胸围", @"腰围", @"臀围", @"眼睛颜色", @"皮肤颜色", @"头发颜色", @"鞋号", @"衣号", @"专注领域", @"经验"]) {
                if (![self.dataArray containsObject:string]) {
                    [self.dataArray addObject:string];
                }
            }
            break;
        }
    }
    
    
    //演员，歌手，舞者
    for (NSString *string in @[@"1", @"2", @"3"]) {
        if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:string]) {
            for (NSString *string in @[@"身高", @"体重", @"胸围", @"腰围", @"臀围", @"眼睛颜色", @"皮肤颜色", @"头发颜色", @"经验"]) {
                if (![self.dataArray containsObject:string]) {
                    [self.dataArray addObject:string];
                }
            }
            break;
        }
    }
    
    //摄影师
    if ([[self.user.fcareerId componentsSeparatedByString:@"|"] containsObject:@"4"]) {
        if (![self.dataArray containsObject:@"专注领域"]) {
            [self.dataArray addObject:@"专注领域"];
        }
    }
    
    //不是观众就加个经验
    if (![self.user.fcareerId isEqualToString:@""]) {
        if (![self.dataArray containsObject:@"经验"]) {
            [self.dataArray addObject:@"经验"];
        }
    }
    
    //最后加这几种
    if (![self.detail.contact isEqualToString:@""]) {
        [self.dataArray addObject:@"联系方式"];
    }
    if (![self.detail.email isEqualToString:@""]) {
        [self.dataArray addObject:@"电子邮件"];
    }
    if (![self.detail.website isEqualToString:@""]) {
        [self.dataArray addObject:@"网站"];
    }
    
    
    NSLog(@"dataArray ==== %@",self.dataArray);

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
        
        cell.label.text = @"AHSSHJSGJDDjdsdfksdjfksdjfksdjj嘻卡斯是是是是是是是是是是穿不不不不不不不不不不不不不不不不不不嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻卡斯是是是是是是是是是是";
        return cell;
    }else if (indexPath.section == 1){
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        
        cell.mainLabelWidth.constant = 60;
        cell.mainLabel.text = self.dataArray[indexPath.row];
        cell.subLabel.text = @"穿不不不不不不不不不不不不不不不不不不嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻卡斯是是是是是是是是是是";
        
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
        
        return cell;
    }else {
        MB_SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierSummary forIndexPath:indexPath];
        
        cell.mainLabelWidth.constant = 0;
        cell.mainLabel.text = @"";
        cell.subLabel.text = @"穿不不不不不不不不不不不不不不不不不不嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻卡斯是是是是是是是是是是";
        
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
        MB_EditSummaryViewController *editVC = [[MB_EditSummaryViewController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
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


#pragma mark - privtate methods
- (void)requestUserDetail {
    NSDictionary *params = @{@"id":@(6),
                             @"token":@"abcde",
                             @"fid":@(6)};
    [[AFHttpTool shareTool] getUerDetailWithParameters:params success:^(id response) {
        NSLog(@"detail %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.detail = [[MB_UserDetail alloc] init];
            self.detailDic = response;
            //        [self.detail setValuesForKeysWithDictionary:response];
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)editButtonOnClick:(UIButton *)button {
    self.editing = !button.selected;
    [self.tableView reloadData];
    
    if (button.selected) {
        //更新用户信息到服务器
        self.tableView.separatorColor = colorWithHexString(@"#eeeeee");
    }else{
        self.tableView.separatorColor = [UIColor clearColor];
    }
    
    button.selected = !button.selected;
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

@end
