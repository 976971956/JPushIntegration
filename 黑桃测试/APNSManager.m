//
//  APNSManager.m
//  黑桃测试
//
//  Created by yhf on 16/9/26.
//  Copyright © 2016年 SaiYi. All rights reserved.
//

#import "APNSManager.h"

#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#define Device6 ([[UIDevice currentDevice].systemVersion floatValue] <= 6.0)
#define Device10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

@implementation APNSManager
{
    int indexs;
}
+(void)APNSAllMeansLaunchOptions:(NSDictionary *)launchOptions APPKey:(NSString *)appkey Production:(BOOL)production delegete:(id)delegete
{
    
      NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];//获取bundle id
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegete];
//#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appkey
                          channel:@"appstor"
                 apsForProduction:production
            advertisingIdentifier:advertisingId];
    NSLog(@"注册ID:%@",[JPUSHService registrationID]);
}
+(void)registerSuccedDeviceToken:(NSData *)Token
{
    [JPUSHService registerDeviceToken:Token];
}
+(void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];

}
-(void)RecordIndex
{
    [UIApplication sharedApplication].applicationIconBadgeNumber =indexs;
    BOOL bol =  [JPUSHService setBadge:0];
    if (bol) {
        NSLog(@"1");
    }else{
        NSLog(@"2");
    }

}

@end
