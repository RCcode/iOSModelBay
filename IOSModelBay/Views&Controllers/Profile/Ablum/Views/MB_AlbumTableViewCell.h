//
//  MB_AlbumTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Ablum.h"
#import "RKNotificationHub.h"

@interface MB_AlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) MB_Ablum *ablum;

@property (nonatomic, strong) RKNotificationHub *hub;

@end
