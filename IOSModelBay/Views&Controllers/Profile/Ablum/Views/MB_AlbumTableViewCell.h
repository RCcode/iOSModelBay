//
//  MB_AlbumTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Ablum.h"
//#import "RKNotificationHub.h"

@interface MB_AlbumTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (nonatomic, strong) MB_Ablum *ablum;

@end
