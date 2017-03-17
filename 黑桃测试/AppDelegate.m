//
//  AppDelegate.m
//  黑桃测试
//
//  Created by yhf on 16/9/24.
//  Copyright © 2016年 SaiYi. All rights reserved.
//

#import "AppDelegate.h"
#import "APNSManager.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()
{
    int index;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [APNSManager APNSAllMeansLaunchOptions:launchOptions APPKey:@"faa402af95f50d88ca500dfc" Production:NO delegete:self];
    [self NotificationCallBack];//推送监听
    [UIApplication sharedApplication].applicationIconBadgeNumber =index;
    
    BOOL bol =  [JPUSHService setBadge:0];//设置角标到服务器
    NSLog(@"%@",bol?@"设置角标成功":@"设置角标失败");
 
    return YES;
}

// 注册推送消息
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"注册成功：%@", deviceToken);
    [APNSManager registerSuccedDeviceToken:deviceToken];
}

-(void)NotificationCallBack
{
    //    正在连接中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidOnConnection:) name:kJPFNetworkDidSetupNotification object:nil];
    // 建立连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    
    // 关闭连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    
    // 注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    //    注册失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidRegisterFail:) name:kJPFNetworkDidRegisterNotification object:nil];
    // 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    // 收到自定义消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}
#pragma mark - 极光推送监听
- (void)JPushDidOnConnection:(NSNotification *)noti
{
    NSLog(@"正在连接中");
}
- (void)JPushDidSetup:(NSNotification *)noti
{
    NSLog(@"建立连接");
}

- (void)JPushDidClose:(NSNotification *)noti
{
    NSLog(@"关闭连接");
}
- (void)JPushDidRegister:(NSNotification *)noti
{
    NSLog(@"注册成功");
}
-(void)JPushDidRegisterFail:(NSNotification *)noti
{
    NSLog(@"注册失败");
}

- (void)JPushDidLogin:(NSNotification *)noti
{
    NSLog(@"登录成功：");
}


- (void)JPushDidReceiveMessage:(NSNotification *)noti
{
    // 收到推送消息
    NSLog(@"收到推送消息:%@", noti.userInfo);
    
}


//#ifdef Device10
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
//#endif

#ifdef Device6
// 6.0之前的方法
// 推送消息成功
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"推送消息成功:%@", userInfo);
    // Required,For systems with less than or equal to iOS6
    // 上报极光服务器
    [APNSManager handleRemoteNotificationUserInfo:userInfo];
    
}
#endif
// 7.0的方法
// 推送消息成功
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"推送消息成功:%@", userInfo);

    // IOS 7 Support Required  上报极光服务器

    [APNSManager handleRemoteNotificationUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// 注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"注册推送失败:did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"应用程序从后台切换到前台的触发");
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber =index;}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
