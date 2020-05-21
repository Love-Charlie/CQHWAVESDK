//
//  AppDelegate.m
//  WaveSDKDemo
//
//  Created by Love Charlie on 2020/3/11.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "AppDelegate.h"
#import <WaveSDK/WSDK.h>
#import <WaveSDK/CQHConfig.h>
#import <WaveSDK/CQHTools.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarHidden = YES;
    [WSDK registerAppID:@"wx343790ea3256d6dc" andUniversalLinks:@"https://www.waveinspire.com/universallinks/"];
    
    CQHConfig *config = [CQHConfig sharedConfig];
    config.gameId = @"1132";
    config.packageId = @"100";
    config.channelId = @"100002";
    config.key = @"cvFbf3rdmTqcpQWSTu5eIG8Av5L17Flv";
    config.configId = @"0";
    config.appleID = @"wx343790ea3256d6dc";
    [WSDK initWithSDKWithConfig:config];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WSDK handleOpenURL:url delegate:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
