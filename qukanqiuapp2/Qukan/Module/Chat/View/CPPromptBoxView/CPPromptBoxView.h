//
//  CPTableView.h
//  绘制-tableView
//
//  Created by lk06 on 17/1/13.
//  Copyright © 2017年 lk06. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPrompt.h"

@class CPPromptBoxOption;

@interface CPPromptBoxView : UIView

/**初始化*/
+ (instancetype)promptBoxViewWithOption:(CPPromptBoxOption *)manager;

/**添加数据*/
- (void)addTitles:(NSArray *)titles
           images:(NSArray *)images
      didSelector:(CPPromptBoxClipBlock)block
   cancleSelector:(CPPromptBoxCancleBlock)cancle;

/**显示*/
- (void)showPrompt;

@end

@interface UITableViewCell (CPPromptBoxIdentifier)
+(NSString *)identifier;
@end



