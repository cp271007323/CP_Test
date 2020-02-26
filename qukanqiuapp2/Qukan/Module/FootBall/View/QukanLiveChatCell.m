//
//  QukanLiveChatCell.m
//  Qukan
//
//  Created by leo on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLiveChatCell.h"


@interface QukanLiveChatCell ()

/**头像*/
@property(nonatomic, strong) UIImageView   * img_header;
/**名字lab*/
@property(nonatomic, strong) UILabel   * lab_name;
/**主内容框*/
@property(nonatomic, strong) UIView   * view_content;
/**主要内容文本*/
@property(nonatomic, strong) UILabel   * lab_content;

@end

@implementation QukanLiveChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommentBackgroudColor;
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ===================== initUI ==================================
- (void)initUI {
    [self.contentView addSubview:self.img_header];
    [self.img_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(9);
        make.top.equalTo(self.contentView).offset(5);
        make.width.height.equalTo(@(22));
    }];
    
    [self.contentView addSubview:self.lab_name];
    [self.lab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.img_header.mas_right).offset(10);
        make.top.equalTo(self.img_header).offset(-4);
    }];
    
    [self.contentView addSubview:self.view_content];
    [self.contentView addSubview:self.lab_content];
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_name.mas_bottom).offset(13);
        make.left.equalTo(self.lab_name).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-35);
    }];
    
    
    [self.view_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.lab_content).offset(-7);
        make.right.bottom.equalTo(self.lab_content).offset(7);
    }];
}

#pragma mark ===================== 赋值 ==================================
- (void)fullCellWithMessage:(NIMMessage *)message isBasket:(BOOL)isBasket{
    NIMMessageChatroomExtension *ext = (NIMMessageChatroomExtension *)message.messageExt;
    NSString *name = ext.roomNickname.length ? ext.roomNickname : @"外星人";
    self.lab_name.text = name;
//    NSLog(@"ext.roomAvatar ====== %@ ....%@",name,ext.roomAvatar);
    NSString *str = ext.roomAvatar;
    if ([str containsString:@"https://"]) {
        str = [str stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    
    [self.img_header sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:isBasket?kImageNamed(@"BaksetBall_chat_placehold"):kImageNamed(@"Qukan_user_DefaultAvatar")];
    
    UIColor *senderColor = [message.from isEqualToString:@"1_0"] ? kThemeColor : kCommonDarkGrayColor;
    self.lab_content.text = message.text;
    self.lab_content.textColor = senderColor;
}

#pragma mark ===================== lazy ==================================
- (UIImageView *)img_header {
    if (!_img_header) {
        _img_header = [UIImageView new];
        _img_header.layer.masksToBounds = YES;
        _img_header.layer.cornerRadius = 11;
    }
    return _img_header;
}

- (UILabel *)lab_name {
    if (!_lab_name) {
        _lab_name = [UILabel new];
        _lab_name.textColor = kTextGrayColor;
        _lab_name.font = [UIFont systemFontOfSize:12];
    }
    return _lab_name;
}


- (UIView *)view_content {
    if (!_view_content) {
        _view_content = [UIView new];
        _view_content.backgroundColor = kCommonWhiteColor;
        _view_content.layer.masksToBounds = YES;
        _view_content.layer.cornerRadius = 4;
    }
    return _view_content;
}


- (UILabel *)lab_content {
    if (!_lab_content) {
        _lab_content = [UILabel new];
        _lab_content.textColor = kCommonDarkGrayColor;
        _lab_content.numberOfLines = 0;
        
        _lab_content.font = [UIFont systemFontOfSize:14];
    }
    return _lab_content;
}
@end
