//
//  QukanFilterMatchViewController.h
//  Qukan
//
//  Created by pfc on 2019/9/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanFilterMatchViewController : UIViewController<JXCategoryListContainerViewDelegate>

@property (nonatomic, assign) NSInteger Qukan_type;
@property (nonatomic, copy) NSString *Qukan_labelFlag;
@property (nonatomic, copy) NSString *Qukan_leagueIds;
@property (nonatomic, assign) NSInteger Qukan_fixDays;
@property (nonatomic, assign) BOOL Qukan_all;
//@property(nonatomic, strong, readonly) NSMutableArray *Qukan_dataArray;
@property(nonatomic, copy, readonly) NSArray<NSArray*> *matchArray;
@property (nonatomic, assign) NSInteger Qukan_allMatchCount;
@property (nonatomic, assign) NSInteger Qukan_selectedMatchCount;
@property(nonatomic, copy) void(^Qukan_selectedBlock)(void);
- (void)Qukan_allAndReverseSelected:(BOOL)isAllSelected;

@end

NS_ASSUME_NONNULL_END
