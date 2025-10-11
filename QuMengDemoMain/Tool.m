//
//  Tool.m
//  AdSDKDemo
//
//  Created by xusheng on 2024/12/31.
//

#import "Tool.h"

@implementation Tool

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        // 如果是 TabBarController，则递归获取选中的子控制器
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        // 如果是 NavigationController，则递归获取栈顶的控制器
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        // 如果有模态展示的控制器，则递归获取模态展示的顶层控制器
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
    } else {
        // 否则返回自己
        return rootViewController;
    }
}

@end
