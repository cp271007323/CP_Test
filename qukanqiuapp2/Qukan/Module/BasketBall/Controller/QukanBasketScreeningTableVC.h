//
//  QukanBasketScreeningTableVC.h
//  Qukan
//
//  Created by leo on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JXCategoryView/JXCategoryListContainerView.h>

@interface QukanBasketScreeningTableVC : QukanViewController<JXCategoryListContainerViewDelegate>
@property (nonatomic, assign) NSInteger Qukan_type;
@property (nonatomic, copy) NSString *Qukan_labelFlag;
@property (nonatomic, copy) NSString *Qukan_leagueIds;
@property (nonatomic, assign) NSInteger Qukan_fixDays;
@property (nonatomic, assign) BOOL Qukan_all;
@property(nonatomic, strong) NSMutableArray *Qukan_dataArray;
@property (nonatomic, assign) NSInteger Qukan_allMatchCount;
@property (nonatomic, assign) NSInteger Qukan_selectedMatchCount;
@property(nonatomic, copy) void(^Qukan_selectedBlock)(void);
- (void)Qukan_allAndReverseSelected:(BOOL)isAllSelected;

@end

