//
//  QukanDataFilterView.h
//  Qukan
//
//  Created by blank on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FilterBlock)(id _Nullable filterId);
@interface QukanDataFilterView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy)FilterBlock _Nullable leagueBlock;
- (instancetype _Nullable )initWithFrame:(CGRect)frame block:(FilterBlock _Nullable )block;
- (void)QukanLoadBSKFilterData;
- (void)configFtDatas:(NSArray*)ftSource;
@end

