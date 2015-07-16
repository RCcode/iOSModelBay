//
//  MB_SummaryTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/11.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MB_SummaryTableViewCell : UITableViewCell

//@property (nonatomic, strong) CAShapeLayer *mylayer;

@property (weak, nonatomic) IBOutlet UIImageView *dashLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainLabelWidth;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoImageView;


@end
