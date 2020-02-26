//
//  QukanTextLiveCell.h
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class QukanTextLiveModel;
@class QukanBasketBallMatchModel;
@interface QukanTextLiveCell : UITableViewCell

- (void)fullCellWithModel:(QukanTextLiveModel *)model andmatchModel:(QukanBasketBallMatchModel *)baskModel;

@end

NS_ASSUME_NONNULL_END
