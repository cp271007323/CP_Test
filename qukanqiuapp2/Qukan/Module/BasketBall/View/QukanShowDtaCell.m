//
//  QukanShowDtaCell.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanShowDtaCell.h"
#import "QukanBasketPlayerDataTableViewCell.h"

@interface QukanShowDtaCell()<UITableViewDelegate, UITableViewDataSource>

// 顶部标题的view
@property(nonatomic, strong) UIView *view_title;
// 顶部背景的图片
@property(nonatomic, strong) UIImageView   * img_bg;
// 球员列表的tab
@property(nonatomic, strong) UITableView   * view_tab;

@property (nonatomic, strong)NSArray <QukanHomeAndGuestPlayerListModel *> *homePlayerArray;
@property (nonatomic, strong)NSArray <QukanHomeAndGuestPlayerListModel *> *guestPlayerArray;

@end

@implementation QukanShowDtaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initUI {

    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
    self.view_tab.clipsToBounds = NO;
    self.view_tab.layer.shadowColor = HEXColor(0xD1D1D1).CGColor;
    self.view_tab.layer.shadowOffset = CGSizeMake(0,7);
    self.view_tab.layer.shadowOpacity = 0.3;
    self.view_tab.layer.shadowRadius = 15;
}
- (void)setHomePlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> *)homePlayers guestPlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> *)guestPlayers {
    if (homePlayers.count) {
        _homePlayerArray = [self filter:homePlayers];
    }
    if (guestPlayers.count) {
        _guestPlayerArray = [self filter:guestPlayers];
    }
    [self.view_tab reloadData];
}
/// 筛选出各项最高 得分 篮板 助攻 抢断 盖帽
- (NSArray *)filter:(NSArray *)array {
    //得分
    NSArray *sortedByScore = [array sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj1.score.integerValue) compare:@(obj2.score.integerValue)];
    }];
    //篮板
    NSArray *sortedByDefendAndAttack = [array sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj1.defend.integerValue + obj1.attack.integerValue) compare:@(obj2.defend.integerValue + obj2.attack.integerValue)];
    }];
    //助攻
    NSArray *sortedByhelpAttack = [array sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj1.helpAttack.integerValue) compare:@(obj2.helpAttack.integerValue)];
    }];
    //抢断
    NSArray *sortedByRob = [array sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj1.rob.integerValue) compare:@(obj2.rob.integerValue)];
    }];
    //盖帽
    NSArray *sortedByCover = [array sortedArrayUsingComparator:^NSComparisonResult(QukanHomeAndGuestPlayerListModel *obj1, QukanHomeAndGuestPlayerListModel *obj2) {
        return [@(obj1.cover.integerValue) compare:@(obj2.cover.integerValue)];
    }];
    NSMutableArray *filterArray = NSMutableArray.new;
    if (sortedByScore.count) {
        [filterArray addObject:sortedByScore.lastObject];
    }
    if (sortedByDefendAndAttack.count) {
        [filterArray addObject:sortedByDefendAndAttack.lastObject];
    }
    if (sortedByhelpAttack.count) {
        [filterArray addObject:sortedByhelpAttack.lastObject];
    }
    if (sortedByRob.count) {
        [filterArray addObject:sortedByRob.lastObject];
    }
    if (sortedByCover.count) {
        [filterArray addObject:sortedByCover.lastObject];
    }
    return filterArray;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBasketPlayerDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasketPlayerDataTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.view_bottomLine.hidden = indexPath.section == 4;
    QukanHomeAndGuestPlayerListModel *homeModel;
    QukanHomeAndGuestPlayerListModel *guestModel;
    if (_homePlayerArray.count) {
       homeModel = _homePlayerArray[indexPath.section];
    }
    if (_guestPlayerArray.count) {
        guestModel = _guestPlayerArray[indexPath.section];
    }
    NSArray *midLabs = @[@"得分",@"篮板",@"助攻",@"抢断",@"盖帽"];
    [cell setHomePlayerModel:homeModel guestPlayerModel:guestModel indexPathRow:indexPath.section midTitle:midLabs[indexPath.section]];
    @weakify(self)
    cell.playerCilckBlock = ^(NSInteger flag) {
        @strongify(self)
        if (self.playerCilckBlock) {
            self.playerCilckBlock(flag == 1 ? guestModel : homeModel);
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PlayerDtaCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.homePlayerArray.count > 0  && self.guestPlayerArray.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


#pragma mark ===================== lazy ==================================

- (UITableView *)view_tab {
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _view_tab.scrollEnabled = NO;
        _view_tab.delegate = self;
        _view_tab.dataSource = self;
        
        _view_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        [_view_tab registerNib:[UINib nibWithNibName:@"QukanShowDataListCell" bundle:nil] forCellReuseIdentifier:@"QukanShowDataListCell"];
        [_view_tab registerClass:[QukanBasketPlayerDataTableViewCell class] forCellReuseIdentifier:@"QukanBasketPlayerDataTableViewCell"];
        
        [self.contentView addSubview:_view_tab];
    }
    return _view_tab;
}


@end
