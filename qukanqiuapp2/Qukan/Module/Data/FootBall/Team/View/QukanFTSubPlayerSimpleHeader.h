//
//  QukanFTSubPlayerSimpleHeader.h
//  Qukan
//
//  Created by Charlie on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanFTSubPlayerSimpleHeader : UITableViewHeaderFooterView

@property(nonatomic,strong) UILabel* nameLabel;
@property(nonatomic,strong) UILabel* positionLabel;
@property(nonatomic,strong) UILabel* goalLabel;
@property(nonatomic,strong) UILabel* assistLabel;
@property(nonatomic,strong) UILabel* worthLabel;

@end

NS_ASSUME_NONNULL_END
