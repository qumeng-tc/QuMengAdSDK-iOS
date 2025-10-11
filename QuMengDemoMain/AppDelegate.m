//
//  AppDelegate.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2023/12/29.
//

#import "AppDelegate.h"
#import "QuMengBaseNavigationController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "LaunchScreenViewController.h"
#import "UIInterface+QuMengRotation.h"

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

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
    
    // 开启不初始化 SDK 开关
    if (!donotSetupSDK()) {
        [self setupQuMengAdSDK];
    }
    
    // 个性化推荐
    if (checkEnablePersonalAds()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestTrackingAuth];
        });
    }
    
    return YES;
}

- (void)setupQuMengAdSDK {
    QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
    config.isEnablePersonalAds = checkEnablePersonalAds();
    config.appId = @"80006109";
    config.qmcds = @[
        @{@"qmcd": @"", @"version": @""},
        @{@"qmcd": @"", @"version": @""}
    ];
    config.longitude = @"121.5185";
    config.latitude = @"31.1228";
    [QuMengAdSDKManager setupSDKWith:config];
    
    if (twistDisabled()) {
        [QuMengAdSDKManager setTwistSwitch:NO];
    }
}

// IDFA
- (NSString *)getIDFA {
    NSString *idfaString = @"";

    if (@available(iOS 14, *)) {
        // iOS 14 及以上需要先请求权限
        if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized) {
            idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            idfaString = @""; // 没授权返回空
        }
    } else {
        // iOS 10 ~ iOS 13 直接获取
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            idfaString = @""; // 用户关闭了广告追踪
        }
    }
    return idfaString;
}

// iOS14+ 请求权限的调用示例
- (void)requestTrackingAuth {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [self getIDFA];
                NSLog(@"授权成功，IDFA = %@", idfa);
            } else {
                NSLog(@"未授权，IDFA 获取不到");
            }
        }];
    } else {
        // iOS 10-13 不需要申请
        NSString *idfa = [self getIDFA];
        NSLog(@"直接获取 IDFA = %@", idfa);
    }
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

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return YES;
}

@end
