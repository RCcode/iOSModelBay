//
//  MB_ScanImageViewController.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/6.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)(NSInteger index);

@interface MB_ScanImageViewController : MB_BaseViewController


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger index;//这张图片的索引
@property (nonatomic, assign) NSInteger count;//总共的个数

@property (nonatomic, copy) DeleteBlock block;

@end
