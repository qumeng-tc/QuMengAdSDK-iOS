//
//  LaunchScreenViewController.m
//  AdSDKDemo
//
//  Created by admin on 2024/9/24.
//

#import "LaunchScreenViewController.h"

#import "ViewController.h"
#import "QuMengBaseConf.h"
#import "QuMengSplashAdConf.h"

#import "UIInterface+QuMengRotation.h"

@interface LaunchScreenViewController () <QuMengSplashAdConfDelegate>

@property (nonatomic, strong) QuMengSplashAdConf *conf;
@property (nonatomic, strong) NSTimer *timer;  // 定时器
@property (nonatomic, assign) NSInteger countdown; // 倒计时计数

@end

@implementation LaunchScreenViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:imageView];
    
    NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:@"splashAdAction"] ?: @{
        @"action": @"开屏-竖版图片",
        @"slot": @"9014846",
        @"conf" : @"QuMengSplashAdConf",
        @"SEL": NSStringFromSelector(@selector(splashAdAction:))
    };
    PMP(self, NSSelectorFromString(item[@"SEL"]), item);
//    [self startCountdown];
}

- (void)startCountdown {
    // 初始化定时器，每秒更新一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                  target:self
                                                selector:@selector(updateCountdown)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateCountdown {
    // 更新倒计时
    if (self.countdown > 0) {
        self.countdown -= 1;
    } else {
        // 倒计时结束
        [self.timer invalidate];
        self.timer = nil;
        // 触发其他逻辑，例如调用方法或改变界面
        [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    }
}

// 栏位跳转
- (void)splashAdAction:(NSDictionary *)params {
    _conf = [[QuMengSplashAdConf alloc] init];
    _conf.delegate = self;
    [_conf qumeng_loadAd:params];
}

// 关闭开屏
- (void)splashAdDidClose {
    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
