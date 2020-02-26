
@interface QukanHomeRefreshHeader ()
@property (weak,nonatomic) UIImageView * logoView;
@property (weak,nonatomic) QukanctivityIndicatorView * loadingView;
@property (weak,nonatomic) UILabel * textLabel;
@end
@implementation QukanHomeRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置
-(void)prepare{
    [super prepare];
    self.mj_h = 74;
    UIImageView * logoView = [[UIImageView alloc]init];
    logoView.image = [UIImage imageNamed:@"Qukan_refresh_logo"];
    self.logoView = logoView;
    [self addSubview:logoView];
    self.logoView.hidden = YES;
    QukanctivityIndicatorView * loadingView = [[QukanctivityIndicatorView alloc]initWithType:QukanctivityIndicatorAnimationTypeTwoDots tintColor:kThemeColor size:18];
    self.loadingView = loadingView;
    [self addSubview:loadingView];
    UILabel * textLabel = [[UILabel alloc]init];
    textLabel.textColor = kThemeColor;
    textLabel.font = [UIFont boldSystemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel = textLabel;
//    [self addSubview:textLabel];
}
#pragma mark - 设置子控件的位置和尺寸
-(void)placeSubviews{
    [super placeSubviews];
    self.logoView.frame = CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds])-27)/2, 10, 27.0, 27.0);
    self.loadingView.frame = CGRectMake(0.0, 0.0, 100.0, 20.0);
    self.textLabel.frame = CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds])-100.0)/2.0, 30.0, 100.0, 24.0);
    self.loadingView.center = CGPointMake(self.center.x, self.center.y+75);
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}
#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}
#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
//            [self.loadingView stopAnimating];
            self.textLabel.text = @"下拉即可刷新";
            break;
        case MJRefreshStatePulling:
//            [self.loadingView stopAnimating];
            self.textLabel.text = @"释放即可刷新";
            break;
        case MJRefreshStateRefreshing:
            self.textLabel.text = @"努力加载中...";
            [self.loadingView startAnimating];
            break;
        default:
            break;
    }
}
@end
