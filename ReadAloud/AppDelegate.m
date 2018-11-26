//
//  AppDelegate.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "BooklistViewController.h"
#import "ReadAloudManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@", [error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
    [self setUpVC];
    // 让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    return YES;
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
//设置控制器
- (void)setUpVC{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    BooklistViewController *homePage = [BooklistViewController new];
    homePage.navigationItem.title = @"首页";
    UINavigationController *navigationCon = [[UINavigationController alloc]initWithRootViewController:homePage];
    [self.window setRootViewController:navigationCon];
    [self.window makeKeyAndVisible];
}
//处理远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    ReadAloudManager *manager = [ReadAloudManager defaultManager];
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            NSLog(@"play");
            [manager continueSpeech];
            break;
        case UIEventSubtypeRemoteControlPause:
            NSLog(@"pause");
            [manager pauseSpeech];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"next");
            [manager nextChapter];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"previous");;
            [manager previousChapter];
            break;
        default:
            break;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    [ZJCustomHud showWithText:url.absoluteString WithDurations:3];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你点击了%@按钮",[url host]] delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
    [alert show];
    return  YES;
}

#pragma mark - ShareFile

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSString *formPath = url.absoluteString;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *fileName = [formPath componentsSeparatedByString:@"/"].lastObject;
    fileName = [fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    documentDir = [NSString stringWithFormat:@"%@/%@",documentDir,fileName];
    NSData *contentData = [NSData dataWithContentsOfURL:url];
    
    if ([fileManager createFileAtPath:documentDir contents:contentData attributes:nil]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HOME_GET_ITUNES_FILE" object:nil];
    }
    
    
    return YES;
}



@end
