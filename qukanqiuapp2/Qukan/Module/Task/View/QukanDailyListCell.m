//
//  QukanDailyListCell.m
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanDailyListCell.h"
#import "QukanTModel.h"

@interface QukanDailyListCell ()


/**主视图*/
@property(nonatomic, strong) UIView   * QukanCellContent_view;
/**左边图标*/
@property(nonatomic, strong) UIImageView   * QukanDailyIcon_img;
/**主name*/
@property(nonatomic, strong) UILabel   * QukanName_lab;
/***/
@property(nonatomic, strong) UILabel   * QukanDes_lab;
/**注释*/
@property(nonatomic, strong) UILabel   * QukanZS_lab;
/**已领取按钮*/
@property(nonatomic, strong) UIButton   * QukanLinqued_btn;
/**未领取按钮*/
@property(nonatomic, strong) UIButton   * QukanNoLinqu_btn;
/**未完成按钮*/
@property(nonatomic, strong) UIButton   * QukanNoComplet_btn;

/**线*/
@property(nonatomic, strong) UIView   * QukanLine_view;


//////不知道怎么实时改变view的圆角位置  所以创建了3个view来替换使用 。。。。
/**上方有圆角的view*/
@property(nonatomic, strong) UIView   * QukanTopRound_view;
/**下方有圆角的view*/
@property(nonatomic, strong) UIView   * QukanBottomRound_view;


@end


@implementation QukanDailyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommentBackgroudColor;
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI {
    
    [self.contentView addSubview:self.QukanBottomRound_view];
    [self.contentView addSubview:self.QukanTopRound_view];
    
    [self.contentView addSubview:self.QukanCellContent_view];
    
    [self.QukanCellContent_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.QukanTopRound_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.QukanCellContent_view);
        make.height.equalTo(@(30));
    }];
    
    [self.QukanBottomRound_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.QukanCellContent_view);
        make.height.equalTo(@(30));
    }];
    
    
    
    [self.QukanCellContent_view addSubview:self.QukanDailyIcon_img];
    [self.QukanDailyIcon_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
        make.width.height.offset(40);
    }];
    
    [self.QukanCellContent_view addSubview:self.QukanName_lab];
    [self.QukanName_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.QukanDailyIcon_img);
        make.left.mas_equalTo(self.QukanDailyIcon_img.mas_right).offset(13);
        make.height.equalTo(@(20));
    }];
    
    [self.QukanCellContent_view addSubview:self.QukanLinqued_btn];
    [self.QukanLinqued_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.QukanDailyIcon_img);
        make.width.offset(68);
        make.height.offset(24);
        make.right.offset(-15);
    }];
    
    [self.QukanCellContent_view addSubview:self.QukanNoLinqu_btn];
    [self.QukanNoLinqu_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.QukanDailyIcon_img);
        make.width.offset(68);
        make.height.offset(24);
        make.right.offset(-15);
    }];
    
    [self.QukanCellContent_view addSubview:self.QukanNoComplet_btn];
    [self.QukanNoComplet_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.QukanDailyIcon_img);
        make.width.offset(68);
        make.height.offset(24);
        make.right.offset(-15);
    }];
    
    [self.QukanCellContent_view addSubview:self.QukanDes_lab];
    [self.QukanDes_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanName_lab);
        make.top.equalTo(self.QukanName_lab.mas_bottom);
        make.height.equalTo(@(17));
        make.right.equalTo(self.QukanNoLinqu_btn.mas_left).offset(10);
    }];
    
    
    
    [self.QukanCellContent_view addSubview:self.QukanZS_lab];
    [self.QukanZS_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanDes_lab);
        make.top.equalTo(self.QukanDes_lab.mas_bottom).offset(3);
        make.height.equalTo(@(17));
    }];
    
    
    
    [self.QukanCellContent_view addSubview:self.QukanLine_view];
    [self.QukanLine_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanDailyIcon_img.mas_right);
        make.right.equalTo(self.QukanNoLinqu_btn.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self.QukanCellContent_view);
    }];
    
    
}

#pragma mark ===================== public function ==================================
- (void)fullCellWithModel:(QukanTModel *)model {
    @weakify(self);
    [[RACObserve(model, status) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL isComplet = [model.progress integerValue] >= model.qualifiedNumber;
        // 未完成按钮隐藏
        self.QukanNoComplet_btn.hidden = isComplet;
        // 领取按钮隐藏
        self.QukanLinqued_btn.hidden = !(isComplet && (model.status == 2));
        // 未领取按钮隐藏
        self.QukanNoLinqu_btn.hidden = !(isComplet && (model.status == 1));
    }];
    
//    self.QukanNoLinqu_btn = nil;
    
    self.QukanDailyIcon_img.image = kImageNamed([self getImgIconNameFromModel:model]);
    self.QukanName_lab.text = [NSString stringWithFormat:@"%@(%@/%ld)",model.name,model.progress,model.qualifiedNumber];
    
    
    
    self.QukanTopRound_view.hidden = [model.code isEqualToString:@"bing_email"];
    self.QukanBottomRound_view.hidden = [model.code isEqualToString:@"day_share"];
    
    // 设置中间的lab
    NSString *descr = model.descr;
    NSArray *descr_array = [descr componentsSeparatedByString:@"（注："];
    self.QukanDes_lab.text = descr_array.firstObject;
    if (descr_array.count > 1) {
        self.QukanZS_lab.hidden = NO;
        self.QukanZS_lab.text = [NSString stringWithFormat:@"（注：%@",descr_array.lastObject];
    }else {
        self.QukanZS_lab.hidden = YES;
    }
    
    // 设置未完成按钮的赋值
    [self.QukanNoComplet_btn setTitle:[self getActionStrFromModel:model] forState:UIControlStateNormal];
    
    if (!self.QukanNoLinqu_btn.hidden) {
        [self shakeImage];
    }
}

- (NSString *)getImgIconNameFromModel:(QukanTModel *)model {
    NSString *str = @"";
    if ([model.code isEqualToString:@"bing_email"]) {  // 绑定邮箱
        str = @"Topic_EmailIcon";
    }
    if ([model.code isEqualToString:@"publish_comment"]) {  // 发表评论
        str = @"Qukan_pubilshArticle";
    }
    if ([model.code isEqualToString:@"comment_like"]) {  // 评论点赞
        str = @"Qukan_commentAndLike";
    }
    if ([model.code isEqualToString:@"comment_hot"]) {  // 评论上热门
        str = @"Qukan_upHot";
    }
    if ([model.code isEqualToString:@"read_news"]) {  //  每日阅读文章
        str = @"Qukan_tRead";
    }
    if ([model.code isEqualToString:@"watch_live"]) {  // 每日观看视频
        str = @"Qukan_tvideo";
    }
    if ([model.code isEqualToString:@"day_share"]) {  // 每日分享
        str = @"Qukan_tShare";
    }
    return str;
}


- (NSString *)getActionStrFromModel:(QukanTModel *)model {
    
    NSString *str = @"";
    if ([model.code isEqualToString:@"bing_email"]) {  // 绑定邮箱
        str = @" 去绑定";
    }
    if ([model.code isEqualToString:@"publish_comment"]) {  // 发表评论
        str = @" 去评论";
    }
    if ([model.code isEqualToString:@"comment_like"]) {  // 评论点赞
        str = @" 去点赞";
    }
    if ([model.code isEqualToString:@"comment_hot"]) {  // 评论上热门
        str = @" 去评论";
    }
    if ([model.code isEqualToString:@"read_news"]) {  //  每日阅读文章
        str = @" 阅读文章";
    }
    if ([model.code isEqualToString:@"watch_live"]) {  // 每日观看视频
        str = @" 观看视频";
    }
    if ([model.code isEqualToString:@"day_share"]) {  // 每日分享
        str = @" 去分享";
    }
    return str;
}

#pragma mark ===================== action ==================================
// 领取按钮点击
- (void)QukanNoLinqu_btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanDailyListCellQukanNoLinqu_btnClick:)]) {
        [self.delegate QukanDailyListCellQukanNoLinqu_btnClick:self];
    }
}

// 未完成按钮点击
- (void)QukanNoComplet_btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanDailyListCellQukanNoComplet_btnClick:)]) {
        [self.delegate QukanDailyListCellQukanNoComplet_btnClick:self];
    }
}



- (void)shakeImage {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性，周期时长
    [animation setDuration:0.08];
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    self.QukanNoLinqu_btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    animation.repeatCount = 1000;
    
    // 不动的动画对象
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    [endAnimation setDuration:2];

    //创建一个动画数组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,endAnimation];

    group.repeatCount = INTMAX_MAX;
    group.duration = 3.0f;
    
    [self.QukanNoLinqu_btn.layer addAnimation:group forKey:@"animation"];
}



#pragma mark ===================== lazy ==================================
- (UIView *)QukanCellContent_view {  // 主视图
    if (!_QukanCellContent_view) {
        _QukanCellContent_view = [UIView new];
        _QukanCellContent_view.backgroundColor = kCommonWhiteColor;
        _QukanCellContent_view.layer.masksToBounds = YES;
        _QukanCellContent_view.layer.cornerRadius = 20;
    }
    return _QukanCellContent_view;
}

- (UIImageView *)QukanDailyIcon_img {  // 图标
    if (!_QukanDailyIcon_img) {
        _QukanDailyIcon_img = UIImageView.new;
        _QukanDailyIcon_img.layer.cornerRadius = 20;
        _QukanDailyIcon_img.layer.masksToBounds = YES;
        _QukanDailyIcon_img.image = kImageNamed(@"Qukan_tShare");
    }
    return _QukanDailyIcon_img;
}

- (UILabel *)QukanName_lab {
    if (!_QukanName_lab) {
        _QukanName_lab = UILabel.new;
        _QukanName_lab.textColor = kCommonTextColor;
        _QukanName_lab.font = [UIFont boldSystemFontOfSize:14];
        _QukanName_lab.text = @"绑定邮箱";
    }
    return _QukanName_lab;
}

- (UIButton *)QukanLinqued_btn {
    if (!_QukanLinqued_btn) {
        _QukanLinqued_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _QukanLinqued_btn.layer.cornerRadius = 12;
        _QukanLinqued_btn.layer.borderColor = kTextGrayColor.CGColor;
        _QukanLinqued_btn.layer.borderWidth = 1;
        _QukanLinqued_btn.backgroundColor = [UIColor whiteColor];
        [_QukanLinqued_btn setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        _QukanLinqued_btn.titleLabel.font = kFont10;
        [_QukanLinqued_btn setTitle:@"已领取" forState:UIControlStateNormal];
    }
    return _QukanLinqued_btn;
}

- (UIButton *)QukanNoLinqu_btn {
    if (!_QukanNoLinqu_btn) {
        _QukanNoLinqu_btn.hidden = YES;
        _QukanNoLinqu_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _QukanNoLinqu_btn.layer.cornerRadius = 9;
        _QukanNoLinqu_btn.layer.masksToBounds = YES;
        
        [_QukanNoLinqu_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _QukanNoLinqu_btn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [_QukanNoLinqu_btn setTitle:@" 领取" forState:UIControlStateNormal];
        [_QukanNoLinqu_btn setImage:kImageNamed(@"Qukan_dstart") forState:UIControlStateNormal];
        
        
//        _QukanNoLinqu_btn.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 48); //(24/68)
//        _QukanNoLinqu_btn.titleEdgeInsets = UIEdgeInsetsMake(3, -20, 3, 5);
        [_QukanNoLinqu_btn setBackgroundImage:kImageNamed(@"ta_lq_bg") forState:UIControlStateNormal];
        [_QukanNoLinqu_btn addTarget:self action:@selector(QukanNoLinqu_btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QukanNoLinqu_btn;
}

- (UIButton *)QukanNoComplet_btn {  // 未完成
    if (!_QukanNoComplet_btn) {
        _QukanNoComplet_btn.hidden = YES;
        _QukanNoComplet_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _QukanNoComplet_btn.layer.cornerRadius = 9;
        [_QukanNoComplet_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _QukanNoComplet_btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_QukanNoComplet_btn setTitle:@" 未完成" forState:UIControlStateNormal];
        [_QukanNoComplet_btn setImage:kImageNamed(@"Qukan_dstart") forState:UIControlStateNormal];
        
//        _QukanNoComplet_btn.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 48); //(24/68)
//        _QukanNoComplet_btn.titleEdgeInsets = UIEdgeInsetsMake(3, -20, 3, 5);
        [_QukanNoComplet_btn setBackgroundImage:kImageNamed(@"Qukan_ta_backImage") forState:UIControlStateNormal];
        
        [_QukanNoComplet_btn addTarget:self action:@selector(QukanNoComplet_btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QukanNoComplet_btn;
}


- (UILabel *)QukanDes_lab {
    if (!_QukanDes_lab) {
        _QukanDes_lab = UILabel.new;
        _QukanDes_lab.font = [UIFont systemFontOfSize:12];
        _QukanDes_lab.textColor = HEXColor(0xFCC26B);
        _QukanDes_lab.text = @"--";
    }
    return _QukanDes_lab;
}


- (UILabel *)QukanZS_lab {
    if (!_QukanZS_lab) {
        _QukanZS_lab = UILabel.new;
        _QukanZS_lab.font = [UIFont systemFontOfSize:10];
        _QukanZS_lab.textColor = kTextGrayColor;
        _QukanZS_lab.text = @"---";
    }
    return _QukanZS_lab;
}

- (UIView *)QukanLine_view {
    if (!_QukanLine_view) {
        _QukanLine_view = [UIView new];
        _QukanLine_view.backgroundColor = HEXColor(0xECEEF3);
    }
    return _QukanLine_view;
}


- (UIView *)QukanTopRound_view {
    if (!_QukanTopRound_view) {
        _QukanTopRound_view = [[UIView alloc] initWithFrame:CGRectZero];
        _QukanTopRound_view.backgroundColor = kCommonWhiteColor;
    }
    return _QukanTopRound_view;
}

- (UIView *)QukanBottomRound_view {
    if (!_QukanBottomRound_view) {
        _QukanBottomRound_view = [[UIView alloc] initWithFrame:CGRectZero];
        _QukanBottomRound_view.backgroundColor = kCommonWhiteColor;
    }
    return _QukanBottomRound_view;
}

@end
