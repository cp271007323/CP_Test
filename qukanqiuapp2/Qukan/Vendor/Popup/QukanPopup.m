//
//  QukanPopup.m
//  QukanPopupExample
//
//  Created by zhuxiaohui on 2016/6/13.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import "QukanPopup.h"
#import "QukanPopupView.h"
#import "QukanPopupImageView+QukanPopupCache.h"
#import "QukanPopupImageLoader.h"
#import "QukanPopupCache.h"
#import "FLAnimatedImage.h"
#import "QukanPopupController.h"

typedef NS_ENUM(NSInteger, QukanPopupType) {
    QukanPopupTypeImage,
};

static NSInteger defaultWaitDataDuration = 3;
static  SourceType _sourceType = SourceTypeLaunchImage;
@interface QukanPopup()

@property(nonatomic,assign)QukanPopupType lanuchPageType;
@property(nonatomic,assign)NSInteger waitDataDuration;
@property(nonatomic,strong)XHLaunchImageLoadConfiguration * imageAdConfiguration;
@property(nonatomic,strong)QukanPopupButton * skipButton;
//@property(nonatomic,strong)QukanPopupVideoView * adVideoView;
@property(nonatomic,strong)UIWindow * window;
@property(nonatomic,copy)dispatch_source_t waitDataTimer;
@property(nonatomic,copy)dispatch_source_t skipTimer;
@property (nonatomic, assign) BOOL detailPageShowing;
@property(nonatomic,assign) CGPoint clickPoint;
@end

@implementation QukanPopup
+(void)setLaunchSourceType:(SourceType)sourceType{
    _sourceType = sourceType;
}
+(void)setWaitDataDuration:(NSInteger )waitDataDuration{
    QukanPopup *lanPopup = [QukanPopup shareLauPopup];
    lanPopup.waitDataDuration = waitDataDuration;
}
+(QukanPopup *)imageWithImageConfiguration:(XHLaunchImageLoadConfiguration *)imageAdconfiguration{
    return [QukanPopup imageWithImageConfiguration:imageAdconfiguration delegate:nil];
}

+(QukanPopup *)imageWithImageConfiguration:(XHLaunchImageLoadConfiguration *)imageAdconfiguration delegate:(id)delegate{
    QukanPopup *lanPopup = [QukanPopup shareLauPopup];
    if(delegate) lanPopup.delegate = delegate;
    lanPopup.imageAdConfiguration = imageAdconfiguration;
    return lanPopup;
}


+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadImageAndCacheWithURLArray:urlArray completed:nil];
}

+ (void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable QukanPopupBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[QukanPopupImageLoader sharedDownloader] downLoadImageAndCacheWithURLArray:urlArray completed:completedBlock];
}

+(void)removeAndAnimated:(BOOL)animated{
    [[QukanPopup shareLauPopup] removeAndAnimated:animated];
}

+(BOOL)checkImageInCacheWithURL:(NSURL *)url{
    return [QukanPopupCache checkImageInCacheWithURL:url];
}

//+(BOOL)checkVideoInCacheWithURL:(NSURL *)url{
//    return [QukanPopupCache checkVideoInCacheWithURL:url];
//}
+(void)clearDiskCache{
    [QukanPopupCache clearDiskCache];
}

+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray{
    [QukanPopupCache clearDiskCacheWithImageUrlArray:imageUrlArray];
}

+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray{
    [QukanPopupCache clearDiskCacheExceptImageUrlArray:exceptImageUrlArray];
}

//+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
//    [QukanPopupCache clearDiskCacheWithVideoUrlArray:videoUrlArray];
//}
//
//+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
//    [QukanPopupCache clearDiskCacheExceptVideoUrlArray:exceptVideoUrlArray];
//}

+(float)diskCacheSize{
    return [QukanPopupCache diskCacheSize];
}

+(NSString *)JiuAilaunchCachePath{
    return [QukanPopupCache JiuAilaunchCachePath];
}

+(NSString *)cacheImageURLString{
    return [QukanPopupCache getCacheImageUrl];
}

//+(NSString *)cacheVideoURLString{
//    return [QukanPopupCache getCacheVideoUrl];
//}

#pragma mark - 过期
/** 请使用removeAndAnimated: */
+(void)skipAction{
    [[QukanPopup shareLauPopup] removeAndAnimated:YES];
}
/** 请使用setLaunchSourceType: */
+(void)setLaunchImagesSource:(LaunchImagesSource)launchImagesSource{
    switch (launchImagesSource) {
        case LaunchImagesSourceLaunchImage:
            _sourceType = SourceTypeLaunchImage;
            break;
        case LaunchImagesSourceLaunchScreen:
            _sourceType = SourceTypeLaunchScreen;
            break;
        default:
            break;
    }
}

#pragma mark - private
+(QukanPopup *)shareLauPopup{
    static QukanPopup *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[QukanPopup alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        XHWeakSelf
        [self setupLPage];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setupLanuchPageEnterForeground];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self removeOnly];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:QukanPopupDetailPageWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = YES;
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:QukanPopupDetailPageShowFinishNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = NO;
        }];
    }
    return self;
}

-(void)setupLanuchPageEnterForeground{
    switch (_lanuchPageType) {
        case QukanPopupTypeImage:{
            if(!_imageAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLPage];
            [self setupImageAdForConfiguration:_imageAdConfiguration];
        }
            break;
        default:
            break;
    }
}

-(void)setupLPage{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [QukanPopupController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    window.windowLevel = UIWindowLevelStatusBar + 1;
    window.hidden = NO;
    window.alpha = 1;
    _window = window;
    /** 添加launchImageView */
    [_window addSubview:[[XHLaunchImageView alloc] initWithSourceType:_sourceType]];
}

/**图片*/
-(void)setupImageAdForConfiguration:(XHLaunchImageLoadConfiguration *)configuration{
    if(_window == nil) return;
    [self removeSubViewsExceptLanuchPageImageView];
    QukanPopupImageView *adImageView = [[QukanPopupImageView alloc] init];
    [_window addSubview:adImageView];
    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) adImageView.frame = configuration.frame;
    if(configuration.contentMode) adImageView.contentMode = configuration.contentMode;
    /** webImage */
    if(configuration.imageNameOrURLString.length && XHISURLString(configuration.imageNameOrURLString)){
        [QukanPopupCache async_saveImageUrl:configuration.imageNameOrURLString];
        /** 自设图片 */
        if ([self.delegate respondsToSelector:@selector(QukanPopup:lanuchPageImageView:URL:)]) {
            [self.delegate QukanPopup:self lanuchPageImageView:adImageView URL:[NSURL URLWithString:configuration.imageNameOrURLString]];
        }else{
            if(!configuration.imageOption) configuration.imageOption = QukanPopupImageDefault;
            XHWeakSelf
            [adImageView xh_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString] placeholderImage:nil GIFImageCycleOnce:configuration.GIFImageCycleOnce options:configuration.imageOption GIFImageCycleOnceFinish:^{
                //GIF不循环,播放完成
                [[NSNotificationCenter defaultCenter] postNotificationName:QukanPopupGIFImageCycleOnceFinishNotification object:nil userInfo:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                
            } completed:^(UIImage *image,NSData *imageData,NSError *error,NSURL *url){
                if(!error){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                    if ([weakSelf.delegate respondsToSelector:@selector(QukanPopup:imageDownLoadFinish:)]) {
                        [weakSelf.delegate QukanPopup:self imageDownLoadFinish:image];
                    }
#pragma clang diagnostic pop
                    if ([weakSelf.delegate respondsToSelector:@selector(QukanPopup:imageDownLoadFinish:imageData:)]) {
                        [weakSelf.delegate QukanPopup:self imageDownLoadFinish:image imageData:imageData];
                    }
                }
            }];
            if(configuration.imageOption == QukanPopupImageCacheInBackground){
                /** 缓存中未有 */
                if(![QukanPopupCache checkImageInCacheWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]]){
                    [self removeAndAnimateDefault]; return; /** 完成显示 */
                }
            }
        }
    }else{
        if(configuration.imageNameOrURLString.length){
            NSData *data = XHDataWithFileName(configuration.imageNameOrURLString);
            if(XHISGIFTypeWithData(data)){
                FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
                adImageView.animatedImage = image;
                adImageView.image = nil;
                __weak typeof(adImageView) w_adImageView = adImageView;
                adImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(configuration.GIFImageCycleOnce){
                        [w_adImageView stopAnimating];
                        QukanPopupLog(@"GIF不循环,播放完成");
                        [[NSNotificationCenter defaultCenter] postNotificationName:QukanPopupGIFImageCycleOnceFinishNotification object:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                    }
                };
            }else{
                adImageView.animatedImage = nil;
                adImageView.image = [UIImage imageWithData:data];
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            if ([self.delegate respondsToSelector:@selector(QukanPopup:imageDownLoadFinish:)]) {
                [self.delegate QukanPopup:self imageDownLoadFinish:[UIImage imageWithData:data]];
            }
#pragma clang diagnostic pop
        }else{
            QukanPopupLog(@"未设置广告图片");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    XHWeakSelf
    adImageView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

-(void)addSkipButtonForConfiguration:(QukanPopupConfiguration *)configuration{
    if(!configuration.duration) configuration.duration = 5;
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;
    if(configuration.customSkipView){
        [_window addSubview:configuration.customSkipView];
    }else{
        if(_skipButton == nil){
            _skipButton = [[QukanPopupButton alloc] initWithSkipType:configuration.skipButtonType];
            _skipButton.hidden = YES;
            [_skipButton addTarget:self action:@selector(skipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_window addSubview:_skipButton];
        [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:configuration.duration];
    }
}


#pragma mark - add subViews
-(void)addSubViews:(NSArray *)subViews{
    [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [_window addSubview:view];
    }];
}

#pragma mark - set
-(void)setImageAdConfiguration:(XHLaunchImageLoadConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    _lanuchPageType = QukanPopupTypeImage;
    [self setupImageAdForConfiguration:imageAdConfiguration];
}

-(void)setWaitDataDuration:(NSInteger)waitDataDuration{
    _waitDataDuration = waitDataDuration;
    /** 数据等待 */
    [self startWaitDataDispathTiemr];
}

#pragma mark - Action
-(void)skipButtonClick:(QukanPopupButton *)button{
    if ([self.delegate respondsToSelector:@selector(QukanPopup:clickSkipButton:)]) {
        [self.delegate QukanPopup:self clickSkipButton:button];
    }
    [self removeAndAnimated:YES];
}

-(void)removeAndAnimated:(BOOL)animated{
    if(animated){
        [self removeAndAnimate];
    }else{
        [self remove];
    }
}

-(void)clickAndPoint:(CGPoint)point{
    self.clickPoint = point;
    QukanPopupConfiguration * configuration = [self commonConfiguration];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(QukanPopup:clickAndOpenURLString:)]) {
        [self.delegate QukanPopup:self clickAndOpenURLString:configuration.openURLString];
        [self removeAndAnimateDefault];
    }
    if ([self.delegate respondsToSelector:@selector(QukanPopup:clickAndOpenURLString:clickPoint:)]) {
        [self.delegate QukanPopup:self clickAndOpenURLString:configuration.openURLString clickPoint:point];
        [self removeAndAnimateDefault];
    }
    if ([self.delegate respondsToSelector:@selector(QukanPopup:clickAndOpenModel:clickPoint:)]) {
        [self.delegate QukanPopup:self clickAndOpenModel:configuration.openModel clickPoint:point];
        [self removeAndAnimateDefault];
    }
#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(QukanPopup:clickAtOpenModel:clickPoint:)]) {
        BOOL status =  [self.delegate QukanPopup:self clickAtOpenModel:configuration.openModel clickPoint:point];
        if(status) [self removeAndAnimateDefault];
    }
}

-(QukanPopupConfiguration *)commonConfiguration{
    QukanPopupConfiguration *configuration = nil;
    switch (_lanuchPageType) {
        case QukanPopupTypeImage:
            configuration = _imageAdConfiguration;
            break;
        default:
            break;
    }
    return configuration;
}

-(void)startWaitDataDispathTiemr{
    __block NSInteger duration = defaultWaitDataDuration;
    if(_waitDataDuration) duration = _waitDataDuration;
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_waitDataTimer, ^{
        if(duration==0){
            DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:QukanPopupWaitDataDurationArriveNotification object:nil];
                [self remove];
                return ;
            });
        }
        duration--;
    });
    dispatch_resume(_waitDataTimer);
}

-(void)startSkipDispathTimer{
    QukanPopupConfiguration * configuration = [self commonConfiguration];
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;//默认
    __block NSInteger duration = 5;//默认
    if(configuration.duration) duration = configuration.duration;
    if(configuration.skipButtonType == SkipTypeRoundProgressTime || configuration.skipButtonType == SkipTypeRoundProgressText){
        [_skipButton startRoundDispathTimerWithDuration:duration];
    }
    NSTimeInterval period = 1.0;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    @weakify(self)
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(QukanPopup:customSkipView:duration:)]) {
                [self.delegate QukanPopup:self customSkipView:configuration.customSkipView duration:duration];
            }
            if(!configuration.customSkipView){
                [self.skipButton setTitleWithSkipType:configuration.skipButtonType duration:duration];
            }
            if(duration==0){
                DISPATCH_SOURCE_CANCEL_SAFE(self.skipTimer);
                [self removeAndAnimate]; return ;
            }
            duration--;
        });
    });
    dispatch_resume(_skipTimer);
}

-(void)removeAndAnimate{
    
    QukanPopupConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    switch (configuration.showFinishAnimate) {
        case ShowFinishAnimateNone:{
            [self remove];
        }
            break;
        case ShowFinishAnimateFadein:{
            [self removeAndAnimateDefault];
        }
            break;
        case ShowFinishAnimateLite:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                _window.transform = CGAffineTransformMakeScale(1.5, 1.5);
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromLeft:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromBottom:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateCurlUp:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        default:{
            [self removeAndAnimateDefault];
        }
            break;
    }
}

-(void)removeAndAnimateDefault{
    QukanPopupConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionNone animations:^{
        _window.alpha = 0;
    } completion:^(BOOL finished) {
        [self remove];
    }];
}
-(void)removeOnly{
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer)
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer)
    REMOVE_FROM_SUPERVIEW_SAFE(_skipButton)
    if(_window){
        [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }];
        _window.hidden = YES;
        _window = nil;
    }
}

-(void)remove{
    [self removeOnly];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(xhLaunchShowFinish:)]) {
        [self.delegate xhLaunchShowFinish:self];
    }
#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(JiuAilaunchShowFinish:)]) {
        [self.delegate JiuAilaunchShowFinish:self];
    }
}

-(void)removeSubViewsExceptLanuchPageImageView{
    [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[XHLaunchImageView class]]){
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
