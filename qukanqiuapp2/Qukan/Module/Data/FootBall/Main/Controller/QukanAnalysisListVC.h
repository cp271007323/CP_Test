//
//  QukanAnalysisListVC.h
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "QukanLeagueInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface QukanAnalysisListVC : UIViewController<JXCategoryListContentViewDelegate>
-(instancetype)initWithLeagueInfo:(QukanLeagueInfoModel*)model;
@end

NS_ASSUME_NONNULL_END
