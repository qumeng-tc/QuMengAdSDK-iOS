//
//  QuMengNativeSingleImageCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QuMengNativeSingleImageCell.h"

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/UIImageView+YYWebImage.h>

@interface QuMengNativeSingleImageCell ()

@property (nonatomic, strong) UIImageView *coverImg;

@end

@implementation QuMengNativeSingleImageCell

- (void)refreshWithData:(QuMengNativeAd *)nativeAd {
    [super refreshWithData:nativeAd];
    [self.coverImg yy_setImageWithURL:[NSURL URLWithString:nativeAd.meta.getMediaUrl] placeholder:nil];
    [nativeAd registerContainer:self.contentView withClickableViews:@[self.coverImg]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImg];
        
        __weak typeof(self) weakSelf = self;
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            make.left.right.equalTo(strongSelf.contentView);
            make.top.equalTo(strongSelf.contentView).offset(30);
            make.bottom.equalTo(strongSelf.contentView).offset(-35);
        }];
    }
    return self;
}

- (UIImageView *)coverImg {
    if (!_coverImg) {
        _coverImg = [UIImageView new];
    }
    return _coverImg;
}

@end
