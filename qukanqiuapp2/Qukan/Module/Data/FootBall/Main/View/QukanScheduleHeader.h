//
//  QukanScheduleHeader.h
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanScheduleHeader : UIView
@property(nonatomic,copy) void(^scheduleHeaderClickAtButton)(UIButton* sender);
@property (strong, nonatomic) UIButton *curRoundBtn;

- (void)setRoundName:(NSString*)name;
- (NSString*)curRoundName;
@end

NS_ASSUME_NONNULL_END
