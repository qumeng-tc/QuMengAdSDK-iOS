//
//  AppDelegate.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2023/12/29.
//

#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
#import "AppDelegate.h"
#import "QuMengBaseNavigationController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import <DoraemonKit/DoraemonKit.h>
//#import <AnyThinkSDK/AnyThinkSDK.h>
#import "LaunchScreenViewController.h"
#import "UIInterface+QuMengRotation.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化 window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[QMNavigationController alloc] initWithRootViewController:[LaunchScreenViewController new]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.orientation = UIInterfaceOrientationMaskPortrait;
    
    // 禁止夜览模式
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    [[DoraemonManager shareInstance] install];
    [self steupQuMengAdSDK];
    [self setupAnyThinkSDK];
    return YES;
}

- (void)steupQuMengAdSDK {
    QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
    config.isEnablePersonalAds = YES;
    config.appId = @"80006109";
    config.caid = @"";
    config.caidVersion = @"";
    config.lastCaid = @"";
    config.lastCaidVersion = @"";
    config.longitude = @"121.5185";
    config.latitude = @"31.1228";
    [QuMengAdSDKManager setupSDKWith:config];
}

// 集成 topon SDK
- (void)setupAnyThinkSDK {
//    [ATAPI setLogEnabled:YES];
//    [ATAPI integrationChecking];
//    [[ATAPI sharedInstance] startWithAppID:@"a66c58dcc3b629" appKey:@"a6e3ef6c5911a260ab2072d235f1ff394" error:nil];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *query = [url query];
    NSArray *keys = [query componentsSeparatedByString:@"="];
    if (keys.count > 1) {
        NSString *pass = keys[1];
        NSString *key = @"isEncryption";
        [[NSUserDefaults standardUserDefaults] setObject:pass forKey: key];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [[UIViewController topViewControllerForKeyWindow] supportedInterfaceOrientations];
}


@end
