//
//  MB_InviteViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_InviteViewController.h"
#import "MB_AddressBookPeople.h"
#import <AddressBook/AddressBook.h>

//static NSString * const identifier = @"cell";

@interface MB_InviteViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation MB_InviteViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.listTableView];
    [self AddressBookGetAuthorizationStatus];
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
    }
    
    MB_AddressBookPeople *people = self.dataArray[indexPath.row];
    cell.textLabel.text = people.name;
    cell.detailTextLabel.text = people.email;
    
    if (cell.accessoryView == nil) {
        NSLog(@"sssssssssssssssssssssssssss");
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame           = CGRectMake(0, 0, 100, 40);
        button.tag             = indexPath.row;
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"邀请" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inviteBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }else{
        cell.accessoryView.tag = indexPath.row;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"dddd");
}

#pragma mark - private methods

//是否有通讯录的权限
- (void)AddressBookGetAuthorizationStatus {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        NSLog(@"受限制的");
        
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        NSLog(@"批准的");
        [self checkPeopleFromAddressBook];
    }else{
        NSLog(@"未决定的");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted) {
                NSLog(@"just denied");
            }else{
                NSLog(@"Authorized");
                [self checkPeopleFromAddressBook];
            }
        });
    }
}

//从通讯录提取有邮箱的联系人，如果有多个邮箱用第一个
- (void)checkPeopleFromAddressBook {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *middleName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        NSLog(@"Name:%@ ---%@---%@", firstName, lastName, middleName);
        NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@",firstName, middleName, lastName];
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
//        CFIndex numberOfemail = ABMultiValueGetCount(emails);
//        for (CFIndex i = 0; i < numberOfemail; i++) {
//            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
//            NSLog(@"email:%@", email);
//        }
        if (ABMultiValueCopyValueAtIndex(emails, 0) == nil) {
            NSLog(@"没有邮箱");
        }else{
            MB_AddressBookPeople *people = [[MB_AddressBookPeople alloc] initWithName:fullName email:CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, 0))];
            [self.dataArray addObject:people];
        }
        CFRelease(emails);
        NSLog(@"=============================================");
    }
    [_listTableView reloadData];
}

//点击邀请按钮
- (void)inviteBtnOnclick:(UIButton *)btn {
    NSLog(@"%ld",btn.tag);
}

#pragma mark - getters & setters

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 64 - 49) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
//        _listTableView.allowsSelection = NO;
    }
    return _listTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
