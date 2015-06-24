//
//  MB_LikersViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/18.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LikersViewController.h"
#import "MB_LikersTableViewCell.h"
#import "MB_Liker.h"

@interface MB_LikersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger minId;

@end

@implementation MB_LikersViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self requestLikesListWithMinId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_LikersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - private methods
- (void)requestLikesListWithMinId:(NSInteger)minId {
    NSDictionary *params = @{@"id":@"",
                             @"token":@"",
                             @"ablId":@"",//作品集id
                             @"minId":@(minId),
                             @"count":@(10),};
    [[AFHttpTool shareTool] getAblumLikesWithParameters:params success:^(id response) {
        NSLog(@"LIKERS %@",response);
        if ([self statFromResponse:response] == 10000) {
            self.minId = [response[@"minId"] integerValue];
            NSArray *array = response[@"list"];
            for (NSDictionary *dic in array) {
                MB_Liker *liker = [[MB_Liker alloc] init];
                [liker setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:liker];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MB_LikersTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}


@end
