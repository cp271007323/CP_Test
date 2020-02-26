//
//  QukanNewsSearchDetailHistoryView.h
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsSearchDetailHistoryView : UIView
@property (nonatomic, copy)void (^itemClickBlock)(NSString *selectString);
- (void)setData:(NSArray *)array;
- (instancetype)initWithFrame:(CGRect)frame itemSelectBlock:(void (^)(NSString *selectString))itemSelect deleteBlock:(void (^)(void))deleteBlock;
- (CGFloat)heightOfHistoryView;
- (void)reloadMcollectionData;
@end

NS_ASSUME_NONNULL_END
