//
//  QukanCustomTabbarItem.h
//  Qukan
//
//  Created by leo on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@class QukanCustomTabItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanCustomTabbarItem : UIControl

- (instancetype)initWithFrame:(CGRect)frame andTabModel:(QukanCustomTabItemModel *)model;

/**是否选中*/
@property(nonatomic, assign) BOOL    QukanIsSelect_bool;

// item的所在索引
@property(nonatomic, assign) NSInteger QukanIndex_int;

@end

NS_ASSUME_NONNULL_END
