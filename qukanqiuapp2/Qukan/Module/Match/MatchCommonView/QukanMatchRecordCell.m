//
//  QukanMatchDetaiJSTJCell.m
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//  球队战绩cell

#import "QukanMatchRecordCell.h"

#import "QukanMatchDetailDataQDZJCell.h"
#import "QukanMatchDetailDataQDZJHeaderCell.h"

#import "QukanMatchDetailHistoryModel.h"
#import "QukanMatchDetailLSJFHeaderView.h"

#import "QukanBasketDetailDataModel.h"

@interface QukanMatchRecordCell () <UITableViewDelegate, UITableViewDataSource>


/**数据列表*/
@property(nonatomic, strong) UITableView   * tab_view;

/**cell类型  1:历史交锋 2:球队战绩  */
@property(nonatomic, copy) NSString   * type_main;

/**历史交战数据*/
@property(nonatomic, strong) NSMutableArray<QukanMatchDetailHistoryModel *>* arr_lsjf;
/**球队近期战绩*/
@property(nonatomic, strong) NSMutableArray<QukanMatchDetailHistoryModel *>* arr_jqzj;

/**篮球历史交战数据*/
@property(nonatomic, strong) NSMutableArray<QukanBasketDetailHisFightData *>* arr_basketLsjf;
/**篮球球队近期战绩*/
@property(nonatomic, strong) NSMutableArray<QukanBasketDetailHisFightData *>* arr_basketJqzj;

/**历史交锋头部视图*/
@property(nonatomic, strong) QukanMatchDetailLSJFHeaderView   * header_LSJF;


/**底部战绩统计lab*/
@property(nonatomic, strong) UILabel   * lab_zjtj;

/**tab距离顶部的高度*/
@property(nonatomic, strong) MASConstraint   * constraint_tabTop;

/**tab距离底部的高度*/
@property(nonatomic, strong) MASConstraint   * constraint_tabBottom;


@end


@implementation QukanMatchRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self.contentView addSubview:self.lab_homeName];
    [self.lab_homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@(20));
    }];
    
    
    [self.contentView addSubview:self.header_LSJF];
    [self.header_LSJF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(30));
    }];
    
    [self.contentView addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        self.constraint_tabTop = make.top.equalTo(self.contentView).offset(30);
        make.left.right.equalTo(self.contentView);
        self.constraint_tabBottom = make.bottom.equalTo(self.contentView).offset(-40);
    }];
    
    [self.contentView addSubview:self.lab_zjtj];
    [self.lab_zjtj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.tab_view.mas_bottom).offset(10);
        make.height.equalTo(@(17));
    }];
}



// 足球历史交锋
- (void)fullCellWithJFLSData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_lsjf {
    self.type_main = @"1";
    self.arr_lsjf = arr_lsjf;
    self.lab_homeName.hidden = YES;
    self.header_LSJF.hidden =  NO;
    
    [self.header_LSJF fullHeaderWithJFLSData:arr_lsjf];
    self.constraint_tabTop.mas_equalTo(105);
    self.constraint_tabBottom.mas_equalTo(-10);
    
    [self.tab_view reloadData];
    
    self.lab_zjtj.hidden = YES;
}


// 足球近期战绩
- (void)fullCellWithQDZJData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_jqzj {
    self.type_main = @"2";
    self.header_LSJF.hidden = YES;
    
    self.lab_zjtj.hidden = (arr_jqzj.count == 0);
    self.lab_homeName.hidden = (arr_jqzj.count == 0);
    
    self.constraint_tabTop.mas_equalTo(30);
     self.constraint_tabBottom.mas_equalTo(-40);
    self.arr_jqzj = arr_jqzj;
    [self.tab_view reloadData];
    
    NSInteger winCount = 0;
    NSInteger lossCount = 0;
    NSInteger pingCount = 0;
    for (QukanMatchDetailHistoryModel *data in arr_jqzj) {
        if( data.winState == 1) {
            winCount ++;
        }else if (data.winState == 0){
            lossCount ++;
        }else {
            pingCount ++;
        }
    }
    
    CGFloat QukanShenglv_float = 0;
    if (winCount > 0) {
        QukanShenglv_float = (CGFloat)winCount / (CGFloat)(winCount + lossCount + pingCount) * 100.0f;
    }
    
    
    self.lab_zjtj.text = [NSString stringWithFormat:@"%@近%zd场%zd胜%zd平%zd负 胜率%.1f%@",self.lab_homeName.text,winCount + lossCount + pingCount,winCount,pingCount,lossCount,QukanShenglv_float,@"%"];
}

// 蓝球球队历史交锋数据
- (void)fullCellWithBasketJFLSData:(NSMutableArray <QukanBasketDetailHisFightData *> *)arr_basketLsjf{
    self.type_main = @"3";
    
    self.lab_homeName.hidden = NO;
    self.header_LSJF.hidden = YES;
    self.lab_zjtj.hidden = NO;
    
    NSInteger winCount = 0;
    NSInteger lossCount = 0;
    for (QukanBasketDetailHisFightData *data in arr_basketLsjf) {
        if( data.winState == 1) {
            winCount ++;
        }else {
            lossCount ++;
        }
    }
    
    if (arr_basketLsjf.count == 0) {
        self.lab_zjtj.text = @"双方之前还未交战";
    }else {
        self.lab_zjtj.text = [NSString stringWithFormat:@"双方近%zd场交战,%@%zd胜%zd负",winCount + lossCount,self.lab_homeName.text,winCount,lossCount];
    }
    
    self.constraint_tabTop.mas_equalTo(30);
    self.constraint_tabBottom.mas_equalTo(-40);
    self.arr_basketLsjf = arr_basketLsjf;
    [self.tab_view reloadData];
}

// 蓝球球队近期战绩
- (void)fullCellWithBasketQDZJData:(NSMutableArray <QukanBasketDetailHisFightData *> *)arr_basketQdzj{
    self.type_main = @"4";
    self.lab_zjtj.hidden = (arr_basketQdzj.count == 0);
    self.lab_homeName.hidden = NO;
    
    self.header_LSJF.hidden = YES;
    
    self.constraint_tabTop.mas_equalTo(30);
    self.constraint_tabBottom.mas_equalTo(-40);
    
    NSInteger winCount = 0;
    NSInteger lossCount = 0;
    for (QukanBasketDetailHisFightData *data in arr_basketQdzj) {
        if( data.winState == 1) {
            winCount ++;
        }else {
            lossCount ++;
        }
    }
    
    CGFloat QukanShenglv_float = 0;
    if (winCount > 0) {
        QukanShenglv_float = (CGFloat)winCount / (CGFloat)(winCount + lossCount) * 100.0f;
    }
    self.lab_zjtj.text = [NSString stringWithFormat:@"%@近%zd场%zd胜%zd负 胜率%.1f%@",self.lab_homeName.text,winCount + lossCount,winCount,lossCount,QukanShenglv_float,@"%"];
    
    self.arr_basketJqzj = arr_basketQdzj;
    [self.tab_view reloadData];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QukanMatchDetailDataQDZJHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchDetailDataQDZJHeaderCellID"];
        if (!cell) {
            cell = [[QukanMatchDetailDataQDZJHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchDetailDataQDZJHeaderCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.type_main isEqualToString:@"3"] || [self.type_main isEqualToString:@"4"]) {
            cell.lab_homeName.text = @"客队";
            cell.lab_awayName.text = @"主队";
        }else {
            cell.lab_homeName.text = @"主队";
            cell.lab_awayName.text = @"客队";
        }
        
        
        return cell;
    }else {
        
        QukanMatchDetailDataQDZJCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchDetailDataQDZJCellID"];
        if (!cell) {
            cell = [[QukanMatchDetailDataQDZJCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchDetailDataQDZJCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.type_main isEqualToString:@"1"]) {
            [cell fullCellWithModel:self.arr_lsjf[indexPath.row - 1] andIndex:indexPath.row homeName:self.homeName];
        }
        if ([self.type_main isEqualToString:@"2"]) {
            [cell fullCellWithModel:self.arr_jqzj[indexPath.row - 1] andIndex:indexPath.row homeName:self.homeName];
        }
        if ([self.type_main isEqualToString:@"3"]) {
            [cell fullCellWithBasketModel:self.arr_basketLsjf[indexPath.row - 1] andIndex:indexPath.row];
        }
        if ([self.type_main isEqualToString:@"4"]) {
            [cell fullCellWithBasketModel:self.arr_basketJqzj[indexPath.row - 1] andIndex:indexPath.row];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.type_main isEqualToString:@"1"]) {
        return self.arr_lsjf.count + 1;
    }
    if ([self.type_main isEqualToString:@"2"]) {
        return self.arr_jqzj.count + 1;
    }
    if ([self.type_main isEqualToString:@"3"]) {
        return self.arr_basketLsjf.count + 1;
    }
    if ([self.type_main isEqualToString:@"4"]) {
        return self.arr_basketJqzj.count + 1;
    }
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 25;
    }
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark ===================== lazy ==================================
- (UILabel *)lab_homeName {
    if (!_lab_homeName) {
        _lab_homeName = [UILabel new];
        _lab_homeName.textColor = kTextGrayColor;
        _lab_homeName.font = kFont12;
        _lab_homeName.text = @"--";
    }
    return _lab_homeName;
}

- (QukanMatchDetailLSJFHeaderView *)header_LSJF {
    if (!_header_LSJF) {
        _header_LSJF = [[QukanMatchDetailLSJFHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _header_LSJF;
}

- (UILabel *)lab_zjtj {
    if (!_lab_zjtj) {
        _lab_zjtj = [UILabel new];
        _lab_zjtj.textColor = kTextGrayColor;
        _lab_zjtj.font = [UIFont systemFontOfSize:9];
        _lab_zjtj.text = @"--";
    }
    return _lab_zjtj;
}

- (UITableView *)tab_view {
    if (!_tab_view) {
        _tab_view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tab_view.dataSource = self;
        _tab_view.delegate = self;
        
        _tab_view.backgroundColor = kCommonWhiteColor;
        _tab_view.backgroundColor = kCommentBackgroudColor;
        
        
        _tab_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tab_view.estimatedRowHeight = 0.0f;
        _tab_view.estimatedSectionFooterHeight = 0.0f;
        _tab_view.estimatedSectionHeaderHeight = 0.0f;
        
        [_tab_view registerClass:[QukanMatchDetailDataQDZJCell class] forCellReuseIdentifier:@"QukanMatchDetailDataQDZJCellID"];
        
        [_tab_view registerClass:[ QukanMatchDetailDataQDZJHeaderCell class] forCellReuseIdentifier:@" QukanMatchDetailDataQDZJHeaderCellID"];
    }
    return _tab_view;
}

@end
