//
//  MembersView.h
//  ixcode
//
//  Created by Mac on 2019/11/13.
//  Copyright © 2019 macmac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MembersView : UIButton

/// 是否是群主
@property (nonatomic , assign) BOOL isGroup;

+ (instancetype)membersView;

@end

NS_ASSUME_NONNULL_END
