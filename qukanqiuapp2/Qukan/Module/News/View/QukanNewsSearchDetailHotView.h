//
//  QukanNewsSearchDetailHotView.h
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanSearchHotModel.h"
typedef void(^ItemBlock)(NSString * _Nullable selectString);
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsSearchDetailHotView : UIView
@property (nonatomic, copy)ItemBlock itemBlock;
- (instancetype)initWithFrame:(CGRect)frame itemBlock:(ItemBlock)itemBlock;
@property (nonatomic, strong)NSMutableArray *dataArray;
- (CGFloat)heightOfHotView;
@end

NS_ASSUME_NONNULL_END
