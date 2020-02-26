//
//  QukanBasketListTableViewCell.m
//  Qukan
//
//  Created by hello on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketListTableViewCell.h"

@implementation QukanBasketListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    self.topView = [UIView new];
    self.contentView.backgroundColor = kSecondTableViewBackgroudColor;
        self.topView.backgroundColor = kSecondTableViewBackgroudColor;
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-14);
        make.top.offset(0);
        make.height.offset(30);
    }];
    
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(0, 0)];
    [timePath addLineToPoint:CGPointMake(115, 0)];
    [timePath addLineToPoint:CGPointMake(115-20, 30)];
    [timePath addArcWithCenter:CGPointMake(12, 18) radius:12 startAngle:0.5 * M_PI endAngle:M_PI clockwise:YES];
    [timePath closePath];
    
    self.timeLayer = [CAShapeLayer layer];
    self.timeLayer.path = timePath.CGPath;
    self.timeLayer.fillColor = kThemeColor.CGColor; // 默认为blackColor
    [self.topView.layer addSublayer:self.timeLayer];
    
    UIBezierPath *collectPath = [UIBezierPath bezierPath];
    [collectPath moveToPoint:CGPointMake(115, 0)];
    [collectPath addLineToPoint:CGPointMake(115+34, 0)];
    [collectPath addLineToPoint:CGPointMake(115+34-20, 30)];
    [collectPath addLineToPoint:CGPointMake(115-20, 30)];
    [collectPath closePath];
    self.collectLayer = [CAShapeLayer layer];
    self.collectLayer.path = collectPath.CGPath;
    self.collectLayer.fillColor = kCommonWhiteColor.CGColor;
    [self.topView.layer addSublayer:self.collectLayer];

    UIBezierPath *leaguePath = [UIBezierPath bezierPath];
    [leaguePath moveToPoint:CGPointMake(115+34, 0)];
    [leaguePath addLineToPoint:CGPointMake(115+34+65, 0)];
    [leaguePath addLineToPoint:CGPointMake(115+34+65-20, 30)];
    [leaguePath addLineToPoint:CGPointMake(115+34-20, 30)];
    [leaguePath closePath];
    self.leagueLayer = [CAShapeLayer layer];
    self.leagueLayer.path = leaguePath.CGPath;
    self.leagueLayer.fillColor = HEXColor(0xE8E8E8).CGColor;
    [self.topView.layer addSublayer:self.leagueLayer];

    [self.topView addSubview:self.labTimeNum];
    [self.topView addSubview:self.labTime];
    [self.topView addSubview:self.btnCollection];
    [self.topView addSubview:self.leagueLab];
    [self.labTimeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.height.offset(20);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.height.offset(20);
    }];
    [self.btnCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.offset(55);
        make.left.offset(94);
    }];
        
    [self.leagueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btnCollection.mas_right).offset(-4);
        make.width.offset(51);
        make.height.offset(14);
        make.centerY.mas_equalTo(self.btnCollection.mas_centerY).offset(0);
    }];
        
    UILabel *rightView = [UILabel new];
    [self.topView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.height.offset(20);
        make.centerY.mas_equalTo(self.topView.mas_centerY).offset(0);
        make.width.offset(50+44);
    }];
    rightView.layer.cornerRadius = 10;
    rightView.layer.masksToBounds = 1;
    
    UIBezierPath *btnLeftPath = [UIBezierPath bezierPath];
    [btnLeftPath moveToPoint:CGPointMake(0, 0)];
    [btnLeftPath addLineToPoint:CGPointMake(50, 0)];
    [btnLeftPath addLineToPoint:CGPointMake(50-6, 20)];
    [btnLeftPath addLineToPoint:CGPointMake(0, 20)];
    [btnLeftPath closePath];
    self.btnLeftLayer = [CAShapeLayer layer];
    self.btnLeftLayer.path = btnLeftPath.CGPath;
    self.btnLeftLayer.fillColor = kCommonTextColor.CGColor;
    [rightView.layer addSublayer:self.btnLeftLayer];
    
    
    UIBezierPath *btnRightPath = [UIBezierPath bezierPath];
    [btnRightPath moveToPoint:CGPointMake(50, 0)];
    [btnRightPath addLineToPoint:CGPointMake(50+44, 0)];
    [btnRightPath addLineToPoint:CGPointMake(50+44, 20)];
    [btnRightPath addLineToPoint:CGPointMake(44, 20)];
    [btnRightPath closePath];
    self.btnRightLayer = [CAShapeLayer layer];
    self.btnRightLayer.path = btnRightPath.CGPath;
    self.btnRightLayer.fillColor = kThemeColor.CGColor;
    [rightView.layer addSublayer:self.btnRightLayer];
    
    self.btnLeft = [UIButton new];
    self.btnRight = [UIButton new];
    [self.btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self.btnLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
    [self.btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self.btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
    self.btnLeft.titleLabel.font = self.btnRight.titleLabel.font = kFont10;
    [self.btnLeft setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    [self.btnRight setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    [rightView addSubview:self.btnLeft];
    [rightView addSubview:self.btnRight];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(47);
    }];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.offset(47);
    }];
    [self.contentView addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(0);
        make.height.offset(100);
    }];
    [self.contentView addSubview:self.imgOne];
    [self.imgOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.top.offset(54);
        make.width.height.offset(20);
    }];
    
    [self.contentView addSubview:self.imgTwo];
    [self.imgTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.bottom.offset(-27);
        make.width.height.offset(20);
    }];
    
    [self.contentView addSubview:self.btnOneTeam];
    [self.btnOneTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgOne.mas_centerY).offset(0);
        make.left.mas_equalTo(self.imgOne.mas_right).offset(14);
        make.height.offset(20);
        make.width.offset(120);
    }];
    
    [self.contentView addSubview:self.btnTwoTeam];
    [self.btnTwoTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgTwo.mas_centerY).offset(0);
        make.left.mas_equalTo(self.imgTwo.mas_right).offset(14);
        make.height.offset(20);
        make.width.offset(120);
    }];
    
    [self.contentView addSubview:self.view_awayTeamScore];
    [self.view_awayTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnOneTeam.mas_centerY).offset(0);
        make.left.mas_equalTo(self.btnOneTeam.mas_right).offset(8);
        make.right.offset(0);
        make.height.offset(24);
    }];
    
    [self.contentView addSubview:self.view_homeTeamScore];
    [self.view_homeTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnTwoTeam.mas_centerY).offset(0);
        make.left.mas_equalTo(self.btnTwoTeam.mas_right).offset(8);
        make.right.offset(0);
        make.height.offset(24);
    }];
//    [self.btnOneTeam.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(25);
//    }];
//
//    [self.btnTwoTeam.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(25);
//    }];
    } return self;

}


-(void)setDataWithModel:(QukanBasketBallMatchModel *)model{
    [self Qukan_setBiFenWithModel:model];
    self.leagueLab.text = model.leagueName.length ? model.leagueName : @"--";
    self.labTime.text = [NSString stringWithFormat:@"%@",model.startTime];
    self.btnOneTeam.text = [NSString stringWithFormat:@"%@",model.awayName.length > 8 ? [NSString stringWithFormat:@"%@..",[model.awayName substringToIndex:8]]: model.awayName];
    [self.imgOne sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_ke")];

    self.btnTwoTeam.text = [NSString stringWithFormat:@"%@",model.homeName.length > 8 ? [NSString stringWithFormat:@"%@..",[model.homeName substringToIndex:8]]: model.homeName];
    [self.imgTwo sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_BSK")];
    
    // 设置关注按钮状态
    [self.btnCollection setSelected:(model.attention.integerValue == 1)];
    
    self.btnRight.backgroundColor = UIColor.clearColor;
    
    self.timeLayer.fillColor = model.status > 0 ? kThemeColor.CGColor : HEXColor(0xe8e8e8).CGColor;
    //正在比赛
    if (model.status > 0) {
        
        self.labTime.hidden = 1;
        [self.btnRight setTitle:@"" forState:UIControlStateNormal];
        [self.btnRight setImage:kImageNamed(@"") forState:UIControlStateNormal];
        self.btnRight.layer.borderWidth = 0;
        
        BOOL aniSwch = [QukanTool Qukan_xuan:kQukan16];
        BOOL aniOnMatching = [model.dLive isEqualToString:@"1"];
        BOOL aniAvailable = aniSwch && aniOnMatching;//[model.dLive isEqualToString:@"1"];
        
        BOOL videoSwch = [QukanTool Qukan_xuan:kQukan14];
        BOOL videoOnMatching = model.matchLive.count > 0;
        BOOL videoAvailable = videoSwch && videoOnMatching;
        
        self.btnLeft.hidden = !(aniAvailable && videoAvailable);
        self.btnRight.hidden =!(aniAvailable || videoAvailable);
        
//        [self.btnLeft setTitle:@" 动画" forState:UIControlStateNormal];
//        [self.btnRight setTitle:@" 视频" forState:UIControlStateNormal];
//
//        [self.btnLeft setTitleColor: kCommonWhiteColor forState:UIControlStateNormal];
//        [self.btnRight setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        
        //显示两个按钮
        if(aniAvailable && videoAvailable){
            self.btnLeftLayer.fillColor = kCommonTextColor.CGColor;
            self.btnRightLayer.fillColor = kThemeColor.CGColor;
            [self.btnLeft setImage:kImageNamed(@"Qukan_animation") forState:UIControlStateNormal];
            [self.btnRight setImage:kImageNamed(@"Qukan_video") forState:UIControlStateNormal];
            [self.btnLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
                make.width.offset(47);
            }];
            [self.btnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.offset(0);
                make.width.offset(47);
            }];
            [self.btnLeft setTitle:@"动画" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"视频" forState:UIControlStateNormal];
            
            [self.btnLeft setTitleColor: kCommonWhiteColor forState:UIControlStateNormal];
            [self.btnRight setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
            
        }else if(!aniAvailable && !videoAvailable){  //显示比赛中
                self.btnRight.hidden = NO;
            self.btnLeftLayer.fillColor = kCommonTextColor.CGColor;
            self.btnRightLayer.fillColor = kCommonTextColor.CGColor;
            [self.btnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
                [self.btnRight setTitle:@" 比赛中 " forState:UIControlStateNormal];
                [self.btnRight setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
                [self.btnRight setImage:kImageNamed(@"") forState:UIControlStateNormal];

        } else if (aniAvailable || videoAvailable){//只显示一个按钮
            self.btnLeft.hidden = 1;
            NSString* imageName = aniAvailable? @"Qukan_animation":@"Qukan_video";
            [self.btnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            if (aniAvailable) {
                self.btnLeftLayer.fillColor = self.btnRightLayer.fillColor = kCommonTextColor.CGColor;
                [self.btnRight setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
            } else {
                self.btnLeftLayer.fillColor = self.btnRightLayer.fillColor = kThemeColor.CGColor;
                [self.btnRight setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
            }
            [self.btnRight setImage:kImageNamed(imageName) forState:UIControlStateNormal];
            [self.btnRight setTitle:(aniAvailable?@"动画":@"视频") forState:UIControlStateNormal];
        }
    }else{
        self.labTime.hidden = NO;
        self.btnLeft.hidden = YES;
        self.btnRight.hidden = YES;
        self.btnLeftLayer.fillColor = self.btnRightLayer.fillColor = kTextGrayColor.CGColor;
        self.btnRight.hidden = NO;
        [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        [self.btnRight setImage:kImageNamed(@"") forState:UIControlStateNormal];
        [self.btnRight setTitle:[self nameOfStatus:model.status] forState:UIControlStateNormal];
        [self.btnRight setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    }
    
    if (model.remainTime.length > 0) {
        self.labTimeNum.hidden = NO;
        self.labTimeNum.text = [NSString stringWithFormat:@"%@",model.remainTime];
    }else{
         self.labTimeNum.hidden = YES;
    }
    
    if (model.status == 5 || model.status == 6 || model.status == 7) {
        self.labTimeNum.text = model.remainTime;
    }
}

-(NSString*)nameOfStatus:(NSInteger)status{
    NSArray* statusArr = @[@" 未开赛 ", @" 已结束 ", @" 待定 ", @" 比赛中断 ", @" 取消比赛 ", @" 推迟比赛 ",@" 加时赛 "];
    if(labs(status) <= statusArr.count){
        return statusArr[labs(status)];
    }
    return @" ";
}

- (void)Qukan_setBiFenWithModel:(QukanBasketBallMatchModel *)model{
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    if (![NSString isEmptyStr:model.awayScore] && model.status != 0) {
        [arr1 addObject:model.awayScore];
    }
    
    if (![NSString isEmptyStr:model.homeScore] && model.status != 0) {
        [arr2 addObject:model.homeScore];
    }
    

    
    if (![NSString isEmptyStr:model.awayScore1]) {
        [arr1 addObject:model.awayScore1];
    }
    
    if (![NSString isEmptyStr:model.homeScore1]) {
        [arr2 addObject:model.homeScore1];
    }
    
    if (![NSString isEmptyStr:model.awayScore2 ]) {
        [arr1 addObject:model.awayScore2];
    }
    
    if (![NSString isEmptyStr: model.homeScore2]) {
        [arr2 addObject:model.homeScore2];
    }
    
    if (![NSString isEmptyStr:model.awayScore3]) {
        [arr1 addObject:model.awayScore3];
    }
    
    if (![NSString isEmptyStr:model.homeScore3]) {
        [arr2 addObject:model.homeScore3];
    }
    
    if (![NSString isEmptyStr:model.awayScore4]) {
        [arr1 addObject:model.awayScore4];
    }
    
    if (![NSString isEmptyStr:model.homeScore4]) {
        [arr2 addObject:model.homeScore4];
    }
    
    if (![NSString isEmptyStr:model.awayOtScore] && (model.status == -1|| model.status == 5 || model.status == 6 || model.status == 7)) {
        if ([model.awayOtScore intValue] > 0) {
             [arr1 addObject:model.awayOtScore];
        }
    }
    
    if (![NSString isEmptyStr:model.homeOtScore] && (model.status == -1||model.status == 5 || model.status == 6 || model.status == 7)) {
        if ([model.homeOtScore intValue] > 0) {
             [arr2 addObject:model.homeOtScore];
        }
    }
    if (arr1.count > arr2.count) {
        [arr2 addObject:@"0"];
    }
    if (arr2.count > arr1.count) {
        [arr1 addObject:@"0"];
    }
    if (model.status == 0) {
        if (arr1.count == 0) {
            [arr1 addObject:@"-"];
        }
        if (arr2.count == 0) {
            [arr2 addObject:@"-"];
        }
    }

   
    
    
    // 移除所有子视图
    [[self.view_awayTeamScore subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.view_homeTeamScore subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < arr1.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
        if (i == 0) {
            lab.frame = CGRectMake(0, 0, 30, 19);
        } else if (i <= 4) {
            lab.frame = CGRectMake(11+30 + (i-1) * 20, 0, 12, 19);
        } else {
            lab.frame = CGRectMake(11+30+3*20+20, 0, 12, 19);
        }
        lab.text = arr1[i];
        lab.font = i == 0 ? [UIFont boldSystemFontOfSize:16] : [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        if (model.status == 0) {
            lab.textColor = kCommonTextColor;
        } else if (model.status == -1) {
            lab.textColor = model.homeScore.integerValue > model.awayScore.integerValue ? COLOR_HEX(0x000000, 0.5) : kCommonTextColor;
        } else {
            lab.textColor = kCommonTextColor;
        }
        
        [self.view_awayTeamScore addSubview:lab];

        if (arr2.count > i) {
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                lab1.frame = CGRectMake(0, 0, 30, 19);
            } else if (i <= 4) {
                lab1.frame = CGRectMake(11+30 + (i-1) * 20, 0, 12, 19);
            } else {
                lab1.frame = CGRectMake(11+30+3*20+20, 0, 12, 19);
            }
            lab1.text = arr2[i];
            
            lab1.font = i == 0 ? [UIFont boldSystemFontOfSize:16] : [UIFont fontWithName:@"PingFangSC-Medium" size:10];
            if (model.status == 0) {
                lab1.textColor = kCommonTextColor;
            } else if (model.status == -1) {
                lab1.textColor = model.homeScore.integerValue < model.awayScore.integerValue ? COLOR_HEX(0x000000, 0.5) : kCommonTextColor;
            } else {
                lab1.textColor = kCommonTextColor;
            }
//            if (i == arr2.count - 1) {
//                lab1.font = kFont14;
//                lab1.textColor = kThemeColor;
//            }else {
//                lab1.font = kFont11;
//                lab1.textColor = HEXColor(0x343434);
//            }
            
            [self.view_homeTeamScore addSubview:lab1];
        }
    }
    

}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.font = [UIFont boldSystemFontOfSize:12];
    }
    return _labTime;
}
- (UILabel *)labTimeNum {
    if (!_labTimeNum) {
        _labTimeNum = [UILabel new];
        _labTimeNum.font = [UIFont boldSystemFontOfSize:12];
    }
    return _labTimeNum;
}
- (UIImageView *)imgOne {
    if (!_imgOne) {
        _imgOne = [UIImageView new];
    }
    return _imgOne;
}
- (UIImageView *)imgTwo {
    if (!_imgTwo) {
        _imgTwo = [UIImageView new];
    }
    return _imgTwo;
}
- (UILabel *)btnOneTeam {
    if (!_btnOneTeam) {
        _btnOneTeam = [UILabel new];
        _btnOneTeam.font = [UIFont boldSystemFontOfSize:14];
        _btnOneTeam.textColor = kCommonBlackColor;
        
        _btnOneTeam.numberOfLines = 0;
    }
    return _btnOneTeam;
}
- (UILabel *)btnTwoTeam {
    if (!_btnTwoTeam) {
        _btnTwoTeam = [UILabel new];
        _btnTwoTeam.font = [UIFont boldSystemFontOfSize:14];
        _btnTwoTeam.textColor = kCommonBlackColor;
        _btnTwoTeam.numberOfLines = 0;
    }
    return _btnTwoTeam;
}
- (UIButton *)btnCollection {
    if (!_btnCollection) {
        _btnCollection = [UIButton new];
        [_btnCollection setImage:[UIImage imageNamed:@"Qukan_star"] forState:UIControlStateNormal];
        [_btnCollection setImage:[UIImage imageNamed:@"Qukan_star_selected"] forState:UIControlStateSelected];
    }
    return _btnCollection;
}
- (UIView *)view_awayTeamScore {
    if (!_view_awayTeamScore) {
        _view_awayTeamScore = [UIView new];
    }
    return _view_awayTeamScore;
}
- (UIView *)view_homeTeamScore {
    if (!_view_homeTeamScore) {
        _view_homeTeamScore = [UIView new];
    }
    return _view_homeTeamScore;
}
- (UIView *)back_view {
    if (!_back_view) {
        _back_view = UIView.new;
        _back_view.layer.cornerRadius = 12;
        _back_view.backgroundColor = kCommonWhiteColor;
        _back_view.transform = affineTransformMakeShear(-0.1,0);
        _back_view.userInteractionEnabled = YES;
    }
    return _back_view;
}
- (UILabel *)leagueLab {
    if (!_leagueLab) {
        _leagueLab = [UILabel new];
        _leagueLab.textColor = kCommonTextColor;
        _leagueLab.font = kFont10;
        _leagueLab.textAlignment = NSTextAlignmentCenter;
        _leagueLab.numberOfLines = 0;
    }
    return _leagueLab;
}
static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
}
@end

