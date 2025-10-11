//
//  QuMengNativeSingleViewController.m
//  QuMengAdSDK
//
//  Created by xusheng on 2024/11/4.
//

#import "QuMengNativeSingleViewController.h"
#import <QuMengAdSDK/QuMengAdSDK.h>
#import <YYWebImage/UIImageView+YYWebImage.h>
#import <Masonry/Masonry.h>
#import "ViewController.h"

@interface QuMengNativeSingleViewController () <QuMengNativeAdDelegate>
@property (nonatomic, strong) QuMengNativeAd *nativeAd;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *jumpLabel;

@property (nonatomic, strong)UIView *materialView;

@end

@implementation QuMengNativeSingleViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
    }
    return _imageView;
}

- (UILabel *)jumpLabel {
    if (!_jumpLabel) {
        _jumpLabel = [[UILabel alloc] init];
        _jumpLabel.text = @"点击跳转";
    }
    return _jumpLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nativeAd = [[QuMengNativeAd alloc] initWithSlot:self.slot];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAdData];
    //    nativeAd load
    // Do any additional setup after loading the view.
}

- (void)setLayoutSubview {
    
    
    BOOL isVideo = self.nativeAd.meta.getMaterialType == 4 || self.nativeAd.meta.getMaterialType == 12;
    self.materialView = isVideo ? self.nativeAd.videoView: self.imageView;
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(400);
    }];
    [view addSubview:self.materialView];
    
   
    
    [view addSubview:self.jumpLabel];
    [self.materialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.jumpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.materialView.mas_bottom).offset(10);
    }];
}


// MARK: QuMengNativeAdDelegate
- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 请求成功");
    
    // 检查广告有效性
    if (checkAdValid()) {
        [nativeAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】激励视频:: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (nativeAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】自渲染: 趣盟竞价成功，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】自渲染: 趣盟竞价失败，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    
    [self setLayoutSubview];
    
    /// 视频
    if (nativeAd.meta.getMaterialType == 4 || nativeAd.meta.getMaterialType == 12) {
        [nativeAd registerContainer:self.materialView withClickableViews:@[self.jumpLabel]];
    } else {
    /// 图片
        [self.imageView yy_setImageWithURL:[NSURL URLWithString:nativeAd.meta.getMediaUrl] placeholder:nil];
        [nativeAd registerContainer:self.materialView withClickableViews:@[self.jumpLabel]];
    }
    
    QuMengLog(@"qmTextLogoUrl == %@", nativeAd.meta.qmTextLogoUrl);
    QuMengLog(@"qmLogoUrl == %@", nativeAd.meta.qmLogoUrl);

}

- (void)qumeng_nativeAdLoadFail:(QuMengNativeAd *)nativeAd error:(NSError *)error {
    QuMengLog(@"【媒体】自渲染: 请求失败");
}

- (void)qumeng_nativeAdDidShow:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 曝光");
    [MBProgressHUD showMessage:@"NativeAd: 曝光"];
}

- (void)qumeng_nativeAdDidClick:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 点击");
    [MBProgressHUD showMessage:@"NativeAd: 点击"];
}

- (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 关闭落地页");
}

/// 自渲染视频播放开始
- (void)qumeng_nativeAdDidStart:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 视频播放开始");
}

/// 自渲染视频播放暂停
- (void)qumeng_nativeAdDidPause:(QuMengNativeAd *)nativeAd{
    QuMengLog(@"【媒体】自渲染: 视频播放暂停");
}

/// 自渲染视频播放继续
- (void)qumeng_nativeAdDidResume:(QuMengNativeAd *)nativeAd {
    QuMengLog(@"【媒体】自渲染: 视频播放继续");
}

/// 自渲染视频播放完成
- (void)qumeng_nativeAdVideoDidPlayComplection:(QuMengNativeAd *)nativeAd{
    QuMengLog(@"【媒体】自渲染: 视频播放完成");
}

/// 自渲染视频播放异常
- (void)qumeng_nativeAdVideoDidPlayFinished:(QuMengNativeAd *)nativeAd didFailWithError:(NSError *)error{
    QuMengLog(@"【媒体】自渲染: 视频播放结束");
}

@end
