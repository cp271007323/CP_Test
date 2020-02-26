//
//  ZFTableViewCellLayout.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/5/22.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanNewsModel.h"

@interface ZFTableViewCellLayout : NSObject
@property (nonatomic, strong) QukanNewsModel *data;
@property (nonatomic, readonly) CGRect headerRect;
@property (nonatomic, readonly) CGRect nickNameRect;
@property (nonatomic, readonly) CGRect videoRect;
@property (nonatomic, readonly) CGRect imageViewRect;
@property (nonatomic, readonly) CGRect playBtnRect;
@property (nonatomic, readonly) CGRect titleLabelRect;
@property (nonatomic, readonly) CGRect leagueNameLabelRect;
@property (nonatomic, readonly) CGRect readLabelRect;
@property (nonatomic, readonly) CGRect commonLabelRect;
@property (nonatomic, readonly) CGRect filterBtnRect;
@property (nonatomic, readonly) CGRect pulishTimeLabelRect;
@property (nonatomic, readonly) CGRect maskViewRect;
@property (nonatomic, readonly) CGRect commentImageViewRect;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) BOOL isVerticalVideo;

- (instancetype)initWithData:(QukanNewsModel *)data;

@end
