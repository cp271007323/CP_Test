//
//  QukanTYCyclePagerView.h
//  QukanTYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanTYCyclePagerTransformLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSInteger index;
    NSInteger section;
}TYIndexSection;

// pagerView scrolling direction
typedef NS_ENUM(NSUInteger, TYPagerScrollDirection) {
    TYPagerScrollDirectionLeft,
    TYPagerScrollDirectionRight,
};

@class QukanTYCyclePagerView;
@protocol QukanTYCyclePagerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPagerView:(QukanTYCyclePagerView *)pageView;

- (__kindof UICollectionViewCell *)pagerView:(QukanTYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index;

/**
 return pagerView layout,and cache layout
 */
- (QukanTYCyclePagerViewLayout *)layoutForPagerView:(QukanTYCyclePagerView *)pageView;

@end

@protocol QukanTYCyclePagerViewDelegate <NSObject>

@optional

/**
 pagerView did scroll to new index page
 */
- (void)pagerView:(QukanTYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 pagerView did selected item cell
 */
- (void)pagerView:(QukanTYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index;
- (void)pagerView:(QukanTYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndexSection:(TYIndexSection)indexSection;

// custom layout
- (void)pagerView:(QukanTYCyclePagerView *)pageView initializeTransformAttributes:(UICollectionViewLayoutAttributes *)attributes;

- (void)pagerView:(QukanTYCyclePagerView *)pageView applyTransformToAttributes:(UICollectionViewLayoutAttributes *)attributes;


// scrollViewDelegate

- (void)pagerViewDidScroll:(QukanTYCyclePagerView *)pageView;

- (void)pagerViewWillBeginDragging:(QukanTYCyclePagerView *)pageView;

- (void)pagerViewDidEndDragging:(QukanTYCyclePagerView *)pageView willDecelerate:(BOOL)decelerate;

- (void)pagerViewWillBeginDecelerating:(QukanTYCyclePagerView *)pageView;

- (void)pagerViewDidEndDecelerating:(QukanTYCyclePagerView *)pageView;

- (void)pagerViewWillBeginScrollingAnimation:(QukanTYCyclePagerView *)pageView;

- (void)pagerViewDidEndScrollingAnimation:(QukanTYCyclePagerView *)pageView;

@end


@interface QukanTYCyclePagerView : UIView

@property(nonatomic, strong) UIView *QukanDataViews;

// will be automatically resized to track the size of the pagerView
@property (nonatomic, strong, nullable) UIView *backgroundView; 

@property (nonatomic, weak, nullable) id<QukanTYCyclePagerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<QukanTYCyclePagerViewDelegate> delegate;

// pager view, don't set dataSource and delegate
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
// pager view layout
@property (nonatomic, strong, readonly) QukanTYCyclePagerViewLayout *layout;

/**
 is infinite cycle pageview
 */
@property (nonatomic, assign) BOOL isInfiniteLoop;

/**
 pagerView automatic scroll time interval, default 0,disable automatic
 */
@property (nonatomic, assign) CGFloat autoScrollInterval;

@property (nonatomic, assign) BOOL reloadDataNeedResetIndex;

/**
 current page index
 */
@property (nonatomic, assign, readonly) NSInteger curIndex;
@property (nonatomic, assign, readonly) TYIndexSection indexSection;

// scrollView property
@property (nonatomic, assign, readonly) CGPoint contentOffset;
@property (nonatomic, assign, readonly) BOOL tracking;
@property (nonatomic, assign, readonly) BOOL dragging;
@property (nonatomic, assign, readonly) BOOL decelerating;


/**
 reload data, !!important!!: will clear layout and call delegate layoutForPagerView
 */
- (void)reloadData;

/**
 update data is reload data, but not clear layuot
 */
- (void)updateData;

/**
 if you only want update layout
 */
- (void)setNeedUpdateLayout;

/**
 will set layout nil and call delegate->layoutForPagerView
 */
- (void)setNeedClearLayout;

/**
 current index cell in pagerView
 */
- (__kindof UICollectionViewCell * _Nullable)curIndexCell;

/**
 visible cells in pageView
 */
- (NSArray<__kindof UICollectionViewCell *> *_Nullable)visibleCells;


/**
 visible pageView indexs, maybe repeat index
 */
- (NSArray *)visibleIndexs;

/**
 scroll to item at index
 */
- (void)scrollToItemAtIndex:(NSInteger)index animate:(BOOL)animate;
- (void)scrollToItemAtIndexSection:(TYIndexSection)indexSection animate:(BOOL)animate;
/**
 scroll to next or pre item
 */
- (void)scrollToNearlyIndexAtDirection:(TYPagerScrollDirection)direction animate:(BOOL)animate;

/**
 register pager view cell with class
 */
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;

/**
 register pager view cell with nib
 */
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

/**
 dequeue reusable cell for pagerView
 */
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
