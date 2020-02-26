//
//  QukanShowStatisticsCell.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanShowStatisticsCell.h"

//球队头部cell
#import "QukanAnalysisHeaderTableViewCell.h"
//球队技术
#import "QukanStrokeAnalysisTableViewCell.h"

@interface QukanShowStatisticsCell()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UILabel   * lab_title;
// 统计列表的tab
@property(nonatomic, strong) UITableView   * view_tab;
@end


@implementation QukanShowStatisticsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initUI {
    
    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}
- (void)setDetailModel:(QukanBasketBallMatchDetailModel *)detailModel {
    _detailModel = detailModel;
    [self.view_tab reloadData];
    
}
#pragma mark - UITableViewDelegate, UITableViewDataSource



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QukanShowStatisticsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanShowStatisticsListCell"];
//    cell.homeList = self.detailModel.homePlayerList;
//    cell.guestList = self.detailModel.guestPlayerList;
//    NSArray *titles = @[@"命中率",@"三分",@"助攻",@"篮板",@"前板",@"后板",@"抢断",@"失误",@"罚球",@"犯规",@"盖帽"];
//    cell.lab_title.text = titles[indexPath.section];
//    [cell fullCell:indexPath.section];
//    return cell;
    
    if (indexPath.row == 0) {
        QukanAnalysisHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanAnalysisHeaderTableViewCell"];
        [cell setBasketDataWithModel:self.detailModel];
        return cell;
    } else {
        QukanStrokeAnalysisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanStrokeAnalysisTableViewCell"];
        NSArray *titles = @[@"命中率",@"三分",@"助攻",@"篮板",@"前板",@"后板",@"抢断",@"失误",@"罚球",@"犯规",@"盖帽"];
        cell.homeList = self.detailModel.homePlayerList;
        cell.guestList = self.detailModel.guestPlayerList;
        cell.titles = titles;
        [cell setBasketDataWithIndex:indexPath.row - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return QukanShowStatisticsListCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



#pragma mark ===================== lazy ==================================

- (UITableView *)view_tab {
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _view_tab.scrollEnabled = NO;
        _view_tab.delegate = self;
        _view_tab.dataSource = self;
        
        _view_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_view_tab registerNib:[UINib nibWithNibName:@"QukanShowStatisticsListCell" bundle:nil] forCellReuseIdentifier:@"QukanShowStatisticsListCell"];
        [_view_tab registerClass:[QukanAnalysisHeaderTableViewCell class] forCellReuseIdentifier:@"QukanAnalysisHeaderTableViewCell"];
        [_view_tab registerClass:[QukanStrokeAnalysisTableViewCell class] forCellReuseIdentifier:@"QukanStrokeAnalysisTableViewCell"];
        
        [self.contentView addSubview:_view_tab];
    }
    return _view_tab;
}



@end
