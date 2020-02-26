//
//  QukanBlingPointDetailHedaerView.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanBolingPointListModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBlingPointDetailHedaerView : UIView
// 关注按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_collection;

// 设置父控制器  用于显示浏览图片
@property(nonatomic, strong) UIViewController   * vc_parent;

// 赋值
- (void)fullData:(QukanBolingPointListModel *)model;

- (IBAction)btn_collectionClick:(id)sender;
- (IBAction)btn_jubaoClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
