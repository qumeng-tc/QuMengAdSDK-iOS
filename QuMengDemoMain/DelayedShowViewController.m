//
//  DelayedShowViewController.m
//  QuMengAdSDK
//
//  Created by Donnie on 2025/8/8.
//

#import "DelayedShowViewController.h"

#import <Masonry/Masonry.h>

@interface DelayedShowViewController ()

@property (nonatomic, strong) UITextField *slotTextField;
@property (nonatomic, strong) UITextField *delayedTextField;
@property (nonatomic, strong) UISegmentedControl *adTypeSegmentedControl;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation DelayedShowViewController

- (UITextField *)slotTextField {
    if (!_slotTextField) {
        _slotTextField = [[UITextField alloc] init];
        _slotTextField.borderStyle = UITextBorderStyleRoundedRect;
        _slotTextField.placeholder = @"请输入栏位 ID";
        _slotTextField.text = @"9016245";
    }
    return _slotTextField;
}

- (UITextField *)delayedTextField {
    if (!_delayedTextField) {
        _delayedTextField = [[UITextField alloc] init];
        _delayedTextField.borderStyle = UITextBorderStyleRoundedRect;
        _delayedTextField.placeholder = @"请输入延迟时间（秒）";
        _delayedTextField.text = @"10";
    }
    return _delayedTextField;
}

- (UISegmentedControl *)adTypeSegmentedControl {
    if (!_adTypeSegmentedControl) {
        NSArray *items = @[@"开屏", @"插屏", @"激励视频"];
        _adTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        _adTypeSegmentedControl.selectedSegmentIndex = 0;
    }
    return _adTypeSegmentedControl;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_actionButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.backgroundColor = [UIColor systemBlueColor];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    return _actionButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"延迟显示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
}

- (void)configUI {
        
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview:self.slotTextField];
    [self.slotTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.left.mas_equalTo(strongSelf.view).offset(20);
        make.top.mas_equalTo(strongSelf.view).offset(120);
        make.right.mas_equalTo(strongSelf.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.adTypeSegmentedControl];
    [self.adTypeSegmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.left.mas_equalTo(strongSelf.view).offset(20);
        make.top.mas_equalTo(strongSelf.slotTextField.mas_bottom).offset(20);
        make.right.mas_equalTo(strongSelf.view).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.delayedTextField];
    [self.delayedTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.left.mas_equalTo(strongSelf.view).offset(20);
        make.top.mas_equalTo(strongSelf.adTypeSegmentedControl.mas_bottom).offset(20);
        make.right.mas_equalTo(strongSelf.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.actionButton];
    [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        make.left.mas_equalTo(strongSelf.view).offset(20);
        make.top.mas_equalTo(strongSelf.delayedTextField.mas_bottom).offset(20);
        make.right.mas_equalTo(strongSelf.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)startAction:(UIButton *)sender {
    
    NSString *slotId = self.slotTextField.text;
    
    NSString *adConf = @"";
    NSInteger adType = self.adTypeSegmentedControl.selectedSegmentIndex;
    if (adType == 0) {
        adConf = @"QuMengSplashAdConf";
    } else if (adType == 1) {
        adConf = @"QuMengInterstitialConf";
    } else if (adType == 2) {
        adConf = @"QuMengRewardedVideoConf";
    }
        
    NSString *delay = self.delayedTextField.text;
    
    NSDictionary *adInfo = @{
        @"delayed": delay,
        @"slot": slotId,
        @"conf": adConf
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delayed_show" object:adInfo];
    [self.navigationController popViewControllerAnimated:true];
}

@end
