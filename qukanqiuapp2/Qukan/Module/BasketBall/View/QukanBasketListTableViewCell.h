//
//  QukanBasketListTableViewCell.h
//  Qukan
//
//  Created by hello on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIButton *btnLeft;
@property (nonatomic, strong)UIButton *btnRight;
@property (nonatomic, strong)UILabel *labTime;
@property (nonatomic, strong)UILabel *labTimeNum;
@property (nonatomic, strong)UIButton *btnCollection;
@property (nonatomic, strong)UILabel *btnOneTeam;
@property (nonatomic, strong)UILabel *btnTwoTeam;
@property (nonatomic, strong)UIImageView *imgOne;
@property (nonatomic, strong)UIImageView *imgTwo;
@property (nonatomic, strong)UIView *view_homeTeamScore;
@property (nonatomic, strong)UIView *view_awayTeamScore;

@property (nonatomic, copy) void(^QukanHot_didBlock)(void);
@property (nonatomic, copy) void(^QukanGuanZhu_didBlock)(void);
@property (nonatomic, strong)UILabel *leagueLab;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *botView;
@property (nonatomic, strong)CAShapeLayer *timeLayer;
@property (nonatomic, strong)CAShapeLayer *collectLayer;
@property (nonatomic, strong)CAShapeLayer *leagueLayer;
@property (nonatomic, strong)CAShapeLayer *btnLeftLayer;
@property (nonatomic, strong)CAShapeLayer *btnRightLayer;

@property (nonatomic, strong)UIImageView *gif;
@property(nonatomic, strong) UIView *back_view;//四边行View

-(void)setDataWithModel:(QukanBasketBallMatchModel *)model;

@end

NS_ASSUME_NONNULL_END
