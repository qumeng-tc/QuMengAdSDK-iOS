//
//  QMNativeVideCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QuMengNativeVideoCell.h"

#import "ViewController.h"

#import <Masonry/Masonry.h>
#import <YYWebImage/UIImageView+YYWebImage.h>

@interface QuMengNativeVideoCell()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation QuMengNativeVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bgImageView = [UIImageView new];
        [self.contentView addSubview:self.bgImageView];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_bottom);
            make.bottom.mas_equalTo(self.actionBtn.mas_top);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
    }
    return self;
}


- (void)refreshWithData:(QuMengNativeAd *)nativeAd {
    [super refreshWithData:nativeAd];
    __weak typeof(self) weakSelf = self;
    [self.bgImageView yy_setImageWithURL:[NSURL URLWithString:nativeAd.meta.logoUrl]
                             placeholder:nil
                                 options:YYWebImageOptionProgressive
                              completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (stage == YYWebImageStageFinished && image) {
            strongSelf.bgImageView.image = [strongSelf image:image withBlurLevel:10];
        }
    }];

    UIView *adView = [self.contentView viewWithTag:1000];
    [adView removeFromSuperview];


    nativeAd.videoView.tag = 1000;
    [self.contentView addSubview:nativeAd.videoView];
    
    [nativeAd.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.mas_equalTo(self.bgImageView);
        make.width.mas_equalTo(nativeAd.videoView.mas_height).multipliedBy(nativeAd.meta.getMediaSize.width / nativeAd.meta.getMediaSize.height);
    }];
    
    if (nativeAdShowSlide()) {
        [self.contentView bringSubviewToFront:self.slideView];
    }
}

- (UIImage *)image:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey:@"inputRadius"];
    CIImage *blurredImage = [filter valueForKey:kCIOutputImageKey];
    CIImage *overlayImage = [CIImage imageWithColor:[CIColor colorWithRed:0 green:0 blue:0 alpha:0.90]];
    overlayImage = [overlayImage imageByCroppingToRect:ciImage.extent];
    
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [compositeFilter setValue:overlayImage forKey:kCIInputImageKey];
    [compositeFilter setValue:blurredImage forKey:kCIInputBackgroundImageKey];
    
    CIImage *finalImage = [compositeFilter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:finalImage fromRect:ciImage.extent];
    UIImage *resultImage = [UIImage imageWithCGImage:outImage];
    
    CGImageRelease(outImage);
    
    return resultImage;
}

@end


