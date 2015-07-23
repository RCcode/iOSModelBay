//
//  PS_InstragramModel.h
//  iPhotoSocial
//
//  Created by lisongrc on 15-4-3.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_InstragramModel : NSObject

@property (nonatomic, strong) NSDictionary *images; // 图片地址

//
//images =             {
//    "low_resolution" =                 {
//        height = 306;
//        url = "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s306x306/e15/11049429_1086121091401915_996103201_n.jpg";
//        width = 306;
//    };
//    "standard_resolution" =                 {
//        height = 640;
//        url = "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11049429_1086121091401915_996103201_n.jpg";
//        width = 640;
//    };
//    thumbnail =                 {
//        height = 150;
//        url = "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11049429_1086121091401915_996103201_n.jpg";
//        width = 150;
//    };
//};

@end
