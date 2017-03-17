//
//  APNSManager.h
//  黑桃测试
//
//  Created by yhf on 16/9/26.
//  Copyright © 2016年 SaiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#import "AppDelegate.h"
@interface APNSManager : NSObject
/**
 *  推送统一接口
 *
 *  @param launchOptions
 *  @param appkey        推送APPkey
 *  @param production    YES为生产NO为开发
 */
+(void)APNSAllMeansLaunchOptions:(NSDictionary *)launchOptions APPKey:(NSString *)appkey Production:(BOOL)production delegete:(id)delegete;
/**
 *  当注册成功时,会获取到设备的deviceToken,上报token到极光服务器
 */
+(void)registerSuccedDeviceToken:(NSData *)Token;
/**
 *  当推送成功时，获取到推送的信息
 *
 *  @param userInfo 推送的信息
 */
+(void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo;
-(void)RecordIndex;
@end
