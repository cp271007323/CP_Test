//
//  QukanMatchStatisticsCell.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchStatisticsCell.h"
#import "QukanMatchStatisticeListView.h"

#import "QukanBasketLineImgView.h"


@interface QukanMatchStatisticsCell ()

@property(nonatomic, strong) UILabel   * lab_title;
@property(nonatomic, strong) QukanMatchStatisticeListView    * view_bg1;
@property(nonatomic, strong) QukanMatchStatisticeListView    * view_bg2;
@property(nonatomic, strong) QukanMatchStatisticeListView    * view_bg3;

//@property(nonatomic, strong) QukanBasketLineImgView   * view_lineImg;
@property (nonatomic,assign) NSInteger recordHomeScore;
@property (nonatomic,assign) NSInteger recordGuestScore;

@end



@implementation QukanMatchStatisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark ===================== initUI ==================================
- (void)initUI {
    self.lab_title.frame = CGRectMake(10, 10, 60, 0);
    self.view_bg1.frame = CGRectMake(0, CGRectGetMaxY(self.lab_title.frame) + 0, kScreenWidth, itemHeight);
    self.view_bg2.frame = CGRectMake(0, CGRectGetMaxY(self.lab_title.frame) + 0 + itemHeight + 1, kScreenWidth, itemHeight);
    self.view_bg3.frame = CGRectMake(0, CGRectGetMaxY(self.lab_title.frame) + 0 + itemHeight * 2 + 2, kScreenWidth, itemHeight);
//    self.view_lineImg.frame = CGRectMake(0, 140, kScreenWidth, 180);
}


- (void)fullCellWithData:(QukanBasketBallMatchDetailModel *)detailModel {
    if (self.recordHomeScore == detailModel.homeScore.integerValue && self.recordGuestScore == detailModel.guestScore.integerValue) {
        if (self.recordHomeScore != 0 || self.recordGuestScore !=0) {
            return;
        }
    }
    self.recordHomeScore = detailModel.homeScore.integerValue;
    self.recordGuestScore = detailModel.guestScore.integerValue;
    BOOL isJiaShi = NO;
    if (detailModel.status.integerValue == 5 || detailModel.status.integerValue == 6 || detailModel.status.integerValue == 7 || detailModel.homeOtScore.integerValue > 0 ||detailModel.awayOtScore.integerValue > 0) {
        isJiaShi = YES;
    }
    self.view_bg1.sourceArr = isJiaShi ? @[@"球队",@"一",@"二",@"三",@"四",@"加时",@"总分"] : @[@"球队",@"一",@"二",@"三",@"四",@"总分"];
    //主队

    self.view_bg3.teamSourceArr = isJiaShi ? @[detailModel.homeTeam?detailModel.homeTeam:@"",
                                               detailModel.homeScore1?detailModel.homeScore1:@"",
                                               detailModel.homeScore2?detailModel.homeScore2:@"",
                                               detailModel.homeScore3?detailModel.homeScore3:@"",
                                               detailModel.homeScore4?detailModel.homeScore4:@"",
                                               detailModel.homeOtScore?detailModel.homeOtScore:@"",
                                               detailModel.homeScore?detailModel.homeScore:@""] :@[detailModel.homeTeam?detailModel.homeTeam:@"",
                                                                                                   detailModel.homeScore1?detailModel.homeScore1:@"",
                                                                                                   detailModel.homeScore2?detailModel.homeScore2:@"",
                                                                                                   detailModel.homeScore3?detailModel.homeScore3:@"",
                                                                                                   detailModel.homeScore4?detailModel.homeScore4:@"",
                                                                                                   detailModel.homeScore?detailModel.homeScore:@""];
    //客队
    self.view_bg2.teamSourceArr =isJiaShi ? @[detailModel.guestTeam?detailModel.guestTeam:@"",
                                              detailModel.awayScore1?detailModel.awayScore1:@"",
                                              detailModel.awayScore2?detailModel.awayScore2:@"",
                                              detailModel.awayScore3?detailModel.awayScore3:@"",
                                              detailModel.awayScore4?detailModel.awayScore4:@"",
                                              detailModel.awayOtScore?detailModel.awayOtScore:@"",
                                              detailModel.guestScore?detailModel.guestScore:@""] : @[detailModel.guestTeam?detailModel.guestTeam:@"",
                                              detailModel.awayScore1?detailModel.awayScore1:@"",
                                              detailModel.awayScore2?detailModel.awayScore2:@"",
                                              detailModel.awayScore3?detailModel.awayScore3:@"",
                                              detailModel.awayScore4?detailModel.awayScore4:@"",
                                              detailModel.guestScore?detailModel.guestScore:@""];
    
//    self.view_lineImg.contentInsets = UIEdgeInsetsMake(30, 30, 20, 50);
//    self.view_lineImg.xLineDataArr = isJiaShi ? @[@"Q1",@"Q2",@"Q3",@"Q4",@"Q5"] : @[@"Q1",@"Q2",@"Q3",@"Q4"];
//    //主队
//    self.view_lineImg.yellowValueArr = isJiaShi ? @[@(detailModel.homeScore1.integerValue),@(detailModel.homeScore2.integerValue),@(detailModel.homeScore3.integerValue),@(detailModel.homeScore4.integerValue),@(detailModel.homeOtScore.integerValue)] : @[@(detailModel.homeScore1.integerValue),@(detailModel.homeScore2.integerValue),@(detailModel.homeScore3.integerValue),@(detailModel.homeScore4.integerValue)];
//    //客队
//    self.view_lineImg.redValueArr = isJiaShi ?  @[@(detailModel.awayScore1.integerValue),@(detailModel.awayScore2.integerValue),@(detailModel.awayScore3.integerValue),@(detailModel.awayScore4.integerValue),@(detailModel.awayOtScore.integerValue)] :@[@(detailModel.awayScore1.integerValue),@(detailModel.awayScore2.integerValue),@(detailModel.awayScore3.integerValue),@(detailModel.awayScore4.integerValue)];
//    
//    self.view_lineImg.yLineDataArr = [self caculateYArray:self.view_lineImg.redValueArr guestArray:self.view_lineImg.yellowValueArr];
//    self.view_lineImg.showYLine = YES;
//    //主队
//    self.view_lineImg.str_yellowTeamName = detailModel.homeTeam;
//    //客队
//    self.view_lineImg.str_redTeamName = detailModel.guestTeam;
//    
//    self.view_lineImg.showYLevelLine = YES;
//    [self.view_lineImg showAnimation];
    
}
//计算Y坐标,例如四节比分为[14,24,34,44];则Y坐标为[10,20,30,40,50];
- (NSArray *)caculateYArray:(NSArray *)homeArray guestArray:(NSArray *)guestArray {
    NSNumber *homeMax = [homeArray valueForKeyPath:@"@max.floatValue"];
    NSNumber *homeMin = [homeArray valueForKeyPath:@"@min.floatValue"];
    NSNumber *guestMax = [guestArray valueForKeyPath:@"@max.floatValue"];
    NSNumber *guestMin = [guestArray valueForKeyPath:@"@min.floatValue"];
    NSInteger max = MAX([homeMax integerValue], [guestMax integerValue]);
    NSInteger min = MIN([guestMin integerValue], [homeMin integerValue]);
    NSInteger top = (max/10+1)*10;
    NSInteger bottom = (min/10)*10;
    NSMutableArray *array = [NSMutableArray new];
    NSInteger count = 0;
    count = (top - bottom)/10;
    for (int i = 0;i < count + 1;i++) {
        [array addObject:@(bottom +10*i)];
    }
    return array;
}
#pragma mark ===================== lazy ==================================
//-(UILabel *)lab_title {
//    if (!_lab_title) {
//        _lab_title = [[UILabel alloc] initWithFrame:CGRectZero];
//        _lab_title.text = @"比赛统计";
//
//        _lab_title.textColor = kCommonDarkGrayColor;
//        [_lab_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//        [self.contentView addSubview:_lab_title];
//    }
//    return _lab_title;
//}

- (QukanMatchStatisticeListView *)view_bg1 {
    if (!_view_bg1) {
        _view_bg1 = [[QukanMatchStatisticeListView alloc] initWithFrame:CGRectZero];
        _view_bg1.backgroundColor = HEXColor(0xEAEAEA);
        [self.contentView addSubview:_view_bg1];
    }
    return _view_bg1;
}

- (QukanMatchStatisticeListView *)view_bg2 {
    if (!_view_bg2) {
        _view_bg2 = [[QukanMatchStatisticeListView alloc] initWithFrame:CGRectZero];
        _view_bg2.backgroundColor = kCommonWhiteColor;
        [self.contentView addSubview:_view_bg2];
    }
    return _view_bg2;
}

- (QukanMatchStatisticeListView *)view_bg3 {
    if (!_view_bg3) {
        _view_bg3 = [[QukanMatchStatisticeListView alloc] initWithFrame:CGRectZero];
        _view_bg3.backgroundColor = kCommonWhiteColor;
        [self.contentView addSubview:_view_bg3];
    }
    return _view_bg3;
}

//- (QukanBasketLineImgView *)view_lineImg {
//    if (!_view_lineImg) {
//        _view_lineImg = [[QukanBasketLineImgView alloc] initWithFrame:CGRectZero];
//
//        [self.contentView addSubview:_view_lineImg];
//    }
//    return _view_lineImg;
//}
@end
