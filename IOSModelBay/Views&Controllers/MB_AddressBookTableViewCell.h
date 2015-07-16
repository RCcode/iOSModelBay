//
//  MB_AddressBookTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/16.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_AddressBookPeople.h"

@interface MB_AddressBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (nonatomic, strong) MB_AddressBookPeople *people;

@end
