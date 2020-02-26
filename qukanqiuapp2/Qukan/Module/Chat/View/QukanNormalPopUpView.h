//
//  QukanNormalPopUpView.h
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CPCoverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanNormalPopUpView : CPCoverView

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *content;

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UILabel *contentLab;

@property (nonatomic , strong) UIButton *submitBtn;

@property (nonatomic , strong) UIButton *cancleBtn;

@end

NS_ASSUME_NONNULL_END
