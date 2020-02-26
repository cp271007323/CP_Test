//
//  QukanNewsSearchDetailFiledView.h
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsSearchDetailFiledView : UIView
@property (nonatomic, copy)void (^fieldBlock)(NSString *text);
@property (nonatomic, copy)void (^clearBlock)(void);
@property (nonatomic, copy)void (^clickFieldBlock)(void);
- (instancetype)initWithFrame:(CGRect)frame cancelBlock:(void (^)(void))cancelBlock fieldBlock:(void (^)(NSString *text))fieldBlock clearBlock:(void (^)(void))clearBlock clickFieldBlock:(void(^)(void))clickFieldBlock;
- (void)setPlaceholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END
