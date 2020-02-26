 

#import "YYShareView.h"
#import "YYShareButton.h"

/** 默认高度*/
static const CGFloat kSelfHeight = 200;

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface YYShareView ()
{
    // 顶部视图item数量
    NSInteger _topShareItemCount;
}

/** 分享视图*/
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, copy) void (^shareTypeblock)(YYShareViewItemType type);

@end

@implementation YYShareView

- (instancetype)initWithFrame:(CGRect)frame clickblock:(void (^)(YYShareViewItemType))shareTypeblock
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
        self.shareTypeblock = shareTypeblock;
        [self setUp];
    }
    
    return self;
}

#pragma mark - 创建UI
- (void)setUp
{
    // 背景Btn
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSelfHeight);
    [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    // 分享视图
    self.shareView = ({
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kSelfHeight)];
        shareView.backgroundColor = [UIColor clearColor];
        [self addSubview:shareView];
        shareView;
    });
    
    // 上ScrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 140)];
    topScrollView.tag = 1;
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.backgroundColor = HEXColor(0xFCFCFC);
    [self.shareView addSubview:topScrollView];
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.layer.cornerRadius = 13;
    topScrollView.clipsToBounds = YES;
    
    // 分割线
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(topScrollView.frame) + 2, kScreenWidth - 20 * 2, 5)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.shareView addSubview:lineView];
    
    // 下ScrollView
//    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 2, kScreenWidth, 126)];
//    bottomScrollView.tag = 2;
//    bottomScrollView.showsHorizontalScrollIndicator = NO;
//    bottomScrollView.backgroundColor = RGBColor(240, 240, 240);
//    [self.shareView addSubview:bottomScrollView];
    
    // 关闭Btn
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10, CGRectGetMaxY(topScrollView.frame)+5, kScreenWidth-20, 57);
    closeBtn.backgroundColor = HEXColor(0xFCFCFC);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:HEXColor(0x007AFF) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:closeBtn];
    closeBtn.layer.cornerRadius = 13;
    closeBtn.clipsToBounds = YES;
    
    // 设置数据
    [self setDataSourceWithTopScrollView   :topScrollView];
//    [self setDataSourceWithBottomScrollView:bottomScrollView];
}

#pragma mark - TopScrollView设置数据
- (void)setDataSourceWithTopScrollView:(UIScrollView *)scrollView
{
//    NSArray *imageArr1 = @[@"weixin_allshare_60x60_",
//                           @"alishq_allshare_60x60_",
//                           @"qq_allshare_60x60_",
//                           @"qqkj_allshare_60x60_",
//                           @"sina_allshare_60x60_",
//                           @"qqwb_allshare_60x60_",
//                           @"aliplay_allshare_60x60_",
//                           @"alishq_allshare_60x60_"
//                           @"airdrop_allshare_60x60_",
//                           @"copy_allshare_60x60_"
//                           ];
    
//    NSArray *titleArr1 = @[@"微信",
//                           @"朋友圈",
//                           @"QQ",
//                           @"QQ空间",
//                           @"新浪微博",
//                           @"腾讯微博",
//                           @"系统分享",
//                           @"复制链接"
//                           ];
//    NSArray *schemesA = @[@"weixin://",@"weixin://",@"mqqapi://",@"tencentapi.qzone.reqContent://",@"sinaweibo://"];
    NSMutableArray *tempA = [NSMutableArray array];
    NSMutableArray *tempB = [NSMutableArray array];
//    for (NSInteger i=0;i<schemesA.count;i++) {
//        NSString *scheme = schemesA[i];
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]){//说明此设备有安装app
//            [tempA addObject:imageArr1[i]];
//            [tempB addObject:titleArr1[i]];
//        }else{//说明此设备没有安装app
//
//        }
//    }
//    [tempA addObject:@"airdrop_allshare_60x60_"];
//    [tempA addObject:@"copy_allshare_60x60_"];
//    [tempB addObject:@"系统分享"];
//    [tempB addObject:@"复制链接"];
//    BOOL isDxMovie = [[NSUserDefaults standardUserDefaults] boolForKey:DxMovie_ToKenOn];
//    if (isDxMovie) { //是马甲
//        [tempA removeObject:@"weixin_allshare_60x60_"];
//        [tempA removeObject:@"alishq_allshare_60x60_"];
//        [tempB removeObject:@"微信"];
//        [tempB removeObject:@"朋友圈"];
//    }
    
    //自己修改
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        [tempA addObject:@"Qukan_share_qq"];//添加微信的图标
        [tempB addObject:@"QQ"];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [tempA addObject:@"Qukan_share_wechat"];//添加微信的图标
        [tempB addObject:@"微信"];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
        [tempA addObject:@"Qukan_share_wechattimeline"];//添加微信的图标
        [tempB addObject:@"朋友圈"];
    }
    
    _topShareItemCount = tempA.count;
    
    [self setScrollViewContentWithScrollView:scrollView imgArray:tempA titleArray:tempB];
}

#pragma mark - BottomScrollView设置数据
- (void)setDataSourceWithBottomScrollView:(UIScrollView *)scrollView
{
    NSArray *imgArr2   = @[@"airdrop_allshare_60x60_",
                           @"link_allshare_60x60_",
                           @"mail_allshare_60x60_",
                           @"copy_allshare_60x60_"
                           ];
    
    NSArray *titleArr2 = @[@"系统分享",
                           @"信息",
                           @"邮件",
                           @"复制链接"
                           ];
    [self setScrollViewContentWithScrollView:scrollView imgArray:imgArr2 titleArray:titleArr2];
}

#pragma mark - ScrollView设置数据
- (void)setScrollViewContentWithScrollView:(UIScrollView *)scrollView imgArray:(NSArray *)imgArray titleArray:(NSArray *)titleArray
{
    CGFloat btnW = 76;
    CGFloat btnH = 80;
    CGFloat btnX = 0;
//    CGFloat btnY = scrollView.tag == 1 ? 23 : 15;
    CGFloat btnY = 30;
    CGFloat margin = 0;
    
    CGFloat space = (scrollView.size.width - titleArray.count * btnW) / (titleArray.count + 1);
    
    for (int i = 0; i < imgArray.count; i++) {
        
        btnX = btnW * i + margin;
        
        YYShareButton *shareItem = [YYShareButton buttonWithType:UIButtonTypeCustom];
//        shareItem.frame = CGRectMake(btnX, btnY, btnW, btnH);
        shareItem.frame = CGRectMake(space * (i + 1) + i * btnW, btnY, btnW, btnH);
        [shareItem setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [shareItem setTitle:titleArray[i] forState:UIControlStateNormal];
        [shareItem addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:shareItem];
        
        if (i == imgArray.count - 1) {
            scrollView.contentSize = CGSizeMake(CGRectGetMaxX(shareItem.frame) + margin, btnH);
        }
        
        if (scrollView.tag == 1) {
            shareItem.tag = i + 1;
        }
        else {
            shareItem.tag = i + 1 + _topShareItemCount;
        }
    }
}

- (void)shareItemClick:(YYShareButton *)shareItemBtn
{
    YYShareViewItemType itemType = YYShareViewItemOther;
    NSString *titleStr = shareItemBtn.titleLabel.text;
    if ([titleStr isEqualToString:kStStatus.name]) {
        itemType = YYShareViewItemWeChat;
    }else if ([titleStr isEqualToString:@"朋友圈"]) {
        itemType = YYShareViewItemPengYouQuan;
    }else if ([titleStr isEqualToString:@"QQ"]) {
        itemType = YYShareViewItemQQ;
    }else if ([titleStr isEqualToString:@"QQ空间"]) {
        itemType = YYShareViewItemQzone;
    }else if ([titleStr isEqualToString:@"新浪微博"]) {
        itemType = YYShareViewItemWeibo;
    }else if ([titleStr isEqualToString:@"系统分享"]) {
        itemType = YYShareViewItemSystem;
    }else if ([titleStr isEqualToString:@"复制链接"]) {
        itemType = YYShareViewItemCopyLink;
    } else {
        itemType = YYShareViewItemOther;
    }
    
//    if (shareItemBtn.tag == 1) {
//        itemType = YYShareViewItemWeChat;
//    }
//    else if (shareItemBtn.tag == 2) {
//        itemType = YYShareViewItemPengYouQuan;
//    }
//    else if (shareItemBtn.tag == 3) {
//        itemType = YYShareViewItemQQ;
//    }
//    else if (shareItemBtn.tag == 4) {
//        itemType = YYShareViewItemQzone;
//    }
//    else if (shareItemBtn.tag == 5) {
//        itemType = YYShareViewItemWeibo;
//    }
//    else if (shareItemBtn.tag == 6) {
//        itemType = YYShareViewItemSystem;
//    }
//    else if (shareItemBtn.tag == 7) {
//        itemType = YYShareViewItemCopyLink;
//    }
//    else {
//        itemType = YYShareViewItemOther;
//    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectShareBtnWithType:)]) {
        [self.delegate didSelectShareBtnWithType:itemType];
        [self dismiss];
    }
    if (self.shareTypeblock) {
        self.shareTypeblock(itemType);
//        if (itemType == YYShareViewItemSystem || itemType == YYShareViewItemCopyLink) {
            [self dismiss];
//        }
    }
}

// 显示
- (void)show
{
    if (_topShareItemCount == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有可分享的平台"];
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    NSTimeInterval i     = 0;
    NSTimeInterval delay = 0;

    for (UIView *subView in self.shareView.subviews) {
        
        if ([subView isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scrollView = (UIScrollView *)subView;
            
            for (UIView *subView in scrollView.subviews) {
                if ([subView isKindOfClass:[YYShareButton class]]) {
                    if (i == 5) {
                        delay = 0;
                    }
                    delay += 0.04;
                    i += 1;
                    
                    YYShareButton *shareBtn = (YYShareButton *)subView;
                    [shareBtn shakeBtnWithDely:delay];
                }
            }
        }
    }
    
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0f;
        self.shareView.frame = CGRectMake(0, kScreenHeight - kSelfHeight - kSafeAreaBottomHeight -10, kScreenWidth, kSelfHeight);
    }];
}

// 关闭
- (void)dismiss
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kSelfHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
//    NSLog(@"%@ -- dealoc", NSStringFromClass([self class]));
}

@end
