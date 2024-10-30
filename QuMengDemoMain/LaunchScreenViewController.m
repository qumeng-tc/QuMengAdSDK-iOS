//
//  LaunchScreenViewController.m
//  AdSDKDemo
//
//  Created by admin on 2024/9/24.
//

#import "LaunchScreenViewController.h"
#import "ViewController.h"
#import "QuMengBaseConf.h"
#import "UIInterface+QuMengRotation.h"

@interface LaunchScreenViewController ()
@property (nonatomic, strong) id<QuMengBaseConf> conf;
@end

@implementation LaunchScreenViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:@"splashAdAction"] ?: @{
        @"action": @"开屏-竖版图片",
        @"slot": @"9014846",
        @"conf" : @"QuMengSplashAdConf",
        @"SEL": NSStringFromSelector(@selector(splashAdAction:))
    };                
    PMP(self, NSSelectorFromString(item[@"SEL"]), item);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:imageView];
}


// 栏位跳转
- (void)splashAdAction:(NSDictionary *)params {
    Class class = NSClassFromString(params[@"conf"]);
    _conf = [[class alloc] init];
    [_conf qumeng_loadAd:params];
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
