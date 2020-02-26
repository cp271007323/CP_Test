//
//  QukanMatchStatisticeListView.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

// 左方队名的宽度
#define teamNameWidth  90
// 单位的宽度
#define itemWidth (kScreenWidth - teamNameWidth) / 5
// 单位的高度
#define itemHeight  30
// 单位之间的间距
#define itemMargin  1


NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchStatisticeListView : UIView

@property(nonatomic, strong) NSArray<NSString *>   * sourceArr;

@property(nonatomic, strong) NSArray<NSString *>   * teamSourceArr;

@end

NS_ASSUME_NONNULL_END
