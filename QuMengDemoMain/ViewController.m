//
//  ViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2023/12/29.
//

#import <Masonry.h>

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "QuMengBaseConf.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import "UIInterface+QuMengRotation.h"
#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
#import "QuMengRewardedVideoConf.h"
#import "QuMengFeedDemoViewController.h"

static NSString *__customBottomViewIsOpen = @"自定义底部视图";
static NSString *__adClickToCloseAutomatically = @"广告点击关闭自动关闭";
bool customBottomViewIsOpen(void) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:__customBottomViewIsOpen];
    return [value boolValue];
}

bool adClickToCloseAutomatically(void) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:__adClickToCloseAutomatically];
    return [value boolValue];
}

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, copy) void (^switchValueChangedHandler)(BOOL isOn);

@end

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _switchControl = [[UISwitch alloc] init];
        _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
        _switchControl.hidden = true;
        [_switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchControl];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@(0));
            make.right.equalTo(@(-20));
            make.size.equalTo(@(CGSizeMake(40, 20)));
        }];
    }
    return self;
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (self.switchValueChangedHandler) {
        self.switchValueChangedHandler(sender.isOn);
    }
}

@end

@interface ViewController () {
    UIInterfaceOrientationMask currentVCInterfaceOrientationMask;
}

@property (nonatomic, strong) id<QuMengBaseConf> conf;
@property (nonatomic, strong) QMRetentionAlertInfo *alertInfo;

@property (nonatomic, assign) CGSize feedSize;

@end

@implementation ViewController

- (AppDelegate *)appdelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"趣盟";
    [UIApplication sharedApplication].statusBarHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"status_bar_hidden"];;
    [self unlockRotation: @{}];
    
    QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
    NSString *personalAdIsEnable = [config isEnablePersonalAds] ? @"YES" : @"NO";
    NSString *versionInfo = [NSString stringWithFormat:@"个性化推荐: %@ \nversion: %@\nshort version: %@", personalAdIsEnable, [QuMengAdSDKManager sdkVersion], [QuMengAdSDKManager shortSdkVersion]];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.text = versionInfo;
    infoLabel.numberOfLines = 0;
    [self.view addSubview:infoLabel];
    
    __weak typeof(self) weakSelf = self;
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-44);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    self.sourceArray = @[
        @{ @"title": @"设置",
           @"list": @[
               @{
                   @"action": @"锁定横屏",
                   @"SEL": NSStringFromSelector(@selector(performHorizontalRotation:))
               },
               @{
                   @"action": @"锁定竖屏",
                   @"SEL": NSStringFromSelector(@selector(performVerticalRotation:))
               },
               
               @{
                   @"action": @"解除锁定",
                   @"SEL": NSStringFromSelector(@selector(unlockRotation:))
               },
               
               @{
                   @"action": __customBottomViewIsOpen,
                   @"isShowSwitch": @(YES),
               },
               @{
                   @"action": __adClickToCloseAutomatically,
                   @"isShowSwitch": @(YES),
               },
               @{
                   @"action": @"清除缓存",
                   @"SEL": NSStringFromSelector(@selector(clearCache:))
               },
               @{
                   @"action": @"添加缓存",
                   @"SEL": NSStringFromSelector(@selector(addCache:))
               },
               @{
                   @"action": @"显示/隐藏状态栏",
                   @"SEL": NSStringFromSelector(@selector(hideStatusBar:))
               },
               @{
                   @"action": @"自定义挽留弹窗",
                   @"SEL": NSStringFromSelector(@selector(customRetentionInfo:))
               },               
               @{
                   @"action": @"信息流自定义尺寸",
                   @"SEL": NSStringFromSelector(@selector(setFeedCustomSize:))
               }
           ]
        },
        
        @{ @"title": @"广告: 开屏",
           @"list": @[
               @{
                   @"action": @"开屏-横版图片",
                   @"slot": @"9016239",
                   @"conf" : @"QuMengSplashAdConf",
                   @"SEL": NSStringFromSelector(@selector(splashAdAction:))
               },
               @{
                   @"action": @"开屏-竖版图片",
                   @"slot": @"9014846",
                   @"conf" : @"QuMengSplashAdConf",
                   @"SEL": NSStringFromSelector(@selector(splashAdAction:))
               },
               @{
                   @"action": @"开屏-横版视频",
                   @"slot": @"9016242",
                   @"conf" : @"QuMengSplashAdConf",
                   @"SEL": NSStringFromSelector(@selector(splashAdAction:))
               },
               @{
                   @"action": @"开屏-竖版视频",
                   @"slot": @"9016243",
                   @"conf" : @"QuMengSplashAdConf",
                   @"SEL": NSStringFromSelector(@selector(splashAdAction:))
               },
               @{
                   @"action": @"开屏-自渲染",
                   @"slot": @"9014846",
                   @"conf" : @"QMSplashCustomAdConf",
                   @"SEL": NSStringFromSelector(@selector(splashAdAction:))
               }
           ]
        },
        @{ @"title": @"广告: 插屏",
           @"list": @[
               @{
                   @"action": @"插屏-横版图片",
                   @"slot": @"9016244",
                   @"conf" : @"QuMengInterstitialConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               },
               @{
                   @"action":
                       @"插屏-竖版图片",
                   @"slot": @"9014856",
                   @"conf" : @"QuMengInterstitialConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               },
               @{
                   @"action": @"插屏-横版视频",
                   @"slot": @"9016245",
                   @"conf" : @"QuMengInterstitialConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               },
               @{
                   @"action": @"插屏-竖版视频",
                   @"slot": @"9016246",
                   @"conf" : @"QuMengInterstitialConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               }
           ]
        },
        @{ @"title": @"广告: 激励视频",
           @"list": @[
               @{
                   @"action":
                       @"激励视频-横版视频",
                   @"slot": @"9016247",
                   @"conf": @"QuMengRewardedVideoConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               },
               @{
                   @"action": @"激励视频-竖版视频",
                   @"slot": @"9016248",
                   @"conf": @"QuMengRewardedVideoConf",
                   @"SEL": NSStringFromSelector(@selector(performSlotJump:))
               },
           ]
        },
        @{ @"title": @"广告: 信息流",
           @"list": @[
               @{
                   @"action": @"大图",
                   @"slot": @"9014850",
                   @"controller": @"QuMengFeedDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"小图",
                   @"slot": @"9014849",
                   @"controller": @"QuMengFeedDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"组图",
                   @"slot": @"9014848",
                   @"controller": @"QuMengFeedDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"横版视频",
                   @"slot": @"9014853",
                   @"controller": @"QuMengFeedDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"竖版视频",
                   @"slot": @"9014859",
                   @"controller": @"QuMengFeedDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               }
           ]
        },
        @{ @"title": @"广告: 自渲染",
           @"list": @[
               @{
                   @"action": @"大图",
                   @"slot": @"9014850",
                   @"controller": @"QuMengNativeDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"小图",
                   @"slot": @"9014849",
                   @"controller": @"QuMengNativeDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"组图",
                   @"slot": @"9014848",
                   @"controller": @"QuMengNativeDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               },
               @{
                   @"action": @"视频",
                   @"slot": @"9014853",
                   @"controller": @"QuMengNativeDemoViewController",
                   @"SEL": NSStringFromSelector(@selector(performCustomJump:))
               }
           ]
        }
    ];
    [self.tableView reloadData];
}

- (void)performHorizontalRotation:(NSDictionary *)params {
    [self qumeng_rotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
    [self qumeng_setNeedsUpdateOfSupportedInterfaceOrientations];
}

- (void)performVerticalRotation:(NSDictionary *)params {
    currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    [self qumeng_rotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self qumeng_setNeedsUpdateOfSupportedInterfaceOrientations];
}

/// 解除锁定
- (void)unlockRotation:(NSDictionary *)params {
    currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    [self qumeng_setNeedsUpdateOfSupportedInterfaceOrientations];
}

// 自定义底部视图
- (void)performCustomBottomView:(NSDictionary *)params {
    BOOL isOn = [params[@"switchIsOn"] boolValue];
    NSString *key = @"QMIsCustomBottomView";
    [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey: key];
}

// 栏位跳转
- (void)splashAdAction:(NSDictionary *)params {
    [[NSUserDefaults standardUserDefaults] setObject:params forKey: @"splashAdAction"];
    [self performSlotJump:params];
}

// 栏位跳转
- (void)performSlotJump:(NSDictionary *)params {
    NSString *className = params[@"conf"];
    Class class = NSClassFromString(className);
    _conf = [[class alloc] init];
    
    if ([className isEqualToString:@"QuMengRewardedVideoConf"]) {
        QuMengRewardedVideoConf *conf = (QuMengRewardedVideoConf *)_conf;
        conf.info = self.alertInfo;
    }
    [_conf qumeng_loadAd:params];
}

// 信息流，自渲染
- (void)performCustomJump:(NSDictionary *)params {
    NSString *className = params[@"controller"];
    Class class = NSClassFromString(className);
    UIViewController *controller = [[class alloc] init];
    controller.title = params[@"action"];
    [controller setValue:params[@"slot"] forKey:@"slot"];
    
    if ([className isEqualToString:@"QuMengFeedDemoViewController"]) {
        [(QuMengFeedDemoViewController *)controller setFeedcCustomSize: self.feedSize];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

// 清除缓存
- (void)clearCache:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入缓存 Key" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *keyTextField = alertController.textFields.firstObject;
        if (keyTextField.text.length == 0) {
            [MBProgressHUD showMessage:@"请输入缓存 Key"];
        } else {
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey: keyTextField.text];
            if (value && value.length && [value isKindOfClass:NSString.class]) {
                [MBProgressHUD showMessage: value];
            } else {
                [MBProgressHUD showMessage:@"未查询到结果"];
            }
        }
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *keyTextField = alertController.textFields.firstObject;
        if (keyTextField.text.length == 0) {
            [MBProgressHUD showMessage:@"请输入缓存 Key"];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyTextField.text];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MBProgressHUD showMessage:@"清除成功"];
        }
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入缓存 Key";
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

// 隐藏状态栏
- (void)hideStatusBar:(NSDictionary *)params {
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
    [[NSUserDefaults standardUserDefaults] setBool:[UIApplication sharedApplication].statusBarHidden forKey:@"status_bar_hidden"];
}

// 自定义挽留弹窗
- (void)customRetentionInfo:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入自定义内容" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *titleTextField = alertController.textFields[0];
        UITextField *bodyTextField = alertController.textFields[1];
        UITextField *confirmTextField = alertController.textFields[2];
        UITextField *cancelTextField = alertController.textFields[3];
        
        weakSelf.alertInfo = [[QMRetentionAlertInfo alloc] init];
        if (titleTextField.text.length > 0) {
            weakSelf.alertInfo.messageTitle = titleTextField.text;
        }
        if (bodyTextField.text.length > 0) {
            weakSelf.alertInfo.messageBody = bodyTextField.text;
        }
        if (confirmTextField.text.length > 0) {
            weakSelf.alertInfo.confirmButtonText = confirmTextField.text;
        }
        if (cancelTextField.text.length > 0) {
            weakSelf.alertInfo.cancelButtonText = cancelTextField.text;
        }
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入弹窗标题";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入弹窗内容";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入弹窗确定标题";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入弹窗取消标题";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)setFeedCustomSize:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入信息流尺寸" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *widthTextField = alertController.textFields[0];
        UITextField *heightTextField = alertController.textFields[1];
        CGFloat widht = widthTextField.text.intValue ?: 0;
        CGFloat height = heightTextField.text.intValue ?: 0;
        weakSelf.feedSize = CGSizeMake(widht, height);
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =  @"请输入width（默认0）";
        if (weakSelf.feedSize.width > 0) {
            textField.text = [NSString stringWithFormat:@"%f", weakSelf.feedSize.width];
        }
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入height（默认0）";
        if (weakSelf.feedSize.height > 0) {
            textField.text = [NSString stringWithFormat:@"%f", weakSelf.feedSize.height];
        }
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

// 清除缓存
- (void)addCache:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入缓存 Key、Value" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (alertController.textFields.count < 2) { return; }
        
        UITextField *keyTextField = alertController.textFields[0];
        UITextField *valueTextField = alertController.textFields[1];
        
        if (keyTextField.text.length == 0) {
            [MBProgressHUD showMessage:@"请输入缓存 Key"];
            return;
        } if (valueTextField.text.length == 0) {
            [MBProgressHUD showMessage:@"请输入缓存 Value"];
            return;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:valueTextField.text forKey: keyTextField.text];
            [MBProgressHUD showMessage:@"保存成功"];
        }
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入缓存 Key";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入缓存 value";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

// MARK: - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = NSStringFromClass([UITableViewCell class]);
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *ad = self.sourceArray[indexPath.section];
    NSMutableDictionary *item = [ad[@"list"][indexPath.item] mutableCopy];
    
    NSString *actionTitle = item[@"action"];
    cell.textLabel.text = actionTitle;
    cell.detailTextLabel.text = item[@"slot"];
    cell.textLabel.textColor = UIColor.blackColor;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.detailTextLabel.textColor = UIColor.blackColor;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
    
    cell.switchControl.hidden = ![item[@"isShowSwitch"] isEqual:@(YES)];
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:actionTitle];
    cell.switchControl.on = value.boolValue;
    cell.switchValueChangedHandler = ^(BOOL isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey: actionTitle];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *ad = self.sourceArray[indexPath.section];
    NSDictionary *item = ad[@"list"][indexPath.item];
    if ([item[@"isShowSwitch"] isEqual:@(YES)]) { return; }
    PMP(self, NSSelectorFromString(item[@"SEL"]), item);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *ad = self.sourceArray[section];
    return ad[@"title"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *ad = self.sourceArray[section];
    NSArray *list = ad[@"list"];
    return list.count;
}


void PMP(NSObject *object, SEL selector, NSDictionary *param) {
    // Get method signature
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
    // Create invocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:selector];
    [invocation setTarget:object];
    
    // Set argument
    [invocation setArgument:&param atIndex:2]; // Index 0 is target, index 1 is selector
    // Invoke the method
    [invocation invoke];
}

- (BOOL)shouldAutorotate {
    return YES;
}


// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return currentVCInterfaceOrientationMask;
}


@end
