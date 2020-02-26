//
//  QukanErrorCommentView.h
//  Qukan
//
//  Created by Kody on 2019/9/26.
//  Copyright © 2019 chiyuan inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanErrorCommentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lab_errorContent;
@property (weak, nonatomic) IBOutlet UIButton *btn_fk;
@property (weak, nonatomic) IBOutlet UIButton *btn_colse;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_labBottom;


- (void)fullViewWithTitle:(NSString *)content BtnTitle:(NSString *)btnTitle BtnClickBlock:(void (^)(void))btnClickBlock showClose:(BOOL)showCloseBtn;

@end

NS_ASSUME_NONNULL_END
