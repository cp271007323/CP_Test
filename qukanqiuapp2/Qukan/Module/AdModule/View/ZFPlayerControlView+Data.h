//
//  ZFPlayerControlView+Data.h
//  Qukan
//
//  Created by jxc on 2019/10/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ZFPlayerControlView.h"
#import "QukanVideoView.h"
#import "QukanHomeModels.h"

@class QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN

@interface ZFPlayerControlView (Data)

@property(nonatomic, copy) void(^dataImageView_didBlock)(void);
@property(nonatomic, copy) void (^LandImageView_didBlock)(void);
@property(nonatomic, strong) QukanVideoView *portDataView;
@property(nonatomic, strong) QukanVideoView *landDataView;

//@property(nonatomic, strong) NSObject *adModel;

- (void)showDataViewWithModel:(QukanHomeModels *)adModel;
- (void)hideDataView;

@end

NS_ASSUME_NONNULL_END
