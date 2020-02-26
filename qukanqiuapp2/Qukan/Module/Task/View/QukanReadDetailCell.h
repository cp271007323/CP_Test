//
//  QukanReadDetailCell.h
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanReadDetailCell : UITableViewCell
/**白色背景*/
@property (weak, nonatomic) IBOutlet UIView *viewWhiteBG;

@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (weak, nonatomic) IBOutlet UILabel *labMon;
/**状态*/
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *labTime;
/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *labContent;

/**赋值 image - 0=失败 1=成功 2=中 3=等待确认*/
-(void)setmaiType:(NSString *)type labmai:(NSString *)labMai image:(NSInteger)image labTime:(NSString *)labTime;

@end

NS_ASSUME_NONNULL_END
