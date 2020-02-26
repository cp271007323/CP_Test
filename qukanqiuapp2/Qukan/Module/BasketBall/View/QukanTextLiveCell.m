//
//  QukanTextLiveCell.m
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTextLiveCell.h"
#import "QukanTextLiveModel.h"
#import "QukanBasketBallMatchModel.h"

@interface QukanTextLiveCell()

@property(nonatomic, strong) UITableView   * tab_view;
/**左边的线*/
@property(nonatomic, strong) UIView   *view_line ;
/**小点*/
@property(nonatomic, strong) UIView   * view_point;

/**主客队标*/
@property(nonatomic, strong) UIImageView   * img_pubHeader;
/**标题文字*/
@property(nonatomic, strong) UILabel   * lab_pubName;

/**主要内容*/
@property(nonatomic, strong) UILabel   * lab_content;

/**剩余的时间*/
@property(nonatomic, strong) UILabel   * lab_leftTime;

@end


@implementation QukanTextLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommonWhiteColor;
        self.backgroundColor = UIColor.redColor;
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ===================== 布局 ==================================
- (void)initUI {
    [self.contentView addSubview:self.view_line];
    [self.view_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1));
    }];
    
    [self.contentView addSubview:self.view_point];
    [self.view_point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view_line);
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.equalTo(@(5));
    }];
    
    [self.contentView addSubview:self.img_pubHeader];
    [self.img_pubHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_point);
        make.left.equalTo(self.view_point.mas_right).offset(25);
        make.height.width.equalTo(@(30));
    }];
    
    [self.contentView addSubview:self.lab_pubName];
    [self.lab_pubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_point);
        make.left.equalTo(self.img_pubHeader.mas_right).offset(10);
    }];
    
    [self.contentView addSubview:self.lab_leftTime];
    [self.lab_leftTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view_point.mas_right).offset(25);
        make.top.equalTo(self.lab_pubName.mas_bottom).offset(8);
        make.width.equalTo(@(45));
    }];
    
    [self.contentView addSubview:self.lab_content];
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_leftTime.mas_right).offset(5);
        make.top.equalTo(self.lab_leftTime);
        make.right.equalTo(self.contentView).offset(-25);
    }];
}

#pragma mark ===================== publick function ==================================
// 赋值
- (void)fullCellWithModel:(QukanTextLiveModel *)model andmatchModel:(QukanBasketBallMatchModel  *)baskModel {
    self.view_point.backgroundColor = [model.xtype isEqualToString:@"3"]?kThemeColor:HEXColor(0x2E64E7);  // 3:中立，1:主队信息，2:客队信息*/
    
    self.img_pubHeader.hidden = [model.xtype isEqualToString:@"3"];
    [self.img_pubHeader sd_setImageWithURL:[NSURL URLWithString:[model.xtype isEqualToString:@"1"]?baskModel.homeLogo:baskModel.awayLogo] placeholderImage:[UIImage imageWithColor:kTextGrayColor]];
    
    // 主客队名称
    self.lab_pubName.text = [model.xtype isEqualToString:@"1"]?baskModel.homeName:[model.xtype isEqualToString:@"2"]?baskModel.awayName:@"解说员";
    
    // 剩余时间
    self.lab_leftTime.hidden = [model.xtype isEqualToString:@"3"];
    self.lab_leftTime.text = model.remainTime;
    if (model.remainTime.length > 5) {
        self.lab_leftTime.text = [model.remainTime substringToIndex:5];
    }
    
    // 主内容
    self.lab_content.text = model.content;
    
    if ([model.xtype isEqualToString:@"3"]) {  // 若非主客队信息
        [self.lab_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view_point.mas_right).offset(25);
            make.top.equalTo(self.lab_leftTime);
            make.right.equalTo(self.contentView).offset(-25);
        }];
        
        [self.lab_pubName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view_point);
            make.left.equalTo(self.view_point.mas_right).offset(25);
        }];
    }else {
        [self.lab_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lab_leftTime.mas_right).offset(5);
            make.top.equalTo(self.lab_leftTime);
            make.right.equalTo(self.contentView).offset(-25);
        }];
        
        [self.lab_pubName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view_point);
            make.left.equalTo(self.img_pubHeader.mas_right).offset(10);
        }];
    }
}

#pragma mark ===================== lazy ==================================

- (UIView *)view_line {
    if (!_view_line) {
        _view_line = [UIView new];
        _view_line.backgroundColor = HEXColor(0xe3e3e3);
    }
    return _view_line;
}

- (UIView *)view_point {
    if (!_view_point) {
        _view_point = [UIView new];
        _view_point.backgroundColor = kThemeColor;
        _view_point.layer.masksToBounds = YES;
        _view_point.layer.cornerRadius = 2.5;
    }
    return _view_point;
}

- (UIImageView *)img_pubHeader {
    if (!_img_pubHeader) {
        _img_pubHeader = [UIImageView new];
        
    }
    return _img_pubHeader;
}

- (UILabel *)lab_pubName {
    if (!_lab_pubName) {
        _lab_pubName = [UILabel new];
        _lab_pubName.textColor = HEXColor(0x959ca3);
        _lab_pubName.text = @"波哥看球（直播员）";
        _lab_pubName.font = kFont15;
    }
    return _lab_pubName;
}

- (UILabel *)lab_content {
    if (!_lab_content) {
        _lab_content = [UILabel new];
        _lab_content.textColor = kCommonTextColor;
        _lab_content.text = @"比赛结束";
        _lab_content.numberOfLines = 0;
        _lab_content.font = kFont14;
    }
    return _lab_content;
}

- (UILabel *)lab_leftTime {
    if (!_lab_leftTime) {
        _lab_leftTime = [UILabel new];
        _lab_leftTime.textColor = kCommonTextColor;
        _lab_leftTime.text = @"02:26";
        _lab_leftTime.font = kFont15;
    }
    return _lab_leftTime;
}
@end
