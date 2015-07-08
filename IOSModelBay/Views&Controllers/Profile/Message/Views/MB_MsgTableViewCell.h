//
//  MB_MsgTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/13.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Message.h"

@interface MB_MsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *replyImage;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic, strong) MB_Message *message;

@end
