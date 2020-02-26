//
//  QukanUpGradePopView.h
//  Qukan
//
//  Created by Charlie on 2020/1/18.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanUpGradePopView : UIView

- (instancetype)initWithFrame:(CGRect)frame upgradeUrl:(NSString*)url isForce:(BOOL)force info:(NSString *)upInfo;

@end

NS_ASSUME_NONNULL_END
