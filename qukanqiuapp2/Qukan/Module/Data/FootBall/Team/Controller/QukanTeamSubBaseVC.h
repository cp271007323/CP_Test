//
//  QukanTeamSubBaseVC.h
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanTeamSubBaseVC : UIViewController<JXCategoryListContentViewDelegate>
- (instancetype)initWithModel:(id )model;
- (instancetype)initWithModel:(id )model atSeason:(NSString*)season;
- (id)myModel;
- (NSString*)season;
@end

NS_ASSUME_NONNULL_END
