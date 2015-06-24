//
//  MB_AddAblumMenuView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_AddAblumMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIButton *templateButton;

@property (nonatomic, assign) BOOL isShowing;

@end
