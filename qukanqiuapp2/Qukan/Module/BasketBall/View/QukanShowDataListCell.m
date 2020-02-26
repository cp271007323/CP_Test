//
//  QukanShowDataListCell.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanShowDataListCell.h"
@interface QukanShowDataListCell ()

@end
@implementation QukanShowDataListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_leftPlayerHeader.backgroundColor = HEXColor(0xD1D1D1);
    self.img_leftPlayerHeader.layer.cornerRadius = self.img_leftPlayerHeader.width/2;
    self.img_rightPlayerHeader.backgroundColor = HEXColor(0xD1D1D1);
    self.img_rightPlayerHeader.layer.cornerRadius = self.img_rightPlayerHeader.width/2;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHomePlayerModel:(QukanHomeAndGuestPlayerListModel *)homePlayerModel guestPlayerModel:(QukanHomeAndGuestPlayerListModel *)guestPlayerModel indexPathRow:(NSInteger)indexPathRow midTitle:(NSString *)midTitle {
    //客队
    [self.img_leftPlayerHeader sd_setImageWithURL:[NSURL URLWithString:guestPlayerModel.photo?guestPlayerModel.photo:@""] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    //主队
    [self.img_rightPlayerHeader sd_setImageWithURL:[NSURL URLWithString:homePlayerModel.photo?homePlayerModel.photo:@""] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    //客队
    self.lab_leftPlayerNumber.text = guestPlayerModel.number;
    self.lab_leftPlayerName.text = guestPlayerModel.player;
    //主队
    self.lab_rightPlayerName.text = homePlayerModel.player;
    self.lab_rightPlayerNumber.text = homePlayerModel.number;
    self.midLab.text = midTitle;
    //@[@"得分",@"篮板",@"助攻",@"抢断",@"盖帽"];
    if (indexPathRow == 0) {
        //客队
        if (guestPlayerModel) {
            self.lab_leftPlayerGetNumber.text = guestPlayerModel.score;
        }
        //主队
        if (homePlayerModel) {
            self.lab_rightPlayerGetNumber.text = homePlayerModel.score;
        }
    } else if (indexPathRow == 1) {
        if (guestPlayerModel) {
            self.lab_leftPlayerGetNumber.text = [NSString stringWithFormat:@"%ld",guestPlayerModel.attack.integerValue+guestPlayerModel.defend.integerValue];
        }
        if (homePlayerModel) {
            self.lab_rightPlayerGetNumber.text = [NSString stringWithFormat:@"%ld",homePlayerModel.attack.integerValue+homePlayerModel.defend.integerValue];
        }
    } else if (indexPathRow == 2) {
        if (guestPlayerModel) {
            self.lab_leftPlayerGetNumber.text = guestPlayerModel.helpAttack;
        }
        if (homePlayerModel) {
            self.lab_rightPlayerGetNumber.text = homePlayerModel.helpAttack;
        }
    } else if (indexPathRow == 3) {
        if (guestPlayerModel) {
            self.lab_leftPlayerGetNumber.text = guestPlayerModel.rob;
        }
        if (homePlayerModel) {
            self.lab_rightPlayerGetNumber.text = homePlayerModel.rob;
        }
    } else if (indexPathRow == 4) {
        if (guestPlayerModel) {
            self.lab_leftPlayerGetNumber.text = guestPlayerModel.cover;
        }
        if (homePlayerModel) {
            self.lab_rightPlayerGetNumber.text = homePlayerModel.cover;
        }
    }
}
@end
