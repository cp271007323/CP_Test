//
//  ZFPlayerControlView+Data.m
//  Qukan
//
//  Created by jxc on 2019/10/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ZFPlayerControlView+Data.h"

static NSString * const kControlViewAdKeyPort = @"kControlViewAdKeyPort";
static NSString * const kControlViewAdKeyLand = @"kControlViewAdKeyLand";

@implementation ZFPlayerControlView (Data)

#pragma mark ===================== Public Methods =======================

- (void)showDataViewWithModel:(QukanHomeModels *)adModel {
    [self addPortViewWithModel:adModel];
    [self addLanViewWithModel:adModel];
    
    @weakify(self)
    self.portDataView.dataImageView_didBlock = ^{
        @strongify(self)
        if (self.dataImageView_didBlock) {
            self.dataImageView_didBlock();
        }
    };
    
    self.landDataView.dataImageView_didBlock = ^{
        @strongify(self)
        //        if (self.dataImageView_didBlock) {
        //            self.dataImageView_didBlock();
        //        }
        if (self.LandImageView_didBlock) {
            self.LandImageView_didBlock();
        }
    };
    
    self.portDataView.cancelButton_didBlock = ^{
        @strongify(self)
        [self hideDataView];
    };
    
    self.landDataView.cancelButton_didBlock = ^{
        @strongify(self)
        [self hideDataView];
    };
}

- (void)addPortViewWithModel:(QukanHomeModels *)adModel {
    if ([self.portDataView isKindOfClass:[QukanVideoView class]]) {
        return;
    }
    if (self.portDataView == nil) {
        self.portDataView = [[QukanVideoView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) WithModel:adModel];
    }
    [self.portDataView setDataSource:adModel];
    [self.portraitControlView addSubview:self.portDataView];
    [self.portDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitControlView).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.portraitControlView).offset(-40);
    }];
}

- (void)addLanViewWithModel:(QukanHomeModels *)adModel {
    if ([self.landDataView isKindOfClass:[QukanVideoView class]]) {
        return;
    }
    if (self.landDataView == nil) {
        self.landDataView = [[QukanVideoView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) WithModel:adModel];
    }
    [self.landDataView setDataSource:adModel];
    
    [self.landScapeControlView addSubview:self.landDataView];
    [self.landDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.landScapeControlView).offset(isIPhoneXSeries()?50:10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.landScapeControlView).offset(-80);
    }];
}

- (void)hideDataView {
    [self.landDataView removeFromSuperview];
    [self.landDataView removeAllSubviews];
    [self.portDataView removeFromSuperview];
    [self.portDataView removeAllSubviews];
    self.landDataView = nil;
    self.portDataView = nil;
}



#pragma mark ===================== Getters =================================

//- (void)setShowView:(QukanVideoView *)adView
//{
//    if (adView != self.adView) {
//        objc_setAssociatedObject(self, &kControlViewAdKey, adView, OBJC_ASSOCIATION_RETAIN);
//    }
//}


- (void)setPortDataView:(QukanVideoView *)portDataView {
    if (portDataView != self.portDataView) {
        objc_setAssociatedObject(self, &kControlViewAdKeyPort, portDataView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (QukanVideoView *)portDataView {
    return objc_getAssociatedObject(self, &kControlViewAdKeyPort);
}

- (void)setLandDataView:(QukanVideoView *)landDataView {
    if (landDataView != self.landDataView) {
        objc_setAssociatedObject(self, &kControlViewAdKeyLand, landDataView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (QukanVideoView *)landDataView {
    return objc_getAssociatedObject(self, &kControlViewAdKeyLand);
}


- (void (^)(void))dataImageView_didBlock {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setDataImageView_didBlock:(void (^)(void))dataImageView_didBlock {
    objc_setAssociatedObject(self, @selector(dataImageView_didBlock), dataImageView_didBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))LandImageView_didBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLandImageView_didBlock:(void (^)(void))LandImageView_didBlock {
    objc_setAssociatedObject(self, @selector(LandImageView_didBlock), LandImageView_didBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
