//
//  QukanScreenLiveLineView.h
//  Qukan
//
//  Created by Kody on 2019/8/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanLiveLineModel.h"

@class QukanLiveLineModel,QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN

@interface QukanScreenLiveLineView : UIView

@property(nonatomic, copy) void (^liveLineBolck)(QukanLiveLineModel *lineModel);
@property(nonatomic, copy) void (^adBolck)(QukanHomeModels *adModel);
- (instancetype)initWithFrame:(CGRect)frame WithDatas:(NSArray *)datas withAds:(NSArray *)ads;//1为登录 2为分享  place 1 为列表 2 为详情

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray <QukanLiveLineModel *>  *datas;
@property(nonatomic, strong) NSArray <QukanHomeModels *>  *ads;
@property(nonatomic, copy) void (^cancelBlock)(void);
@property(nonatomic, copy) void (^refreshBolck)(void);
@property(nonatomic, copy) void (^cellDidSeleLiveBolck)(QukanLiveLineModel *liveLineModel);
@property(nonatomic, copy) void (^cellDidSeleAdBolck)(QukanHomeModels *adModel);
@end

NS_ASSUME_NONNULL_END
