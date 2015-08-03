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
#import "UITableView+FDTemplateLayoutCell.h"
#import "MB_LikersViewController.h"
#import "MB_CommentsViewController.h"

static NSString * const ReuseIdentifierAblum = @"ablummm";
static NSString * const ReuseIdentifierTemplate = @"template";

@interface MB_AblumViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

//@property (nonatomic, strong) UIView *coverView;
//@property (nonatomic, strong) MB_AddAblumMenuView *menuView;


@end

@implementation MB_AblumViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblumList:) name:kRefreshAblumNotification object:nil];
    
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    if (userVC.comeFromType == ComeFromTypeSelf) {
        [self.view addSubview:self.addView];
    }
    
    [self.view addSubview:self.tableView];
    [self addPullRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestAblumListWithMinId:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Ablum *album = self.dataArray[indexPath.section];
    if (album.atype == AblumTypeCollect) {
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierAblum cacheByIndexPath:indexPath configuration:^(MB_AlbumTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:ReuseIdentifierTemplate cacheByIndexPath:indexPath configuration:^(MB_SignalImageTableViewCell *cell) {
            [self configureCell2:cell atIndexPath:indexPath];
        }];
    }
}

- (void)configureCell:(MB_AlbumTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.ablum = self.dataArray[indexPath.section];
    
    //影集点击手势进详情
    cell.imagesScrollView.tag = indexPath.section;
    [cell.tap addTarget:self action:@selector(handleTap:)];
    
    cell.label1.tag = indexPath.section;
    cell.label2.tag = indexPath.section;
    cell.label3.tag = indexPath.section;
    cell.label4.tag = indexPath.section;
    
    [cell.tap1 addTarget:self action:@selector(mButtonOnClick:)];
    [cell.tap2 addTarget:self action:@selector(pButtonOnClick:)];
    [cell.tap3 addTarget:self action:@selector(hButtonOnClick:)];
    [cell.tap4 addTarget:self action:@selector(mkButtonOnClick:)];
    
    //对影集的操作
    cell.likeButton.tag = indexPath.section;
    [cell.likeButton addTarget:self action:@selector(likeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.likeListButton.tag = indexPath.section;
    [cell.likeListButton addTarget:self action:@selector(likeListButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tag = indexPath.section;
    [cell.commentButton addTarget:self action:@selector(commentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareButton.tag = indexPath.section;
    [cell.shareButton addTarget:self action:@selector(deleteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    MB_UserViewController *userVC = (MB_UserViewController *)self.parentViewController;
    if (userVC.comeFromType == ComeFromTypeSelf) {
        cell.shareButton.hidden = NO;
    }else {
        cell.shareButton.hidden = YES;
    }
}

- (void)configureCell2:(MB_SignalImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.ablum = self.dataArray[indexPath.section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_Ablum *album = self.dataArray[indexPath.section];
    if (album.atype == AblumTypeCollect) {
        MB_AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierAblum forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else {
        MB_SignalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierTemplate forIndexPath:indexPath];
        [self configureCell2:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_ScanAblumViewController *scanVC = [[MB_ScanAblumViewController alloc] init];
    scanVC.ablum = self.dataArray[indexPath.section];
    scanVC.hidesBottomBarWhenPushed = YES;
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


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //不管服务器删除成功与否，先直接删除并记录id，下次请求如果还有的话就不显示
        MB_Ablum *ablum = self.dataArray[actionSheet.tag];
        [self.dataArray removeObject:ablum];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:actionSheet.tag] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
        
        NSMutableArray *array = [[userDefaults objectForKey:kDeleteAblum] mutableCopy];
        if (!array) {
            array = [NSMutableArray arrayWithCapacity:0];
        }
        [array addObject:@(ablum.ablId)];
        [userDefaults setObject:array forKey:kDeleteAblum];
        
        //服务器删除
        NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                                 @"token":[userDefaults objectForKey:kAccessToken],
                                 @"adlId":@(ablum.ablId)};
        
        [[AFHttpTool shareTool] deleteAblumWithParameters:params success:^(id response) {
            NSLog(@"delete ablum: %@",response);
            if ([self statFromResponse:response] == 10000) {
                //            [self.dataArray removeObject:ablum];
                //            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationLeft];
                //            [self.tableView reloadData];
            }
        } failure:^(NSError *err) {
            
        }];
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

//请求影集列表
- (void)requestAblumListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                             @"token":[userDefaults objectForKey:kAccessToken],
                             @"fid":@(self.user.fid),
                             @"minId":@(minId),
                             @"count":@(10)};
    [[AFHttpTool shareTool] getAblumWithParameters:params success:^(id response) {
        NSLog(@"ablum %@",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
        
        if ([self statFromResponse:response] == 10000) {
            if (minId == 0) {
                [self.dataArray removeAllObjects];
            }
            self.minId = [response[@"minId"] integerValue];
            if (response[@"list"] != nil && ![response[@"list"] isKindOfClass:[NSNull class]]) {
                NSArray *array = response[@"list"];
                
                for (NSDictionary *dic in array) {
                    MB_Ablum *ablum = [[MB_Ablum alloc] init];
                    NSArray *array = [userDefaults objectForKey:kDeleteAblum];
                    if (![array containsObject:@(ablum.ablId)]) {
                        [ablum setValuesForKeysWithDictionary:dic];
                        [self.dataArray addObject:ablum];
                    }
                }
            }
            
            if (self.dataArray.count <= 0) {
                self.tableView.backgroundView = self.noResultView;
            }else {
                self.tableView.backgroundView = nil;
            }
            
            [self.tableView reloadData];
        }else if ([self statFromResponse:response] == 10004) {
            if (minId == 0) {
                self.tableView.backgroundView = self.noResultView;
            }else {
                [self showNoMoreMessageForview:self.tableView];
            }
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshingForView:self.tableView];
    }];
}

- (void)refreshAblumList:(NSNotification *)noti {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestAblumListWithMinId:0];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:tap.view.tag]];
}

//模特
- (void)mButtonOnClick:(UITapGestureRecognizer *)tap {
    MB_Ablum *ablum = self.dataArray[tap.view.tag];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeAblum;
    MB_User *user = [[MB_User alloc] init];
    user.likeType = LikedTypeNone;
    user.fid = ablum.mId;
    user.fname = ablum.mName;
    userVC.user = user;
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}
//摄影师
- (void)pButtonOnClick:(UITapGestureRecognizer *)tap {
    MB_Ablum *ablum = self.dataArray[tap.view.tag];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeAblum;
    MB_User *user = [[MB_User alloc] init];
    user.likeType = LikedTypeNone;
    user.fid = ablum.pId;
    user.fname = ablum.pName;
    userVC.user = user;
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}
//发型师
- (void)hButtonOnClick:(UITapGestureRecognizer *)tap {
    MB_Ablum *ablum = self.dataArray[tap.view.tag];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeAblum;
    MB_User *user = [[MB_User alloc] init];
    user.likeType = LikedTypeNone;
    user.fid = ablum.hId;
    user.fname = ablum.hName;
    userVC.user = user;
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}
//化妆师
- (void)mkButtonOnClick:(UITapGestureRecognizer *)tap {
    MB_Ablum *ablum = self.dataArray[tap.view.tag];
    MB_UserViewController *userVC = [[MB_UserViewController alloc] init];
    userVC.comeFromType = ComeFromTypeAblum;
    MB_User *user = [[MB_User alloc] init];
    user.likeType = LikedTypeNone;
    user.fid = ablum.mkId;
    user.fname = ablum.mkName;
    userVC.user = user;
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}

//点赞
- (void)likeButtonOnClick:(UIButton *)button {
//    if (!button.selected) {
//        button.selected = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MB_Ablum *ablum = self.dataArray[button.tag];
        NSDictionary *params = @{@"id":[userDefaults objectForKey:kID],
                                 @"token":[userDefaults objectForKey:kAccessToken],
                                 @"fid":@(ablum.uid),
                                 @"ablId":@(ablum.ablId)};
        [[AFHttpTool shareTool] likeAblumWithParameters:params success:^(id response) {
            NSLog(@"like send %@", response);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([self statFromResponse:response] == 10000) {
                ablum.likes += 1;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:button.tag]] withRowAnimation:UITableViewRowAnimationNone];
            }else {
//                button.selected = NO;
            }
        } failure:^(NSError *err) {
//            button.selected = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
//    }
}

//查看赞列表
- (void)likeListButtonOnClick:(UIButton *)button {
    MB_LikersViewController *likersVC = [[MB_LikersViewController alloc] init];
    likersVC.hidesBottomBarWhenPushed = YES;
    likersVC.ablum = self.dataArray[button.tag];
    [self.navigationController pushViewController:likersVC animated:YES];
}

//评论列表
- (void)commentButtonOnClick:(UIButton *)button {
    MB_CommentsViewController *commentsVC = [[MB_CommentsViewController alloc] init];
    commentsVC.ablum = self.dataArray[button.tag];
    commentsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentsVC animated:YES];
}

//删除影集
- (void)deleteButtonOnClick:(UIButton *)button {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocalizedString(@"Delete_Ablum", nil) delegate:self cancelButtonTitle:LocalizedString(@"Delete_N", nil) destructiveButtonTitle:LocalizedString(@"Delete_Y", nil) otherButtonTitles:nil, nil];
    actionSheet.tag = button.tag;
    [actionSheet showInView:self.view];
}

//添加作品集
- (void)addButtonOnClick:(UIButton *)button{
//    //使菜单出现
//    self.menuView.isShowing = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.coverView.hidden = 0;
//        CGRect rect = self.menuView.frame;
//        self.menuView.frame = CGRectMake(0, kWindowHeight - rect.size.height, kWindowWidth, rect.size.height);
//    }];
    
    MB_SelectPhotosViewController *vc = [[MB_SelectPhotosViewController alloc] init];
    vc.type = SelectTypeAll;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)handleCoverViewTap:(UITapGestureRecognizer *)tap {
//    //使菜单消失
//    self.menuView.isShowing = NO;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.coverView.hidden = 1;
//        CGRect rect = self.menuView.frame;
//        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
//    } completion:^(BOOL finished) {
//        [self.coverView removeFromSuperview];
//        [self.menuView removeFromSuperview];
//    }];
//}

//添加相册
//- (void)albumButtonOnClick:(UIButton *)button {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.coverView.hidden = YES;
//        CGRect rect = self.menuView.frame;
//        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
//    }];
//    MB_SelectPhotosViewController *vc = [[MB_SelectPhotosViewController alloc] init];
//    vc.type = SelectTypeAll;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

//添加模板
//- (void)templateButtonOnClick:(UIButton *)button {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.coverView.hidden = YES;
//        CGRect rect = self.menuView.frame;
//        self.menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, rect.size.height);
//    }];
//    MB_SelectTemplateViewController *vc = [[MB_SelectTemplateViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - getters & setters
//上部的制作相册按钮
- (UIView *)addView {
    if (_addView == nil) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
        _addView.backgroundColor = colorWithHexString(@"#eeeeee");
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(21.0 / 2, 21.0 / 2, kWindowWidth - 21, 43);
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addView addSubview:button];
    }
    return _addView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addView.frame), kWindowWidth, CGRectGetHeight(self.containerViewRect) - CGRectGetMaxY(_addView.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;

        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 10.5;
        _tableView.allowsSelection = NO;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        [_tableView setTableFooterView:view];
        [_tableView setTableHeaderView:view];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MB_AlbumTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ReuseIdentifierAblum];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_SignalImageTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierTemplate];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//黑色半透明背景
//-(UIView *)coverView {
//    if (_coverView == nil) {
//        _coverView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//        _coverView.backgroundColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.3];
//        _coverView.hidden = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCoverViewTap:)];
//        [_coverView addGestureRecognizer:tap];
//    }
//    return _coverView;
//}

//制作相册和模板的选项菜单
//- (UIView *)menuView {
//    if (_menuView == nil) {
//        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MB_AddAblumMenuView" owner:nil options:nil] firstObject];
//        _menuView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 139);
//        [_menuView.albumButton addTarget:self action:@selector(albumButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_menuView.templateButton addTarget:self action:@selector(templateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _menuView;
//}

@end
