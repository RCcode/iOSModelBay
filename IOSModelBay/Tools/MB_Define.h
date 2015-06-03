//
//  MB_Define.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#ifndef IOSModelBay_MB_Define_h
#define IOSModelBay_MB_Define_h

#define kWindowWidth  [UIScreen mainScreen].bounds.size.width
#define kWindowHeight [UIScreen mainScreen].bounds.size.height


#pragma mark - life cycle

#pragma mark - UITableViewDelegate UITableViewDataSource

#pragma mark - private methods

#pragma mark - getters & setters


#define kRedirectUri @"http://www.facebook.com/rcplatform2014"
#define kClientID @"4e483786559e48bf912b7926843c074a"
#define kClientSecret @"f0e3dfb8c6a44c4caf173673a145eb7d"

#define kUmengAppKey @"556e66fd67e58ee877006d64"
#define kFlurryAppKey @"JVB6C3SPS7K7NPNN86ZH"

#define kMoreAppID 20051
#define kAppID @"878086629"
#define kAdmobID @"ca-app-pub-3747943735238482/3196343450"

#define kAppStoreUrlPre @"itms-apps://itunes.apple.com/app/id"
#define kAppStoreUrl [NSString stringWithFormat:@"%@%@", kAppStoreUrlPre, kAppID]

#define kAppStoreScoreUrlPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreUrl [NSString stringWithFormat:@"%@%@", kAppStoreScoreUrlPre, kAppID]

#define FEEDBACK_EMAIL @"rcplatform.help@gmail.com"
#define FOLLOW_US_URL @"http://www.instagram.com/nocrop_rc"


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif







#endif
