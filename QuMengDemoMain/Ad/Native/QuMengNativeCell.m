//
//  QuMengNativeCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QuMengNativeCell.h"

#import <Masonry/Masonry.h>

#import "ViewController.h"

@interface QuMengNativeCell ()

@end

@implementation QuMengNativeCell

- (void)refreshWithData:(QuMengNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    self.titleLab.text = nativeAd.meta.getTitle;
    [self.actionBtn setTitle:nativeAd.meta.getInteractionTitle forState:UIControlStateNormal];    
    [nativeAd registerContainer:self.contentView withClickableViews:@[self.actionBtn, self.titleLab]];
    
    if (nativeAdShowSlide()) {
        [self.contentView bringSubviewToFront:self.slideView];
        self.slideView.nativeAd = nativeAd;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.actionBtn];
    [self.contentView addSubview:self.titleLab];
    
    __weak typeof(self) weakSelf = self;
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.right.equalTo(strongSelf.contentView).offset(-20);
        make.bottom.equalTo(strongSelf.contentView).offset(-5);
        make.height.mas_equalTo(25);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.left.equalTo(strongSelf.contentView).offset(20);
        make.right.equalTo(strongSelf.contentView).offset(-20);
        make.top.equalTo(strongSelf.contentView).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    if (nativeAdShowSlide()) {
        [self.contentView addSubview:self.slideView];
        [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            make.left.top.right.mas_equalTo(strongSelf);
            make.height.mas_equalTo(@100);
        }];
    }
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _actionBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        _titleLab.font = [UIFont systemFontOfSize:17];
    }
    return _titleLab;
}

- (QuMengNativeAdSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[QuMengNativeAdSlideView alloc] init];
        _slideView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    return _slideView;
}

@end
