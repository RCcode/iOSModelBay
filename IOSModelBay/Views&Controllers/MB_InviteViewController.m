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
#import "MB_AddressBookTableViewCell.h"
@import MessageUI;

@interface MB_InviteViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MB_InviteViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnOnCLick:)];

    [self.view addSubview:self.tableView];
    
    [self AddressBookGetAuthorizationStatus];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MB_AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    MB_AddressBookPeople *people = self.dataArray[indexPath.row];
    cell.people = people;
    
    cell.inviteButton.tag = indexPath.row;
    [cell.inviteButton addTarget:self action:@selector(inviteBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"mail error %@",error);
            break;
        case MFMailComposeResultSent:
            
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private methods
- (void)leftBarBtnOnCLick:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

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
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
        
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
    [self.tableView reloadData];
}

//点击邀请按钮
- (void)inviteBtnOnclick:(UIButton *)btn {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        MB_AddressBookPeople *people = self.dataArray[btn.tag];
        [mailVC setToRecipients:@[people.email]];
        [self presentViewController:mailVC animated:YES completion:nil];
    }else {
        NSLog(@"不可以发邮件");
    }
}




#pragma mark - getters & setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        [_tableView setTableFooterView:[UIView new]];
        [_tableView registerNib:[UINib nibWithNibName:@"MB_AddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
