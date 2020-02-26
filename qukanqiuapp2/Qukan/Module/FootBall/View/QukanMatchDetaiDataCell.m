//
//  QukanMatchDetaiJSTJCell.m
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//  技术统计cell

#import "QukanMatchDetaiDataCell.h"
#import "QukanMatchDetailDataJSTJCell.h"

@interface QukanMatchDetaiDataCell () <UITableViewDelegate, UITableViewDataSource>


/**数据列表*/
@property(nonatomic, strong) UITableView   * tab_view;

/**cell类型  1:技术统计 2:历史交锋 3:球队战绩  */
@property(nonatomic, copy) NSString   * type_main;

/**技术统计模型*/
@property(nonatomic, strong) QukanMatchDetailJSTJModel   * model_jstj;

/**tab距离顶部的高度*/
@property(nonatomic, strong) MASConstraint   * constraint_tabTop;

@end


@implementation QukanMatchDetaiDataCell

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
    
    [self.contentView addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        self.constraint_tabTop = make.top.equalTo(self.contentView).offset(30);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

// 技术统计
- (void)fullCellWithJSTJData:(QukanMatchDetailJSTJModel *)model; {
    self.type_main = @"1";
    self.lab_homeName.hidden = NO;
    
    if (!model) {
         self.lab_homeName.hidden = YES;
    }else {
         self.lab_homeName.hidden = NO;
    }
    
    self.constraint_tabTop.mas_equalTo(30);
    
    self.model_jstj = model;
    [self.tab_view reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMatchDetailDataJSTJCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchDetailDataJSTJCellID"];
    if (!cell) {
        cell = [[QukanMatchDetailDataJSTJCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchDetailDataJSTJCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fullCellWithData:self.model_jstj andIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25;
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
        _lab_homeName.text = @"曼联";
    }
    return _lab_homeName;
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
        
        [_tab_view registerClass:[QukanMatchDetailDataJSTJCell class] forCellReuseIdentifier:@"QukanMatchDetailDataJSTJCellID"];
       
    }
    return _tab_view;
}

@end
