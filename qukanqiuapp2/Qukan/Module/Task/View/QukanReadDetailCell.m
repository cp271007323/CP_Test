//
//  QukanReadDetailCell.m
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//
#import "QukanReadDetailCell.h"
@implementation QukanReadDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.viewWhiteBG.layer.masksToBounds = YES;
    self.viewWhiteBG.layer.cornerRadius = 10;
    self.viewWhiteBG.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.viewWhiteBG.layer.shadowOffset = CGSizeMake(0,1);
    self.viewWhiteBG.layer.shadowOpacity = 1;
    self.viewWhiteBG.layer.shadowRadius = 5;
    
}

#pragma mark -赋值
-(void)setmaiType:(NSString *)type labmai:(NSString *)labMai image:(NSInteger)image labTime:(NSString *)labTime {
    self.labType.text = type;
    self.labMon.text = [NSString stringWithFormat:@"￥%@",labMai];
    self.labTime.text = labTime;
    QukanPersonModel *model = [kCacheManager QukangetStStatus];
    switch (image) {
        case 0:
            [self.btnTitle setImage:kImageNamed(@"Qukan_waitSure") forState:UIControlStateNormal];
            [self.btnTitle setTitle:@"确认中…" forState:UIControlStateNormal];
            self.labContent.text = FormatString(@"%@异常,等待客服确认中",model.pageNum);
            break;
        case 1:
            [self.btnTitle setImage:kImageNamed(@"Qukan_moreIng") forState:UIControlStateNormal];
            [self.btnTitle setTitle:FormatString(@"%@中",kStStatus.phone) forState:UIControlStateNormal];
            self.labContent.text = FormatString(@"正在%@中",kStStatus.phone);
            
            break;
        case 2:
            [self.btnTitle setImage:kImageNamed(@"Qukan_tipSuccess") forState:UIControlStateNormal];
            [self.btnTitle setTitle:FormatString(@"%@成功",model.pageNum) forState:UIControlStateNormal];
            self.labContent.text = FormatString(@"%@成功",model.pageNum);
            break;
        case 3:
            
            [self.btnTitle setImage:kImageNamed(@"Qukan_optFail") forState:UIControlStateNormal];
            [self.btnTitle setTitle:FormatString(@"%@失败",model.pageNum) forState:UIControlStateNormal];
            self.labContent.text = FormatString(@"%@失败了,点击查看原因",model.pageNum);
            break;
    }
}

@end
