//
//  QuMengBaseNavigationController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QuMengBaseNavigationController.h"

#import "UIColor+QuMengAD.h"

@interface QuMengBaseNavigationController ()

@end

@implementation QuMengBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor qumeng_colorWithHex:@"#FFFFFF"];
    self.navigationBar.tintColor = [UIColor qumeng_colorWithHex:@"#333333"];
    [self.navigationBar setShadowImage:[UIColor qumeng_imageWith:@"#CCCCCC" size:CGSizeMake(CGRectGetWidth(self.view.frame), 0.5)]];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
