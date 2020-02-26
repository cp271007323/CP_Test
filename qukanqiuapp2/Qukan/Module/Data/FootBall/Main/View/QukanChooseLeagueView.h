//
//  QukanChooseLeagueView.h
//  Qukan
//
//  Created by Charlie on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanChooseLeagueView : UIView

@property(nonatomic,copy) void(^leagueSelectedBlock)(NSInteger menuIndex, NSInteger leagueIndex);

-(instancetype) initWithFrame:(CGRect)frame dataSource:(NSArray<NSArray*>*)datas;

@end

NS_ASSUME_NONNULL_END
