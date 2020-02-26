//
//  QukanDataSegmentView.h
//  Qukan
//
//  Created by blank on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Tag_Btn) {
    T_set       = 1,
    T_football,
    T_basketball,
    T_sport_event,
};
NS_ASSUME_NONNULL_BEGIN

@interface QukanDataSegmentView : UIView
- (instancetype)initWithFrame:(CGRect)frame segmentBlock:(void (^)(Tag_Btn tag))segBlock;
@end

NS_ASSUME_NONNULL_END
