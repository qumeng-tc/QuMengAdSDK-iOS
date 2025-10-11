//
//  QMSplashWindow.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/26.
//

#import "QuMengSplashNativeView.h"
#import <Masonry/Masonry.h>
#import <UIImageView+YYWebImage.h>
#import <QuMengAdSDK/QuMengAdSDK.h>

@interface QuMengSplashNativeView()
@property (nonatomic, strong) UIView *adView;

@end

@implementation QuMengSplashNativeView

- (instancetype)initWithSplashNativeAd:(id)splashNativeAd {
    if (self = [super init]) {
           
    }
    return self;
}

// MARK: - Lazy
- (UIButton *)skipBtn {
    if (!_skipBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
        _skipBtn = btn;
    }
    return _skipBtn;
}

// MARK: - Lazy
- (UIButton *)actionBtn {
    if (!_actionBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 28;
        btn.layer.masksToBounds = YES;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"点击转跳详情页面或者第三方应用" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
        [btn setAttributedTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
        _actionBtn = btn;
    }
    return _actionBtn;
}

@end
