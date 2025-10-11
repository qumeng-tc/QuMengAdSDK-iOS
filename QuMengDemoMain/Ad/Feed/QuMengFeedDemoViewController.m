//
//  QuMengFeedDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <Masonry/Masonry.h>

#import "QuMengFeedDemoViewController.h"
#import "QuMengFeedAdCell.h"
#import "ViewController.h"

@interface QuMengFeedDemoViewController ()<QuMengFeedAdDelegate>

@property (nonatomic, strong) NSMutableArray *feedAds;
@property (nonatomic, strong) dispatch_group_t completionGroup;

@end

@implementation QuMengFeedDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[QuMengFeedAdCell class] forCellReuseIdentifier:@"QuMengFeedAdCell"];
    [self loadData:self.slot];
}

- (void)loadData:(NSString *)slotID  {
    self.feedAds = @[
        [[QuMengFeedAd alloc] initWithSlot:slotID],
        [[QuMengFeedAd alloc] initWithSlot:slotID],
        [[QuMengFeedAd alloc] initWithSlot:slotID],
        [[QuMengFeedAd alloc] initWithSlot:slotID]
    ].mutableCopy;
    
    _completionGroup = dispatch_group_create();
    for (QuMengFeedAd *feedAd in self.feedAds) {
        dispatch_group_enter(_completionGroup);
        feedAd.delegate = self;
        [feedAd loadAdData];
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Feed AD: %d", i]];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(_completionGroup, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        for (QuMengFeedAd *feed in self.feedAds) {
            feed.delegate = strongSelf;
            NSInteger idx = [strongSelf.feedAds indexOfObject:feed];
            idx = idx * 4 + 1;
            [array insertObject:feed atIndex:idx];
        }
        strongSelf.sourceArray = array;
        [strongSelf.tableView reloadData];
    });
    
}

// MARK: - QuMengFeedAdDelegate
- (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd {
//    NSInteger getECPM = feedAd.meta.getECPM;
    // 检查广告有效性
    if (checkAdValid()) {
        [feedAd isValid];
    }
    
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 物料加载成功",(long)idx + 1);
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】信息流: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (feedAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】信息流: 趣盟竞价成功，趣盟价格：%ld", (long)feedAd.meta.getECPM);
        [feedAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】信息流: 趣盟竞价失败，趣盟价格：%ld", (long)feedAd.meta.getECPM);
        [feedAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        [self.feedAds removeObject: feedAd];
    }
    
    dispatch_group_leave(_completionGroup);
}

- (void)qumeng_feedAdLoadFail:(QuMengFeedAd *)feedAd error:(NSError *)error {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 物料加载失败", (long)idx + 1);
    dispatch_group_leave(_completionGroup);
}

- (void)qumeng_feedAdDidShow:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 曝光", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 曝光"];
}

- (void)qumeng_feedAdDidClick:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];

    QuMengLog(@"【媒体】信息流%ld:  点击", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 点击"];
}

- (void)qumeng_feedAdDidClose:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld:  关闭", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 关闭"];
}

- (void)qumeng_feedAdDidCloseOtherController:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld:  关闭落地页", (long)idx + 1);
    [MBProgressHUD showMessage:@"信息流: 关闭落地页"];
}

/// 信息流视频播放开始
- (void)qumeng_feedAdDidStart:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 视频播放开始", (long)idx + 1);
}

/// 信息流视频播放暂停
- (void)qumeng_feedAdDidPause:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 视频播放暂停", (long)idx + 1);
}

/// 信息流视频播放继续
- (void)qumeng_feedAdDidResume:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 视频播放继续", (long)idx + 1);
}

/// 信息流视频播放完成
- (void)qumeng_feedAdVideoDidPlayComplection:(QuMengFeedAd *)feedAd {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 视频播放完成", (long)idx + 1);
}

/// 信息流视频播放异常
- (void)qumeng_feedAdVideoDidPlayFinished:(QuMengFeedAd *)feedAd didFailWithError:(NSError *)error {
    NSInteger idx = [self.feedAds indexOfObject:feedAd];
    QuMengLog(@"【媒体】信息流%ld: 视频播放异常", (long)idx + 1);
}


// MARK: - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QuMengFeedAd class]]) {
        QuMengFeedAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuMengFeedAdCell" forIndexPath:indexPath];
        [cell configFeedCellWith:value];
        return cell;
    } else {
        NSString *cellID = NSStringFromClass([UITableViewCell class]);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = value;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QuMengFeedAd class]]) {
        QuMengFeedAd *feedAd = value;
        return [feedAd handleFeedAdHeight];
    }
    return 160;
}

@end
