//
//  QuMengSplashContainerViewController.m
//  QuMengAdSDK
//
//  Created by xusheng on 2024/11/11.
//

#import "QuMengSplashContainerViewController.h"
#import <QuMengAdSDK/QuMengAdSDK.h>


@interface QuMengSplashContainerViewController ()<QuMengSplashAdDelegate>
@property (nonatomic, strong) QuMengSplashAd *splashAd;

@end

@implementation QuMengSplashContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadSplashAd {
    _splashAd = [[QuMengSplashAd alloc] initWithSlot:self.slot];
    _splashAd.delegate = self;
    [_splashAd loadAdData];
}

- (void)dismiss {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

// MARK: - QuMengSplashAdDelegate
- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 物料加载成功\n");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [splashAd showSplashViewController:keyWindow.rootViewController];
}

- (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"【媒体】开屏: 物料加载失败");
}

- (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 曝光");
    // 渲染成功再展示视图控制器
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow.rootViewController addChildViewController:self];
    [keyWindow.rootViewController.view addSubview:self.view];
}

- (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 点击");
}

- (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(QuMengSplashAdCloseType)type {
    NSLog(@"【媒体】开屏: 关闭");
    [self dismiss];
}

/// 开屏广告落地页关闭
- (void)qumeng_splashAdDidCloseOtherController:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 落地页关闭");
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


