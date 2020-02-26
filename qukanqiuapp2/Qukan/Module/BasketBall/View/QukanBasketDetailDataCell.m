//
//  QukanBasketDetailDataCell.m
//  Qukan
//
//  Created by leo on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketDetailDataCell.h"
#import "QukanBasetDetailDataListCell.h"
#import "QukanBasketDetailDataModel.h"

@interface QukanBasketDetailDataCell ()<UITableViewDelegate, UITableViewDataSource>

/**数据列表*/
@property(nonatomic, strong) UITableView   * QukanView_tab;
/**主队队名lab*/
@property(nonatomic, strong) UILabel   * QukanHomeName_lab;
/**客队队名*/
@property(nonatomic, strong) UILabel   * QukanAwayName_lab;
/**主队图标*/
@property(nonatomic, strong) UIImageView   * QukanHomeIcon_img;
/**客队图标*/
@property(nonatomic, strong) UIImageView   * QukanAwayIcon_img;
/**主队战况lab*/
@property(nonatomic, strong) UILabel   * QukanHomeZK_lab;
/**客队战况lab*/
@property(nonatomic, strong) UILabel   * QukanAwayZK_lab;


/**主类别  0表示历史交战  1表示场均数据*/
@property(nonatomic, assign) NSInteger   QukanMainType_int;

/**<#注释#>*/
@property(nonatomic, strong) QukanBasketDetailDataModel  * QukanData_Model;

/**<#注释#>*/
@property(nonatomic, strong) UIView   * QukanTabTopLine_view;

@end


@implementation QukanBasketDetailDataCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self.contentView addSubview:self.QukanHomeIcon_img];
    [self.QukanHomeIcon_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(30);
        make.top.equalTo(self.contentView).offset(13);
        make.width.height.equalTo(@(50));
    }];
    
    [self.contentView addSubview:self.QukanHomeName_lab];
    [self.QukanHomeName_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanHomeIcon_img).offset(8);
        make.left.equalTo(self.QukanHomeIcon_img.mas_right).offset(5);
        make.height.mas_equalTo(17);
    }];
    
    [self.contentView addSubview:self.QukanHomeZK_lab];
    [self.QukanHomeZK_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanHomeName_lab);
        make.top.equalTo(self.QukanHomeName_lab.mas_bottom).offset(2);
        make.height.equalTo(@(14));
    }];
    
    
    [self.contentView addSubview:self.QukanAwayIcon_img];
    [self.QukanAwayIcon_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-30);
        make.top.equalTo(self.contentView).offset(13);
        make.width.height.equalTo(@(50));
    }];
    
    [self.contentView addSubview:self.QukanAwayName_lab];
    [self.QukanAwayName_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanAwayIcon_img).offset(8);
        make.right.equalTo(self.QukanAwayIcon_img.mas_left).offset(-5);
        make.height.mas_equalTo(17);
    }];
    
    [self.contentView addSubview:self.QukanAwayZK_lab];
    [self.QukanAwayZK_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.QukanAwayName_lab);
        make.top.equalTo(self.QukanAwayName_lab.mas_bottom).offset(2);
        make.height.mas_equalTo(14);
    }];
    
    [self.contentView addSubview:self.QukanView_tab];
    [self.QukanView_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanAwayIcon_img.mas_bottom).offset(24);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.QukanTabTopLine_view];
    [self.QukanTabTopLine_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.QukanView_tab);
        make.bottom.equalTo(self.QukanView_tab.mas_top);
        make.height.equalTo(@(0.5));
    }];
}


#pragma mark ===================== public function ==================================
- (void)fullCellWitModel:(QukanBasketDetailDataModel *)model andType:(NSInteger)type {
    [self.QukanAwayIcon_img sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
    [self.QukanHomeIcon_img sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];

    self.QukanHomeName_lab.text = model.homeGb;
    self.QukanAwayName_lab.text = model.awayGb;
    
    self.QukanAwayZK_lab.text = [NSString stringWithFormat:@"%zd胜%zd负",model.awayTeamRankData.awayWin + model.awayTeamRankData.homeWin, model.awayTeamRankData.awayLoss + model.awayTeamRankData.homeLoss];
    
    self.QukanHomeZK_lab.text = [NSString stringWithFormat:@"%zd胜%zd负", model.homeTeamRankData.awayWin + model.homeTeamRankData.homeWin, model.homeTeamRankData.awayLoss + model.homeTeamRankData.homeLoss];

    self.QukanMainType_int = type;
    self.QukanData_Model = model;
    [self.QukanView_tab reloadData];
}

#pragma mark ========================== UITableViewDelegate, UITableViewDataSource ==========================
// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBasetDetailDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasetDetailDataListCell"];
    if (!cell) {
        cell = [[QukanBasetDetailDataListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanBasetDetailDataListCellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (self.QukanData_Model) {
        if (self.QukanMainType_int == 0) {
            [cell fullCellWithLeftData:[self getStrFromIndex:indexPath.row andSaijiModel:self.QukanData_Model.awayTeamRankData] centerStr:[self getCenterStrFromIndex:indexPath.row] rightData:[self getStrFromIndex:indexPath.row andSaijiModel:self.QukanData_Model.homeTeamRankData]];
        }
        if (self.QukanMainType_int == 1) {
            [cell fullCellWithLeftData:[self getStrFromIndex:indexPath.row andChangjunModel:self.QukanData_Model.awayTeamAvgData] centerStr:[self getCenterStrFromIndex:indexPath.row] rightData:[self getStrFromIndex:indexPath.row andChangjunModel:self.QukanData_Model.homeTeamAvgData]];
        }
    }
    
    return cell;
}
// 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
// 每个section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.QukanMainType_int == 0) {
        return 6;
    }
    if (self.QukanMainType_int == 1) {
        return 8;
    }
    return 0;
}
// tab的section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// section的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
// section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
// section的尾部的View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
//section尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


- (NSString *)getCenterStrFromIndex:(NSInteger)index {
    NSArray *arr = nil;
    if (self.QukanMainType_int == 0) {
        arr = @[@"排名",@"胜率",@"连续战绩",@"近10场战绩",@"主场战绩",@"客场战绩"];
    }
    if (self.QukanMainType_int == 1) {
        arr = @[@"得分",@"篮板",@"助攻",@"盖帽",@"抢断",@"投篮命中率",@"三分球命中率",@"罚球命中率"];
    }
    if (arr.count > index) {
        return arr[index];
    }
    return @"";
}

- (NSString *)getStrFromIndex:(NSInteger)index andSaijiModel:(QukanBasketDetailSaijiData *)model{
    switch (index) {
        case 0:
            return [NSString stringWithFormat:@"%zd",model.totalOrder];
            break;
        case 1:
            return model.winScale.length ? [NSString stringWithFormat:@"%@%@",model.winScale,@"%"] : @"--";
            break;
        case 2:
            return [NSString stringWithFormat:@"%zd连%@",labs(model.state),(model.state>0?@"胜":@"败")];
            break;
        case 3:
            return [NSString stringWithFormat:@"%zd-%zd",model.near10Win,model.near10Loss];
            break;
        case 4:
            return [NSString stringWithFormat:@"%zd-%zd",model.homeWin,model.homeLoss];
            break;
        case 5:
            return [NSString stringWithFormat:@"%zd-%zd",model.awayWin,model.awayLoss];
            break;
        default:
            return @"";
            break;
    }
    
}

- (NSString *)getStrFromIndex:(NSInteger)index andChangjunModel:(QukanBasketDetailChangjunData *)model{
    
    switch (index) {
        case 0:
            return model.score;
            break;
        case 1:
            return model.rebound;
            break;
        case 2:
            return model.helpAttack;
            break;
        case 3:
            return model.cover;
            break;
        case 4:
            return model.rob;
            break;
        case 5:
//            return model.shootScale;
            return [model.shootScale stringByAppendingString:@"%"];
            break;
        case 6:
            return [model.threeminScale stringByAppendingString:@"%"];
            break;
        case 7:
            return [model.punishballScale stringByAppendingString:@"%"];
            break;
        default:
            return @"";
            break;
    }
}


#pragma mark ===================== lazy ==================================

- (UILabel *)QukanHomeName_lab {
    if (!_QukanHomeName_lab) {
        _QukanHomeName_lab = [UILabel new];
        _QukanHomeName_lab.textAlignment = NSTextAlignmentCenter;
        _QukanHomeName_lab.text = @"--";
        
        _QukanHomeName_lab.font = kFont12;
        _QukanAwayName_lab.textColor = kCommonDarkGrayColor;
    }
    return _QukanHomeName_lab;
}

- (UILabel *)QukanAwayName_lab {
    if (!_QukanAwayName_lab) {
        _QukanAwayName_lab = [UILabel new];
        _QukanAwayName_lab.textAlignment = NSTextAlignmentCenter;
        _QukanAwayName_lab.text = @"--";
        
        _QukanAwayName_lab.font = kFont12;
        _QukanAwayName_lab.textColor = kCommonDarkGrayColor;
    }
    return _QukanAwayName_lab;
}

- (UILabel *)QukanHomeZK_lab {
    if (!_QukanHomeZK_lab) {
        _QukanHomeZK_lab = [UILabel new];
        _QukanHomeZK_lab.textAlignment = NSTextAlignmentCenter;
        _QukanHomeZK_lab.text = @"--";
        
        _QukanHomeZK_lab.font = kFont11;
        _QukanHomeZK_lab.textColor = kTextGrayColor;
    }
    return _QukanHomeZK_lab;
}

- (UILabel *)QukanAwayZK_lab {
    if (!_QukanAwayZK_lab) {
        _QukanAwayZK_lab = [UILabel new];
        _QukanAwayZK_lab.textAlignment = NSTextAlignmentCenter;
        _QukanAwayZK_lab.text = @"--";
        _QukanAwayZK_lab.font = kFont11;
        _QukanAwayZK_lab.textColor = kTextGrayColor;
    }
    return _QukanAwayZK_lab;
}

- (UIImageView *)QukanHomeIcon_img {
    if (!_QukanHomeIcon_img) {
        _QukanHomeIcon_img = [UIImageView new];
    }
    return _QukanHomeIcon_img;
}

- (UIImageView *)QukanAwayIcon_img {
    if (!_QukanAwayIcon_img) {
        _QukanAwayIcon_img = [UIImageView new];
    }
    return _QukanAwayIcon_img;
}

- (UITableView *)QukanView_tab {
    if (!_QukanView_tab) {
        _QukanView_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _QukanView_tab.delegate = self;
        _QukanView_tab.dataSource = self;
        
        _QukanView_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_QukanView_tab registerClass:[QukanBasetDetailDataListCell class] forCellReuseIdentifier:@"QukanBasetDetailDataListCell"];
    }
    return _QukanView_tab;
}

- (UIView *)QukanTabTopLine_view {
    if (!_QukanTabTopLine_view) {
        _QukanTabTopLine_view = [UIView new];
        _QukanTabTopLine_view.backgroundColor = HEXColor(0xE3E2E2);
    }
    return _QukanTabTopLine_view;
}

@end
