//
//  QuMengNativeAtlasImgeCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QuMengNativeAtlasImgeCell.h"
#import <Masonry.h>
#import <UIImageView+YYWebImage.h>

@interface QuMengNativeAtlasImgeCell ()

@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UIImageView *coverImg2;
@property (nonatomic, strong) UIImageView *coverImg3;

@end

@implementation QuMengNativeAtlasImgeCell

- (void)refreshWithData:(QuMengNativeAd *)nativeAd {
    [super refreshWithData:nativeAd];
    
    for (int i = 0; i < nativeAd.meta.getExtUrls.count; i++) {
        UIImageView *img = [self.contentView viewWithTag:(i + 1) * 100];
        NSString *url = nativeAd.meta.getExtUrls[i];
        [img yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil];
        [nativeAd registerContainer:self.contentView withClickableViews:@[img]];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.coverImg2];
        [self.contentView addSubview:self.coverImg3];
        
        __weak typeof(self) weakSelf = self;
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView).offset(30);
            make.bottom.equalTo(weakSelf.contentView).offset(-35);
        }];
        
        [self.coverImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(weakSelf.coverImg);
            make.left.equalTo(weakSelf.coverImg.mas_right).offset(2);
        }];
        
        [self.coverImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(weakSelf.coverImg2);
            make.left.equalTo(weakSelf.coverImg2.mas_right).offset(2);
            make.right.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

- (UIImageView *)coverImg {
    if (!_coverImg) {
        _coverImg = [UIImageView new];
        _coverImg.tag = 100;
    }
    return _coverImg;
}

- (UIImageView *)coverImg2 {
    if (!_coverImg2) {
        _coverImg2 = [UIImageView new];
        _coverImg2.tag = 200;
    }
    return _coverImg2;
}

- (UIImageView *)coverImg3 {
    if (!_coverImg3) {
        _coverImg3 = [UIImageView new];
        _coverImg3.tag = 300;
    }
    return _coverImg3;
}

@end
