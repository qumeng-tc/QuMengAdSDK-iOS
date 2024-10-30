//
//  QMSplashWindow.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/26.
//

#import "QuMengSplashNativeView.h"
#import <Masonry/Masonry.h>
#import <UIImageView+YYWebImage.h>

@interface QuMengSplashNativeView()
@property (nonatomic, strong) UIView *adView;

@end

@implementation QuMengSplashNativeView

- (instancetype)initWithSplashNativeAd:(QuMengSplashNativeAd *)splashNativeAd {
    if (self = [super init]) {
        if (splashNativeAd.meta.getMaterialType == 4) {
            QuMengNativeAdRelatedView *ad = [[QuMengNativeAdRelatedView alloc] init];
            [ad refreshDataWithSplashNativeAd:splashNativeAd];
            self.adView = ad.videoAdView;
        } else {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:splashNativeAd.meta.getMediaUrl] placeholder:nil];
            self.adView = imageView;
        }
        
        [self addSubview:self.adView];
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.skipBtn];
        [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@80);
            make.right.mas_equalTo(@-20);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        [self addSubview:self.actionBtn];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@-40);
            make.right.mas_equalTo(@-20);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(@56);
        }];               
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
