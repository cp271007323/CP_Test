//
//  CPPromptBox.h
//  测试
//
//  Created by lk03 on 2017/7/21.
//  Copyright © 2017年 chenp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPrompt.h"

@protocol CPPromptBoxDelegate <NSObject>

-(void)promptBoxSelector:(CPPromptBoxClipBlock)clipblock indexPath:(NSIndexPath *)indexPath;

@end

@interface CPPromptBox : UIView
@property (nonatomic , strong) CPPromptBoxOption        *option;
@property (nonatomic , strong) NSMutableArray           *titles;
@property (nonatomic , strong) NSMutableArray           *images;
@property (nonatomic , strong) CPPromptBoxClipBlock     block;
@property (nonatomic , assign) id<CPPromptBoxDelegate>  promitBoxDeleget;

+ (instancetype)promtBoxWithOption:(CPPromptBoxOption *)option;
- (instancetype)initWithPromtBoxOption:(CPPromptBoxOption *)option;
- (void)refreshPromitBoxView;
- (void)promitBoxRemoveFromSuperViewWithValues:(NSArray *)values isDelegate:(BOOL)isDelegate;
@end
