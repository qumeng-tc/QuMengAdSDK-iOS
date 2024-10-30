# 趣盟 iOS-SDK 接入文档

## SDK 最新版本下载：[趣盟 SDK(QuMengAdSDK)](https://docs.qttunion.com/ios_sdk/1.2.0/QuMengAdSDK.zip) | [趣盟 SDK(QMAdSDK)](https://docs.qttunion.com/ios_sdk/1.2.0/QMAdSDK.zip)

>  建议优先使用 QuMengAdSDK
>  QuMengAdSDK API 前缀使用 "qumeng\_"
>  QMAdSDK API 前缀使用 "qm\_"

## SDK 工程配置及初始化说明

### 自动部署

> 注意⚠️：我们建议您使用 `CocoaPods` 更轻松地管理 Xcode 项目的库依赖项，而不是直接下载并安装 SDK。SDK 的依赖项都在提供的文件中，请注意查收。

	# 推荐使用（避免缩写冲突）
	pod "QuMengAdSDK", "1.2.0"

	# 或者使用
	pod "QMAdSDK", "1.2.0"
	
### 手动部署
> 下载压缩包，将 QuMengAdSDK.xcframework 或者 QMAdSDK.xcframework 添加项目工程中即可完成手动部署。

	
### Xcode 配置

Info.plist 中 添加 `Privacy - Tracking Usage Description` 权限

	<key>NSUserTrackingUsageDescription</key>
	<string>该ID将用于向您推送个性化广告</string>

Info.plist 中加入 

	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>meituanwaimai</string>
	  	<string>openapp.jdmobile</string>
	  	<string>jdmobile</string>
	  	<string>bilibili</string>
	  	<string>pddopen</string>
	  	<string>pinduoduo</string>
	  	<string>iosamap</string>
	  	<string>freereader</string>
	  	<string>iqiyi</string>
	  	<string>tmall</string>
	  	<string>vipshop</string>
	  	<string>alipays</string>
	  	<string>OneTravel</string>
	  	<string>eleme</string>
	  	<string>sinaweibo</string>
	  	<string>youku</string>
	  	<string>imeituan</string>
	  	<string>amapuri</string>
	  	<string>baiduboxlite</string> 
	  	<string>bdboxiosqrcode</string> 
	  	<string>baidumobads</string> 
	  	<string>kwai</string>
	  	<string>snssdk1128</string>
	  	<string>weixinULAPI</string>
	  	<string>weixinulapi</string>
	  	<string>weixinURLParamsAPI</string>
	  	<string>weixin</string>
	  	<string>ctrip</string>
	  	<string>taobaotravel</string>
	  	<string>mqq</string>
	  	<string>mqqapi</string>
	  	<string>bytedance</string>
	  	<string>taobao</string>
	  	<string>tbopen</string>
	  	<string>xhsdiscover</string>
	  	<string>ksnebula</string>
	  	<string>fleamarket</string>
	  	<string>tantanapp</string>
	  	<string>txvideo</string>
	  	<string>dianping</string>
	  	<string>mdsopen</string>
	  	<string>yanxuan</string>
	  	<string>mdopen</string>
	  	<string>openanjuke</string>
	  	<string>lianjia</string>
	  	<string>soul</string>
	</array>
	
### SDK 初始化

#### 注意事项 

- `QuMengAdSDKConfiguration` 是 SDK 配置中心，可以中途修改配置
- `QuMengAdSDKManager` 是 SDK 的入口和接口中心
- 任意广告类型均不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。

#### 接入代码

	QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
	config.appId = @"应用ID";
	config.customIdfa = @"自定义IDFA";
	config.caid = @"广协CAID方案线上算法生成的CAID";
	config.caidVersion = @"广协CAID方案线上算法的版本";
	config.lastCaid = @"广协CAID方案历史算法生成的CAID";
	config.lastCaidVersion = @"广协CAID方案历史算法的版本";
	config.longitude = @"经度";
	config.latitude = @"纬度";
	// 注意⚠️：是否开启个性化推荐，开启则会获取 IDFA 默认：YES
	// 如果开启需要在 Info.plist 中 添加 `Privacy - Tracking Usage Description` 权限
	config.isEnablePersonalAds = YES;
	[QuMengAdSDKManager setupSDKWith:config];
	
## 开屏广告

### 简介

> 开屏广告使用 `QuMengSplashAd` 对象管理开屏广告所有业务。开屏广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 QuMengSplashAd 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengSplashAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_splashAd = [[QuMengSplashAd alloc] initWithSlot:slotID];
	// 广告点击强制关闭
	// _splashAd.adClickToCloseAutomatically = YES
	_splashAd.delegate = self;
	[_splashAd loadAdData];
	
广告物料加载成功后，会回调 `qumeng_splashAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd {
		// 非自定义bottom view
		[splashAd showSplashViewController:controller];
		
		// 自定义bottom view
		// UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(160, 35, 200, 30)];
		// view.text = @"欢迎接入趣盟";
		// [splashAd showSplashViewController:controller winthBottomView:view];
	}
	
### 开屏回调说明

| 方法 | 说明 |
| ----------- | ----------- |
| - (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd | 开屏广告加载成功 |
| - (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError * _Nullable)error | 开屏广告加载失败 |
| - (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd | 开屏广告曝光 |
| - (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd | 开屏广告点击 |
| - (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(enum QuMengSplashAdCloseType)type | 开屏广告关闭 |
| - (void)qumeng_splashAdVideoDidPlayFinished:(QuMengSplashAd *)splashAd didFailWithError:(NSError *)error | 开屏广告视频播放结束回调 |

## 插屏广告

### 简介

> 插屏广告使用 `QuMengInterstitialAd` 对象管理插屏广告所有业务。插屏广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 `QuMengInterstitialAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengInterstitialAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_intertitialAd = [[QuMengInterstitialAd alloc] initWithSlot:slotID];
	_intertitialAd.adClickToCloseAutomatically = YES
	_intertitialAd.delegate = self;
	[_intertitialAd loadAdData];
	
广告物料加载成功后，会回调 `qumeng_interstitialAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd {
		[intertitialAd showInterstitialViewInRootViewController:controller];
	}
	
### 插屏回调说明

| 方法 | 说明 |
| ----------- | ----------- |
| - (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd | 插屏广告加载成功 |
| - (void)qumeng_interstitialAdLoadFail:(QuMengInterstitialAd *)interstitialAd error:(NSError *)error | 插屏广告加载失败 |
| - (void)qumeng_interstitialAdDidShow:(QuMengInterstitialAd *)interstitialAd | 插屏广告曝光 |
| - (void)qumeng_interstitialAdDidClick:(QuMengInterstitialAd *)interstitialAd | 插屏广告点击 |
| - (void)qumeng_interstitialAdDidClose:(QuMengInterstitialAd *)interstitialAd closeType:(enum QuMengInterstitialAdCloseType)type | 插屏广告关闭 |
| - (void)qumeng_interstitialAdDidCloseOtherController:(QuMengInterstitialAd *)interstitialAd | 插屏广告落地页关闭 |
| - (void)qumeng_interstitialAdDidStart:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放开始 |
| - (void)qumeng_interstitialAdDidPause:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放暂停 |
| - (void)qumeng_interstitialAdDidResume:(QuMengInterstitialAd *)rewardedVideoAd | 插屏广告视频播放继续 |
| - (void)qumeng_interstitialAdVideoDidPlayComplection:(QuMengInterstitialAd *)interstitialAd | 插屏广告视频播放完成 |
| - (void)qumeng_interstitialAdVideoDidPlayFinished:(QuMengInterstitialAd *)interstitialAd didFailWithError:(NSError *)error | 插屏广告视频播放异常 |

## 激励视频广告

### 简介

> 激励视频广告使用 `QuMengRewardedVideoAd` 对象管理插屏广告所有业务。激励视频广告所有视图的展示和移除将由 SDK 统一管理，开发者无需关心。
> 接入方式上，使用 `QuMengRewardedVideoAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengRewardedVideoAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_rewardedVideoAd = [[QuMengRewardedVideoAd alloc] initWithSlot:slotID];
	_rewardedVideoAd.adClickToCloseAutomatically = YES
	_rewardedVideoAd.delegate = self;
	[_rewardedVideoAd loadAdData];
	
广告物料加载成功后，会回调 `qumeng_rewardedVideoAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd {
		[rewardedVideoAd showRewardedVideoViewInRootViewController:controller];
	}
	
### 激励视频回调说明

| 方法 | 说明 |
| ----------- | ----------- |
| - (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告加载成功 |
| - (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error | 激励视频广告加载失败 |
| - (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告曝光 |
| - (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告点击 |
| - (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(enum QuMengRewardedVideoAdCloseType)type | 激励视频广告关闭 |
| - (void)qumeng_rewardedVideoAdDidCloseOtherController:(QuMengRewardedVideoAd *)rewardedVideoAd | 落地页关闭 |
| - (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告激励完成 |
| - (void)qumeng_rewardedVideoAdDidStart:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放开始 |
| - (void)qumeng_rewardedVideoAdDidPause:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放暂停 |
| - (void)qumeng_rewardedVideoAdDidResume:(QuMengRewardedVideoAd *)rewardedVideoAd | 激励视频广告播放继续 |
| - (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded | 激励视频广告视频播放完成 |
| - (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded | 激励视频广告视频播放结束 |

## 信息流广告

### 简介

> 信息流广告使用 `QuMengFeedAd` 对象管理插屏广告所有业务。 接入方式上，使用 `QuMengFeedAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengFeedAdDelegate` 代理，获取广告加载、渲染、点击、关闭、跳转等回调。

### 接入代码

广告位对象创建时必须传入广告位ID

	_feedAd = [[QuMengFeedAd alloc] initWithSlot:slotID];
	/// 自定义信息流size
	_feedAd.customSize = CGSizeMake(320, 200);
	_feedAd.delegate = self;
	[_feedAd loadAdData];
	
广告物料加载成功后，会回调 `qumeng_feedAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd {
		UIView *adView = [self.adView viewWithTag:1000];
		[adView removeFromSuperview];
		feedAd.feedView.tag = 1000;
		[self.adView addSubview:feedAd.feedView];
		CGRect frame = self.adView.frame;
		frame.size.height = [feedAd handleFeedAdHeight];
		self.adView.frame = frame;
	}
	
### 信息流回调说明

| 方法 | 说明 |
| ----------- | ----------- |
| - (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd | 信息流广告加载成功 |
| - (void)qumeng_feedAdLoadFail:(QuMengFeedAd *)feedAd error:(NSError *)error | 信息流广告加载失败 |
| - (void)qumeng_feedAdDidShow:(QuMengFeedAd *)feedAd | 信息流广告曝光 |
| - (void)qumeng_feedAdDidClick:(QuMengFeedAd *)feedAd | 信息流广告点击 |
| - (void)qumeng_feedAdDidClose:(QuMengFeedAd *)feedAd | 信息流广告关闭 |
| - (void)qumeng_feedAdDidCloseOtherController:(QuMengFeedAd *)feedAd | 信息流落地页关闭 |
| - (void)qumeng_feedAdDidStart:(QuMengFeedAd *)feedAd | 信息流视频播放开始 |
| - (void)qumeng_feedAdDidPause:(QuMengFeedAd *)feedAd | 信息流视频播放暂停 |
| - (void)qumeng_feedAdDidResume:(QuMengFeedAd *)feedAd | 信息流视频播放继续 |
| - (void)qumeng_feedAdVideoDidPlayComplection:(QuMengFeedAd *)feedAd | 信息流视频播放完成 |
| - (void)qumeng_feedAdVideoDidPlayFinished:(QuMengFeedAd *)feedAd didFailWithError:(NSError *)error | 信息流视频播放异常 |

## 媒体自渲染广告

### 简介

> 媒体自渲染广告使用 `QuMengNativeAd` 对象管理插屏广告所有业务。
> 接入方式上，使用 `QuMengNativeAd` 对象调用 `loadAdData` 方法请求广告，调用 `show` 方法展示广告，通过设置 `QuMengNativeAdDelegate` 代理，获取广告加载、渲染、点击、跳转等回调。
> 自渲染广告需要调用 `registerContainer:withClickableViews:` 方法，否则回调无法触发

### 接入代码

广告位对象创建时必须传入广告位ID

	_nativeAd = [[QuMengNativeAd alloc] initWithSlot:slotID];
	_nativeAd.delegate = self;
	[_nativeAd loadAdData];
	
广告物料加载成功后，会回调 `qumeng_nativeAdLoadSuccess` 方法，在此处展示开屏广告

	- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd {
		self.relatedView = [QuMengNativeAdRelatedView new];
		[self.relatedView refreshData:nativeAd];
		[self.contentView addSubview:self.relatedView.videoAdView];
		self.relatedView.videoAdView.frame = self.contentView.frame;
		[nativeAd registerContainer:self.contentView withClickableViews:@[self.actionBtn, self.titleLab]];
	}
	
### 媒体自渲染回调说明

| 方法                                                                      | 说明             |
| ------------------------------------------------------------------------- | ---------------- |
| - (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd                     | 广告素材加载成功 |
| - (void)qumeng_nativeAdLoadFail:(QuMengNativeAd *)nativeAd error:(NSError *)error | 广告素材加载失败 |
| - (void)qumeng_nativeAdDidShow:(QuMengNativeAd *)nativeAd                         | 广告展示         |
| - (void)qumeng_nativeAdDidClick:(QuMengNativeAd *)nativeAd                        | 广告点击         |
| - (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd *)nativeAd         | 广告落地页关闭   |

## TopOn聚合平台自定义广告接入文档

### 简介

> Topon自定义广告接入地址：[https://help.takuad.com](https://help.takuad.com)

### 接入方式

将 QMTopOnSDK.xcframework 集成到项目中

或者使用 `CocoaPods` 集成

	pod "QMTopOnSDK", path: "../QMTopOnSDK"

| 广告类型 | 广告类名称            | 服务器配置参数                                                                                         |
| -------- | --------------------- | ------------------------------------------------------------------------------------------------------ |
| 激励视频 | QMRewardVideoAdapter  | "slot\_id" // 广告栏位                                                                                 |
| 插屏     | QuMengInterstitialAdapter | "slot\_id" // 广告栏位                                                                                 |
| 原生     | QMNativeAdapter       | "slot\_id"// 广告栏位<br>"draw\_feed": "1"// 渲染方式-模板渲染"<br>"draw\_feed": "0"// 渲染方式-自渲染 |
| 开屏     | QuMengSplashAdapter       | "slot\_id" // 广告栏位                                                                 |

## 接口说明

| 方法名 | 说明 | 备注 |
| -------- | -------- | -------- | 
| getRequestId | 广告唯一id  |  |
| getIdeaId | 创意ID  |  |
| getECPM | 广告价格 | 单位分 |
| getTitle | 广告标题  |  |
| getDesc | 广告副标题  |  |
| getLandingPageUrl | 落地页地址  |  |
| getInteractionType | 广告交互类型 | 1：落地页类型 <br> 2：下载类型（包含拉新和拉活）<br> 3：小程序<br>4：快应用 |
| getImageUrls | 广告图片链接  | 物料地址 |
| getAppLogoUrl | 广告创意logo  |  |
| getAppName | 广告创意应用名称  |  |
| getAppPackageName | 广告创意包名 |  |
| getAppInformation | 广告六要素信息 | 一般用于下载合规外显，信息包括应用版本、开发者信息、隐私协议链接、应用权限链接、应用功能链接 |
| getMediaSize | 素材宽高 | 图片或者视频的宽高 |
| getMaterialType | 广告物料的类型 | 1：小图<br>2：大图<br>3：组图<br>4：视频<br>6：开屏<br>12：激励视频 |
| getVideoDuration | 视频播放时长 |  |

## 错误码

| 错误码 | 说明 | 备注 |
| ------ | ---------- | --------------------------------------------------------------- |
| 100001 | 无填充，没有合适广告返回导致的，偶现属于正常情况 | "reason": 100 此次出价未过底价（固价未过栏位底价）<br>"reason": 101 请求频率过高，建议：避免同一时间内高频拉取广告<br>"reason": 102 没有合适广告返回，检查流量提高用户质量，注：在开发测试阶段，可以添加设备或更换设备解决，如果还未填充可以联系运营<br>"reason": 103 命中平台策略导致的无填充，如果开发测试阶段可以联系运营反馈<br>"reason": 104 命中检索204策略导致的无填充，如果开发测试阶段可以联系运营反馈<br>"reason": -1 其它异常 |
| 100002 | 服务器错误                                       | "reason":201 检索服务器异常                                                                                                                                                                                                                                                                                                                                                                                                              |
| 100003 | 请求失败                                         | "reason":301 请求体解析失败                                                                                                                                                                                                                                                                                                                                                                                                              |
| 100004 | 代码位不合法                                     | "reason":401 检查代码位ID是否传入空字符串或特殊字符，注：新建的代码位需要10分钟左右的生效时间                                                                                                                                                                                                                                                                                                                                            |
| 100005 | 请求包名与媒体包名不一致                         | "reason": 501 实际发起的包名和媒体的包名是否一致，注：如果媒体是通过趣盟运营创建的可以联系趣盟运营协同排查                                                                                                                                                                                                                                                                                                                               |
| 100006 | 广告请求代码位类型不匹配                         | "reason":601 例如开屏代码位使用的的激励视频方法                                                                                                                                                                                                                                                                                                                                                                                          |
| 200001 | 代码位不能为空                                   | 检查设置代码位ID是否为空                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 200002 | 无填充                                           | 命中平台策略导致的无填充，如果开发测试阶段可以联系运营反馈                                                                                                                                                                                                                                                                                                                                                                               |
| 200003 | 网络错误                                         | 网络链接异常                                                                                                                                                                                                                                                                                                                                                                                                                             |

## SDK版本发布记录

| 版本号 | 日期 | 备注 |
| ------ | ---------- | --------------------------------------------------------------- |
| 1.2.0  | 2024.10.30 | 【新增】信息流模版渲染支持自定义尺寸<br>【新增】视频类物料支持事件回调<br>【新增】支持POD远程化<br>【优化】广告链路适配新预算<br>【修复】已知问题                      |
| 1.1.0  | 2024.10.12 | 【修复】已知问题  <br> 【优化】SDK性能优化                      |
| 1.0.9  | 2024.09.20 | 【修复】已知问题                                                |
| 1.0.7  | 2024.09.4  | 【新增】topon适配器<br>【优化】广告交互链路<br>【修复】已知问题 |
| 1.0.6  | 2024.08.23 | 【修复】已知问题                                                |
| 1.0.5  | 2024.08.13 | 【优化】适配电商预算<br>【修复】链路上报异常问题                |
| 1.0.4  | 2024.07.29 | 【优化】广告交互链路<br>【修复】已知问题导致的Crash             |
| 1.0.3  | 2024.05.29 | 【新增】支持横版应用广告<br>【修复】已知问题导致的崩溃          |
| 1.0.0  | 2024.02.21 | 【新增】开屏、激励视频、插屏、信息流、自渲染                    |



