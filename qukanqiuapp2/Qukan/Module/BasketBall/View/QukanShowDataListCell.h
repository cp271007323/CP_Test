//
//  QukanShowDataListCell.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanShowDataListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *img_leftPlayerHeader;
@property (weak, nonatomic) IBOutlet UIImageView *img_rightPlayerHeader;
@property (weak, nonatomic) IBOutlet UILabel *lab_leftPlayerNumber;
@property (weak, nonatomic) IBOutlet UILabel *lab_rightPlayerNumber;
@property (weak, nonatomic) IBOutlet UILabel *lab_rightPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *lab_leftPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *midLab;

@property (weak, nonatomic) IBOutlet UILabel *lab_leftPlayerGetNumber;
@property (weak, nonatomic) IBOutlet UILabel *lab_rightPlayerGetNumber;
- (void)setHomePlayerModel:(QukanHomeAndGuestPlayerListModel *)homePlayerModel guestPlayerModel:(QukanHomeAndGuestPlayerListModel *)guestPlayerModel indexPathRow:(NSInteger)indexPathRow midTitle:(NSString *)midTitle;
@end

NS_ASSUME_NONNULL_END
