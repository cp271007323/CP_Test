//
//  QukanBoilingPointDetailHeaderView.m
//  Qukan
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanBoilingPointDetailHeaderView.h"
#import "QukanBoilingPointTableViewModel_1.h"

@interface QukanBoilingPointDetailHeaderView()
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *followCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *topicCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (nonatomic, strong) QukanBoilingPointTableViewModel_1 *model;


@end

@implementation QukanBoilingPointDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.followButton.layer.cornerRadius = 12.5;
    self.followButton.layer.masksToBounds = YES;
    
    [self.followButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    self.view_content.layer.cornerRadius = 10;
    self.view_content.layer.borderColor = kCommentBackgroudColor.CGColor;
    self.view_content.layer.borderWidth = 0.5;
    
    self.view_content.layer.shadowColor = kCommonBlackColor.CGColor;
    //阴影的透明度
    self.view_content.layer.shadowOpacity = 0.3f;
    //阴影的圆角
    self.view_content.layer.shadowRadius = 4.f;
    //阴影偏移量
    self.view_content.layer.shadowOffset = CGSizeMake(4,4);
    
    self.view_line.layer.shadowColor = kCommonBlackColor.CGColor;
    //阴影的透明度
    self.view_line.layer.shadowOpacity = 0.8f;
    //阴影偏移量
    self.view_line.layer.shadowOffset = CGSizeMake(4,4);
}

- (void)setData:(QukanBoilingPointTableViewModel_1 *)model {
    self.model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"Qukan_placeholder"]];
    [self.followButton setTitle:model.is_follow?@"已关注":@"关注" forState:UIControlStateNormal];
    self.followCountLabel.text = [NSString stringWithFormat:@"%ld", model.fansCount];
    self.topicCountLabel.text = [NSString stringWithFormat:@"%ld", model.postCount];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.summary;
}

- (IBAction)followBtnClick {
    kGuardLogin
    
    NSString *operation = self.model.is_follow?@"N":@"Y";
    [QukanNetworkTool Qukan_POST:@"v3/posts/users/like" parameters:@{@"moduleId":[NSNumber numberWithInteger:self.model.infoId], @"operation":operation} success:^(NSDictionary *response) {
        if ([response[@"status"] integerValue]==200) {
            self.model.is_follow = !self.model.is_follow;
            [self.followButton setTitle:self.model.is_follow?@"已关注":@"关注" forState:UIControlStateNormal];
            NSDictionary *dict = @{@"InfoId":[NSNumber numberWithInteger:self.model.infoId],
                                   @"IsFollow":[NSNumber numberWithInteger:self.model.is_follow]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QukanBoilingPointDetailFollowNotificationName" object:dict];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"操作失败"];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end
