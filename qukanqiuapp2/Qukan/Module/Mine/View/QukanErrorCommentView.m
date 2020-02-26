//
//  QukanErrorCommentView.m
//  Qukan
//
//  Created by Kody on 2019/9/26.
//  Copyright © 2019 chiyuan inc. All rights reserved.
//

#import "QukanErrorCommentView.h"

@interface QukanErrorCommentView ()

@property(nonatomic, copy) void (^btnClickBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_contentTop;

@end


@implementation QukanErrorCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.btn_fk setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btn_closeClick:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)btn_mainBtnClick:(id)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

- (void)fullViewWithTitle:(NSString *)content BtnTitle:(NSString *)btnTitle BtnClickBlock:(void (^)(void))btnClickBlock showClose:(BOOL)showCloseBtn{
    
    self.btn_colse.hidden = !showCloseBtn;
    if (showCloseBtn) {
        self.constraint_contentTop.constant = 50;
    }else {
        self.constraint_contentTop.constant = 20;
    }
    if (btnTitle.length > 0) {
        self.btn_fk.hidden = NO;
        self.constraint_labBottom.constant = 75;
        [self.btn_fk setTitle:btnTitle forState:UIControlStateNormal];
        self.btnClickBlock = btnClickBlock;
    }else {
        self.btn_fk.hidden = YES;
        self.constraint_labBottom.constant = 50;
    }
    
    
    self.lab_errorContent.text = content;
    
    
}


- (void)dealloc {
    NSLog(@"yichu ");
}
@end
