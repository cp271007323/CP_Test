//
//  QukanTeamScoreCell.h
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanTeamScoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanTeamScoreCell : UITableViewCell
@property (strong, nonatomic) UILabel *label_1;
@property (strong, nonatomic) UIImageView *flagV;
@property (strong, nonatomic) UILabel *label_2;
@property (strong, nonatomic) UILabel *label_3;
@property (strong, nonatomic) UILabel *label_4;
@property (strong, nonatomic) UILabel *label_5;
@property (strong, nonatomic) UILabel *label_6;
@property (strong, nonatomic) UILabel *label_7;
@property (strong, nonatomic) UILabel *label_8;

@property (strong, nonatomic) UILabel *upGradeLabel;

@property (strong, nonatomic) UIView *cutLine;


- (void)setModel:(QukanTeamScoreModel*)model;

//- setCutLineColor:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
