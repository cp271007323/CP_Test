//
//  QukanBolingPointListCell.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBolingPointListCell.h"
#import "QukanBolingPointListModel.h"

#import <KSPhotoBrowser.h>

@interface QukanBolingPointListCell ()

// 用户头像icon
@property (weak, nonatomic) IBOutlet UIImageView *img_userIcon;
// 用户名
@property (weak, nonatomic) IBOutlet UILabel *lab_userName;
// 创建时间
@property (weak, nonatomic) IBOutlet UILabel *lab_creactTime;
// 显示内容
@property (weak, nonatomic) IBOutlet UILabel *lab_content;

// 主要队名
@property (weak, nonatomic) IBOutlet UILabel *lab_temeName;
// 主要图片
@property (weak, nonatomic) IBOutlet UIImageView *img_comment;

// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_pinglun;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

// 主模型
@property(nonatomic, strong) QukanBolingPointListModel   * model_main;
@end


@implementation QukanBolingPointListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lab_temeName.textColor = kThemeColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    self.img_comment.userInteractionEnabled = YES;
    [self.img_comment addGestureRecognizer:tap];
    
    
    self.img_comment.layer.masksToBounds = YES;
    self.img_comment.layer.cornerRadius = 5;
    
    
    self.img_userIcon.layer.masksToBounds = YES;
    self.img_userIcon.layer.cornerRadius = 21;
    
    UITapGestureRecognizer *headImgVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChat:)];
    self.img_userIcon.userInteractionEnabled = YES;
    [self.img_userIcon addGestureRecognizer:headImgVTap];
    
    UITapGestureRecognizer *nameLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChat:)];
    self.lab_userName.userInteractionEnabled = YES;
    [self.lab_userName addGestureRecognizer:nameLabelTap];
    
    [self.btn_zan setImage:[kImageNamed(@"Qukan_zanH") imageWithColor:kThemeColor] forState:UIControlStateSelected];
    [self.btn_like setImage:[kImageNamed(@"Qukan_love") imageWithColor:kThemeColor] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fullCellWithModel:(QukanBolingPointListModel *)model {
    
    self.model_main = model;
    
    [self.img_userIcon sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    self.lab_userName.text = model.username;
    self.lab_creactTime.text = model.time;
    
    self.lab_content.text = [self removeSpaceAndNewline:model.content];
    [self.img_comment sd_setImageWithURL:[NSURL URLWithString:model.images.firstObject] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    
    self.lab_temeName.text = [NSString stringWithFormat:@"#%@#",model.title];
    
    self.btn_zan.selected = (model.is_like == 1);
    [self.btn_pinglun setTitle:[NSString stringWithFormat:@"%zd", model.comment_count] forState:UIControlStateNormal];
    
    self.btn_like.selected = (model.user_follow == 1);
}

- (void)hideReportBtn:(BOOL)hide{
    self.reportBtn.hidden = hide;
}

#pragma mark - action

// 举报按钮点击
- (IBAction)btn_jubaoClick:(id)sender {
    NSLog(@"举报按钮点击");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBolingPointListCellBtnClick:andCell:)]) {
        [self.delegate QukanBolingPointListCellBtnClick:1 andCell:self];
    }
}

// 点赞按钮点击
- (IBAction)btn_zanClick:(id)sender {
    NSLog(@"点赞按钮点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBolingPointListCellBtnClick:andCell:)]) {
        [self.delegate QukanBolingPointListCellBtnClick:0 andCell:self];
    }
}

// 收藏按钮点击
- (IBAction)btn_collectionClick:(id)sender {
    NSLog(@"收藏按钮点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBolingPointListCellBtnClick:andCell:)]) {
        [self.delegate QukanBolingPointListCellBtnClick:2 andCell:self];
    }
}

//点击头像，开始聊天
- (void)tapToChat:(UITapGestureRecognizer *)tapGes {
    DEBUGLog(@"点击别人头像聊天");
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanBolingPointListCellBtnClick:andCell:)]) {
        [self.delegate QukanBolingPointListCellBtnClick:3 andCell:self];
    }
}

// 当图片点击时调用
- (void)clickImage:(UITapGestureRecognizer *)Qukan_tap {
    if (!self.vc_parent) {
        return;
    }
    
    KSPhotoItem *item = [[KSPhotoItem alloc] initWithSourceView:self.img_comment imageUrl:[NSURL URLWithString:self.model_main.images.firstObject]];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.pageindicatorStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.bounces = NO;
    [browser showFromViewController:self.vc_parent];
}


- (NSString *)removeSpaceAndNewline:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }

    return html;
}

@end
