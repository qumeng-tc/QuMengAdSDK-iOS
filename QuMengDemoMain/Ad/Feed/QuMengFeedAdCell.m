//
//  QuMengFeedAdCell.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QuMengFeedAdCell.h"

@interface QuMengFeedAdCell ()

@property (nonatomic, strong) QuMengFeedAd *feedAd;

@end

@implementation QuMengFeedAdCell

- (void)configFeedCellWith:(QuMengFeedAd *)feedAd {
    _feedAd = feedAd;
    
    UIView *adView = [self.contentView viewWithTag:1000];
    [adView removeFromSuperview];
    feedAd.feedView.tag = 1000;
    
    feedAd.feedView.frame = self.contentView.bounds;
    [self.contentView addSubview:feedAd.feedView];
}

@end
