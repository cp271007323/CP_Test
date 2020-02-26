//
//  QukanNewsCellLayout.m
//  Qukan
//
//  Created by pfc on 2019/7/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsCellLayout.h"
#import "QukanNewsModel.h"
#import <YYKit/NSAttributedString+YYText.h>

#define kCellTopMargin 15
#define kCellPadding 12 // 内边距
#define kCellPaddingPicture 4 // 多张图片的间隙
#define kCellImageWidth 139 // 列表图片宽高
#define kCellImageHight 88 // 列表图片宽高
#define kCellBrifeViewHeight 24

@interface QukanNewsCellLayout ()

@property(nonatomic, strong, readwrite) QukanNewsModel  *newsModel;

@property(nonatomic, assign, readwrite) CGRect headViewRect;
@property(nonatomic, assign, readwrite) CGRect contentRect;
@property(nonatomic, assign, readwrite) CGRect imageViewRect;
@property(nonatomic, copy, readwrite) NSArray* mutableImageViewRects;
@property(nonatomic, assign, readwrite) CGRect infoViewRect;
@property(nonatomic, assign, readwrite) CGRect filterBtnRect;

@property(nonatomic, assign, readwrite) CGFloat height;

@end

@implementation QukanNewsCellLayout

- (instancetype)initWithNewsModel:(QukanNewsModel *)newsModel {
    self = [super init];
    if (self) {
        _newsModel = newsModel;
    
        CGFloat h = 0;
        NSString *title = _newsModel.title;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title attributes:nil];
        attStr.color = kCommonBlackColor;
        attStr.font = kFont15;
        
        BOOL shouldLayoutRightImage = self.newsModel.imageUrl.length >= 1;
        CGFloat contentWidth = kScreenWidth - (shouldLayoutRightImage ? kCellImageWidth+32 : 32);
        _contentRect = CGRectMake(kCellPadding, kCellTopMargin, contentWidth, 35);
        _filterBtnRect = CGRectMake(contentWidth-25, CGRectGetMaxY(_contentRect)-25, 40, 30);
        
        h += CGRectGetHeight(_contentRect) + 2*kCellTopMargin;
        if (shouldLayoutRightImage) {
            _imageViewRect = CGRectMake(kScreenWidth-kCellImageWidth-kCellPadding, kCellTopMargin, kCellImageWidth, kCellImageHight);
            h += CGRectGetHeight(_contentRect) > CGRectGetHeight(_imageViewRect) ? 0 : CGRectGetHeight(_imageViewRect) - CGRectGetHeight(_contentRect);
        }
        _infoViewRect = CGRectMake(0, h - 20, kScreenWidth, kCellBrifeViewHeight);
        h += CGRectGetHeight(_infoViewRect) - 15;
        _height = h;
    }
    return self;
}

@end
