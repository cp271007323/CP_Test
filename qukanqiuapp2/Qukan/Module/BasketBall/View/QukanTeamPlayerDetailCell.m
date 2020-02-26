//
//  QukanTeamPlayerDetailCell.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamPlayerDetailCell.h"
#import  "QukanJHGridView.h"
@interface QukanTeamPlayerDetailCell()<JHGridViewDelegate>

@property(nonatomic, strong) UILabel   * lab_title;
// 统计列表的tab
@property(nonatomic, strong) UITableView   * view_tab;
@property (nonatomic, copy)NSArray <QukanHomeAndGuestPlayerListModel *> *dataArray;
@property(nonatomic,readwrite,strong)QukanJHGridView *gridView;
@property (nonatomic, strong) UIView *leftPlayerNameView;
@end


@implementation QukanTeamPlayerDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark ===================== initUI ==================================

- (void)initUI {
    [self.contentView addSubview:self.gridView];
    [self.contentView addSubview:self.leftPlayerNameView];
}

#pragma mark ===================== setData ==================================

- (void)setTeamName:(NSString *)teamName {
    self.lab_title.text = teamName;
}

- (void)setGuestPlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> * _Nonnull)guestPlayers {
    self.dataArray = [NSMutableArray new];
    self.dataArray = [self filter:guestPlayers];
    [self setGridViewUI];
}

- (void)setHomePlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> *)homePlayers  {
    self.dataArray = [NSMutableArray new];
    self.dataArray = [self filter:homePlayers];
    [self setGridViewUI];
}

- (void)setGridViewUI {
    self.gridView.frame = CGRectMake(90, 0, kScreenWidth-90, (self.dataArray.count+1) *30);
    self.leftPlayerNameView.frame = CGRectMake(0, 0, 90, (self.dataArray.count + 1)* 30);
    [self.leftPlayerNameView removeAllSubviews];
    for (int i = 0;i <self.dataArray.count + 1;i++) {
        UILabel *label = [UILabel new];
        [self.leftPlayerNameView addSubview:label];
        label.frame = CGRectMake(0, i*30, 90, 30);
        label.textColor = kCommonBlackColor;
        label.font = kSystemFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        [self.leftPlayerNameView addSubview:label];
        label.backgroundColor = i > 5 ? HEXColor(0xF7F7F7) : kCommonWhiteColor;
        if (i == 0) {
            label.text = @"球员";
            label.textColor = HEXColor(0x666666);
            label.backgroundColor = HEXColor(0xF7F7F7);
            label.font = kFont10;
        } else {
            QukanHomeAndGuestPlayerListModel *model = self.dataArray[i-1];
            label.text = model.player;
            label.textColor = kCommonTextColor;
        }
    }
    [self setGirdViewDataWithArray:self.dataArray];
}

- (void)setGirdViewDataWithArray:(NSArray *)array {
    for (QukanHomeAndGuestPlayerListModel *model in array) {
        if (model.location.length > 0) {
            model.locationString = @"是";
        } else {
            model.locationString = @"否";
        }
        model.shootString = [NSString stringWithFormat:@"%@/%@",model.shootHit,model.shoot];
        model.threeScoreString = [NSString stringWithFormat:@"%@/%@",model.threeminHit,model.threemin];
        model.freeThrowString = [NSString stringWithFormat:@"%@/%@",model.punishballHit,model.punishball];
        model.backboardString = [NSString stringWithFormat:@"%ld",model.attack.integerValue + model.defend.integerValue];
    }
    NSArray *titles = @[@"首发",@"时间",@"得分",@"篮板",@"助攻",@"投篮",@"三分",@"盖帽",@"罚球",@"犯规",@"抢断",@"失误",];
    NSArray *tags = @[@"locationString",@"playTime",@"score",@"backboardString",@"helpAttack",@"shootString",@"threeScoreString",@"cover",@"freeThrowString",@"foul",@"rob",@"misPlay"];
    [self.gridView setTitles:titles andObjects:array withTags:tags];
}

- (NSArray *)filter:(NSArray *)array {
    //首发
    NSArray *hasLoacation = [[array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return model.location.length > 0;
    }] array];
    //首发比分
    NSArray *locationSortedByScore = [hasLoacation sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj2.score.integerValue) compare:@(obj1.score.integerValue)];
    }];
    //替补
    NSArray *noLoacation = [[array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return model.location.length == 0;
    }] array];
    //替补是否上场
    NSArray *hasMacth = [[noLoacation.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return ![model.playTime isEqualToString:@"0"];
    }] array];
    //替补比分
    NSArray *noLocationSortedByScore = [hasMacth sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj2.score.integerValue) compare:@(obj1.score.integerValue)];
    }];
    NSMutableArray *filterArray = NSMutableArray.new;
    [filterArray addObjectsFromArray:locationSortedByScore];
    [filterArray addObjectsFromArray:noLocationSortedByScore];
    return filterArray;
}

#pragma mark ===================== gridViewDelegate ==================================

- (void)didSelectRowAtGridIndex:(GridIndex)gridIndex {
    NSLog(@"selected at\ncol:%ld -- row:%ld", gridIndex.col, gridIndex.row);
}

- (BOOL)isTitleFixed{
    return YES;
}

- (CGFloat)widthForColAtIndex:(long)index {
    return 45;
}

- (CGFloat)heightForTitles {
    return 30;
}

- (CGFloat)heightForRowAtIndex:(long)index {
    return 30;
}

- (UIColor *)backgroundColorForTitleAtIndex:(long)index {
    return HEXColor(0xF7F7F7);
}

- (UIColor *)backgroundColorForGridAtGridIndex:(GridIndex)gridIndex {
    if (gridIndex.row >= 5) {
        return HEXColor(0xf7f7f7);
    } else return kCommonWhiteColor;
}

- (UIColor *)textColorForTitleAtIndex:(long)index {
    return HEXColor(0x666666);
}

- (UIColor *)textColorForGridAtGridIndex:(GridIndex)gridIndex {
    return kCommonTextColor;
}

- (UIFont *)fontForTitleAtIndex:(long)index {
    return [UIFont systemFontOfSize:10];
}

- (UIFont *)fontForGridAtGridIndex:(GridIndex)gridIndex {
    return kSystemFont(12);
}

#pragma mark ===================== lazy ==================================

- (UIView *)leftPlayerNameView {
    if (!_leftPlayerNameView) {
        _leftPlayerNameView = UIView.new;
    }
    return _leftPlayerNameView;
}

- (QukanJHGridView*)gridView{
    if (!_gridView) {
        _gridView = [QukanJHGridView new];
        _gridView.delegate = self;
    }
    return _gridView;
}

@end
