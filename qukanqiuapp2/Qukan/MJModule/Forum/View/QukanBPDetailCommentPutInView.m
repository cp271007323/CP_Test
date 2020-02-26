//
//  QukanBPDetailCommentPutInView.m
//  Qukan
//
//  Created by leo on 2019/10/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBPDetailCommentPutInView.h"

@interface QukanBPDetailCommentPutInView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewBottom;
@property (weak, nonatomic) IBOutlet UIView *view_comment;


@end


@implementation QukanBPDetailCommentPutInView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加底部安全距离
    self.constraint_viewBottom.constant =  10 + kSafeAreaBottomHeight;
    
    self.view_comment.layer.masksToBounds = YES;
    self.view_comment.layer.cornerRadius = 29 / 2;
    self.view_comment.layer.borderColor = UIColor.grayColor.CGColor;
    self.view_comment.layer.borderWidth = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTap)];
    
    self.view_comment.userInteractionEnabled = YES;
    [self.view_comment addGestureRecognizer:tap];
    
    
    [self.btn_zan setImage:kImageNamed(@"Qukan_zanH") forState:UIControlStateNormal];
    [self.btn_zan setImage:[kImageNamed(@"Qukan_zanH") imageWithColor:kThemeColor] forState:UIControlStateSelected];
    
}



// 主输入按钮点击
- (void)mainViewTap {
    
}

// 点赞点击
- (IBAction)btn_zanClick:(id)sender {
    
    
}
@end
