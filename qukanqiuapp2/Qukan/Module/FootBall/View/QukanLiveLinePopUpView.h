//
//  QukanLiveLinePopUpView.h
//  Qukan
//
//  Created by Kody on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QukanLiveLinePopUpViewDelegate <NSObject>
// 选中传出模型
- (void)QukanLiveLinePopUpViewchooseCompletWithModel:(id _Nullable )mainModel;

// 释放view
- (void)QukanLiveLinePopUpViewRereaseView;

/**刷新按钮点击*/
- (void)QukanLiveLinePopUpViewBtn_refreshClick;

@end


NS_ASSUME_NONNULL_BEGIN

@class QukanLiveLineModel;

@interface QukanLiveLinePopUpView : UIView

@property(nonatomic, weak) id <QukanLiveLinePopUpViewDelegate>   delegate;


- (void)showWithBeginData:(NSArray  <QukanLiveLineModel *> *)datas andAds:(NSArray  <QukanHomeModels *> *)ads;

/**刷新直播数据源*/
- (void)refreshWithDatas:( NSArray  <QukanLiveLineModel *> * _Nullable)datas;
/**刷新广告数据源*/
- (void)refreshWithAds:( NSArray  <QukanHomeModels *> * _Nullable)datas;


@end

NS_ASSUME_NONNULL_END
