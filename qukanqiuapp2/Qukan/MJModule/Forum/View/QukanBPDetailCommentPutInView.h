//
//  QukanBPDetailCommentPutInView.h
//  Qukan
//
//  Created by leo on 2019/10/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBPDetailCommentPutInView : UIView

// 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_zan;


// 主输入按钮点击
- (void)mainViewTap;

// 点赞按钮点击
- (IBAction)btn_zanClick:(id)sender;


@end

NS_ASSUME_NONNULL_END
