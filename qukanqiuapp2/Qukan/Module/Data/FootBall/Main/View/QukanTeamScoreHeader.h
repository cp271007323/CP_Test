//
//  QukanTeamScoreHeader.h
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanTeamScoreHeader : UIView

@property (strong, nonatomic) UILabel *label_1;

@property (strong, nonatomic) UILabel *label_3;
@property (strong, nonatomic) UILabel *label_4;
@property (strong, nonatomic) UILabel *label_5;
@property (strong, nonatomic) UILabel *label_6;
@property (strong, nonatomic) UILabel *label_7;
@property (strong, nonatomic) UILabel *label_8;

- (void)onlyShowTitle:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
