//
//  AppDelegate.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "AppDelegate.h"
#import "MB_MainViewController.h"
#import "MB_TabBarViewController.h"
#import "Flurry.h"
#import "RC_moreAPPsLib.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[RC_moreAPPsLib shareAdManager] requestWithMoreappId:kMoreAppID];
    [[RC_moreAPPsLib shareAdManager] setAdmobKey:kAdmobID];
    
    [self umengSetting];
    [self flurrySetting];
    [self cancelNotification];
    [self registNotification];
    
    if ([userDefaults boolForKey:kIsLogin] == YES) {
        MB_TabBarViewController *tabVC = [[MB_TabBarViewController alloc] init];
        self.window.rootViewController = tabVC;
    }else{
        MB_MainViewController *mainVC = [[MB_MainViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - 配置友盟
- (void)umengSetting
{
    [MobClick startWithAppkey:kUmengAppKey reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
    //在线参数配置
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick updateOnlineConfig];
}


#pragma mark - Flurry Setting
- (void)flurrySetting
{
    [Flurry startSession:kFlurryAppKey];
}


#pragma mark - registe notification
- (void)registNotification{
    if([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)cancelNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken%@",deviceToken);
//    NSRange range = NSMakeRange(1,[[deviceToken description] length]-2);
//    _deviceToken = [[deviceToken description] substringWithRange:range];
//    NSLog(@"deviceTokenStr==%@",_deviceToken);
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
//    if (token == nil || [token isKindOfClass:[NSNull class]] || ![token isEqualToString:_deviceToken]) {
//        //注册token
//        [self postData:[NSString stringWithFormat:@"%@",_deviceToken]];
//    }
    
    NSDictionary *params = @{@"id":@(6),
                             @"plat":@(2),
                             @"ikey":deviceToken};
    [[AFHttpTool shareTool] updatePushKeyWithParameters:params success:^(id response) {
        NSLog(@"push %@",response);
    } failure:^(NSError *err) {
        
    }];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Fail to Register For Remote Notificaions With Error :error = %@",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo = %@",userInfo);
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
