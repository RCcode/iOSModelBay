//
//  MB_AddressBookTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/16.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AddressBookTableViewCell.h"

@implementation MB_AddressBookTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setPeople:(MB_AddressBookPeople *)people {
    
    _people = people;
    
    _nameLabel.text = people.name;
    _emailLabel.text = people.email;
}

@end
