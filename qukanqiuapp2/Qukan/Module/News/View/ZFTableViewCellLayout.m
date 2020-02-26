//
//  ZFTableViewCellLayout.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/5/22.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCellLayout.h"

@interface ZFTableViewCellLayout ()

@property (nonatomic, assign) CGRect headerRect;
@property (nonatomic, assign) CGRect nickNameRect;
@property (nonatomic, assign) CGRect videoRect;
@property (nonatomic, assign) CGRect imageViewRect;
@property (nonatomic, assign) CGRect playBtnRect;
@property (nonatomic, assign) CGRect titleLabelRect;
@property (nonatomic, assign) CGRect leagueNameLabelRect;
@property (nonatomic, assign) CGRect readLabelRect;
@property (nonatomic, assign) CGRect commonLabelRect;
@property (nonatomic, assign) CGRect filterBtnRect;
@property (nonatomic, assign) CGRect pulishTimeLabelRect;
@property (nonatomic, assign) CGRect maskViewRect;
@property (nonatomic, assign) CGRect commentImageViewRect;
@property (nonatomic, assign) BOOL isVerticalVideo;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ZFTableViewCellLayout

- (instancetype)initWithData:(QukanNewsModel *)data {
    self = [super init];
    if (self) {
        _data = data;
        
        CGFloat min_x = 0;
        CGFloat min_y = 0;
        CGFloat min_w = 0;
        CGFloat min_h = 0;
        CGFloat min_view_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat margin = 8;
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.videoHeight;
        self.videoRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = 15;
        min_y = 10;
        min_w = min_view_w - 30;
        min_h = self.videoHeight - 10;
        self.imageViewRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_w = 50;
        min_h = min_w;
        min_x = (CGRectGetWidth(self.imageViewRect)-min_w)/2;
        min_y = (CGRectGetHeight(self.imageViewRect)-min_h)/2;
        self.playBtnRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = 16;
        min_y = CGRectGetMaxY(self.videoRect) + margin;
        min_w = CGRectGetWidth(self.videoRect) - 3*margin;
        min_h = [data.title heightForFont:kFont15 width:min_w];
        self.titleLabelRect = CGRectMake(15, min_y, min_w - 20, 24);
        
        self.readLabelRect = CGRectMake(15, CGRectGetMaxY(self.titleLabelRect) + 4, 50, 16);
        self.commentImageViewRect = CGRectMake(CGRectGetMaxX(self.readLabelRect)+5, CGRectGetMaxY(self.titleLabelRect) + 4, 30, 16);
        self.commonLabelRect = CGRectMake(CGRectGetMaxX(self.commentImageViewRect)+0, CGRectGetMaxY(self.titleLabelRect) + 4, 40, 16);
        self.pulishTimeLabelRect = CGRectMake(kScreenWidth - 150, CGRectGetMaxY(self.titleLabelRect) + 4, 140, 16);
        
        self.filterBtnRect = CGRectMake(kScreenWidth-40, CGRectGetMinY(self.commonLabelRect)-35, 40, 40);
        
        self.height = CGRectGetMaxY(self.commonLabelRect)+margin;
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.height;
        self.maskViewRect = CGRectMake(min_x, min_y, min_w, min_h);
        
    }
    return self;
}

- (CGFloat)videoHeight {
    return 180;
}

@end
