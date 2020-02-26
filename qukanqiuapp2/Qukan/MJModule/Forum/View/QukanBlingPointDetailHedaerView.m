//
//  QukanBlingPointDetailHedaerView.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBlingPointDetailHedaerView.h"
#import "QukanBolingPointListModel.h"

#import <KSPhotoBrowser.h>


@interface QukanBlingPointDetailHedaerView ()

// 用户头像图片
@property (weak, nonatomic) IBOutlet UIImageView *img_userHeader;
// 用户名字
@property (weak, nonatomic) IBOutlet UILabel *lab_userName;
// 创建时间
@property (weak, nonatomic) IBOutlet UILabel *lab_creatTime;

// 举报按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_jubao;
// 主要内容
@property (weak, nonatomic) IBOutlet UILabel *lab_content;
// 主要内容图片
@property (weak, nonatomic) IBOutlet UIImageView *img_content;
// 球队名字
@property (weak, nonatomic) IBOutlet UILabel *lab_itemName;

// 主模型
@property(nonatomic, strong) QukanBolingPointListModel   * model_main;

@end

@implementation QukanBlingPointDetailHedaerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 当从xib上初始化时调用这个方法
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btn_collection.layer.masksToBounds = YES;
    self.btn_collection.layer.cornerRadius = 3;
    self.btn_collection.layer.borderWidth = 1;
    self.btn_collection.layer.borderColor = kThemeColor.CGColor;
    [self.btn_collection setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    
    self.lab_itemName.textColor = kThemeColor;
    
    self.lab_itemName.layer.masksToBounds = YES;
    self.lab_itemName.layer.cornerRadius = 10;
    self.lab_itemName.layer.borderWidth = 1;
    self.lab_itemName.layer.borderColor = kThemeColor.CGColor;
    
    
    [self.btn_collection setTitle:@"关注" forState:UIControlStateNormal];
    [self.btn_collection setTitle:@"已关注" forState:UIControlStateSelected];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    self.img_content.userInteractionEnabled = YES;
    [self.img_content addGestureRecognizer:tap];
}

#pragma mark ===================== privet modth ==================================
- (void)fullData:(QukanBolingPointListModel *)model {
    self.model_main = model;
    
    [self.img_userHeader sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    
    self.lab_userName.text = model.username;
    self.lab_creatTime.text = model.time;
    
    self.lab_content.text = model.content;
    [self.img_content sd_setImageWithURL:[NSURL URLWithString:model.images.firstObject] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    
    self.lab_itemName.text  = [NSString stringWithFormat:@"  %@  ",model.title];
    
    self.btn_collection.selected = (model.user_follow == 1);
}


#pragma mark ===================== action ==================================
- (IBAction)btn_collectionClick:(id)sender {
    
}
- (IBAction)btn_jubaoClick:(id)sender {
    
}

// 当图片点击时调用
- (void)clickImage:(UITapGestureRecognizer *)Qukan_tap {
    if (!self.vc_parent) {
        return;
    }
    
    KSPhotoItem *item = [[KSPhotoItem alloc] initWithSourceView:self.img_content imageUrl:[NSURL URLWithString:self.model_main.images.firstObject]];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.pageindicatorStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.bounces = NO;
    [browser showFromViewController:self.vc_parent];
}


@end
