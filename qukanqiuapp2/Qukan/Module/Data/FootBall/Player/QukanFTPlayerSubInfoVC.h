//
//  QukanFTPlayerSubInfoVC.h
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanTeamSubBaseVC.h"
#import "QukanMemberIntroModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanFTPlayerSubInfoVC : QukanTeamSubBaseVC
- (void)configWithBasicData:(QukanMemberIntroModel*)model;
@end

NS_ASSUME_NONNULL_END
