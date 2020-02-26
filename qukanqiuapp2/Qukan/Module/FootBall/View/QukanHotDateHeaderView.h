//
//  QukanHotDateHeaderView.h
//  Qukan
//
//  Created by Kody on 2019/6/26.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHotDateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanHotDateHeaderView : UIView

@property (nonatomic, copy) void(^QukanHot_didBlock)(void);
@property (nonatomic, copy) void(^QukanFocus_didBlock)(void);
@property (nonatomic, strong)UILabel   *timeLabel;

//- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;
- (void)setDataWithData:(QukanHotDateModel *)model;
- (void)setDataWithTime:(NSString *)timeStr;

@end

NS_ASSUME_NONNULL_END
