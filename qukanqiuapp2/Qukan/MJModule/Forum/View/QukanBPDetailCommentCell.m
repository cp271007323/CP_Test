//
//  QukanBPDetailCommentCell.m
//  Qukan
//
//  Created by leo on 2019/10/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBPDetailCommentCell.h"
#import "QukanBPCommentsModel.h"

@interface QukanBPDetailCommentCell ()

// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *img_userHeader;
// 用户名字
@property (weak, nonatomic) IBOutlet UILabel *lab_userName;
// 时间lab
@property (weak, nonatomic) IBOutlet UILabel *lan_time;
// 主要内容lab
@property (weak, nonatomic) IBOutlet UILabel *lab_content;

// 举报按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_jubao;

@end

@implementation QukanBPDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.btn_zan setImage:[kImageNamed(@"Qukan_zanH") imageWithColor:kThemeColor] forState:UIControlStateSelected];
    
    [self.btn_zan setImage:kImageNamed(@"Qukan_zanH") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)fullCellWithModel:(QukanBPCommentsModel *)model {
    [self.img_userHeader sd_setImageWithURL:[NSURL URLWithString:model.content.user_icon] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    self.lan_time.text = model.content.comment_time;
    self.lab_userName.text = model.content.user_name;
    
    self.lab_content.text = model.content.data;
    self.btn_zan.selected = (model.content.is_like == 1);
    [self.btn_zan setTitle:[NSString stringWithFormat:@" %zd",model.content.like_count] forState:UIControlStateNormal];
}

#pragma mark ===================== action ==================================
// 点赞按钮点击
- (IBAction)btn_zanClick:(id)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBPDetailCommentCellBtnClickType:selfCell:)]) {
        [self.delegate QukanBPDetailCommentCellBtnClickType:0 selfCell:self];
    }
}


// 举报按钮点击
- (IBAction)btn_jubaoClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBPDetailCommentCellBtnClickType:selfCell:)]) {
        [self.delegate QukanBPDetailCommentCellBtnClickType:1 selfCell:self];
    }
}

@end
