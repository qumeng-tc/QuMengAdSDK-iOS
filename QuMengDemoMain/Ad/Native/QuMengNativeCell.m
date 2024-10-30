//
//  QuMengNativeCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import "QuMengNativeCell.h"
#import <Masonry.h>

@interface QuMengNativeCell () 

@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation QuMengNativeCell

- (void)refreshWithData:(QuMengNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    [nativeAd.relatedView refreshData:nativeAd];
    self.titleLab.text = nativeAd.meta.getTitle;
    [self.actionBtn setTitle:nativeAd.meta.getInteractionTitle forState:UIControlStateNormal];    
    [nativeAd registerContainer:self.contentView withClickableViews:@[self.actionBtn, self.titleLab]];
}

//// TopOn 数据展示
//- (void)refreshWithOffer:(ATNativeAdOffer *)offer {
//    
//}

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
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.bottom.equalTo(weakSelf.contentView).offset(-5);
        make.height.mas_equalTo(25);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.height.mas_equalTo(30);
    }];
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



@end
