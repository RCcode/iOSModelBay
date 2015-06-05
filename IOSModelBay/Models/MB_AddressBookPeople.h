//
//  MB_AddressBookPeople.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

//通讯录联系人
@interface MB_AddressBookPeople : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

- (instancetype)initWithName:(NSString *)name email:(NSString *)email;

@end
