//
//  QukanNewsSearchDetailHotView.m
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewsSearchDetailHotView.h"
@interface QukanNewsSearchDetailHotView()
@property (nonatomic, strong)UILabel *hotLab;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIView *verticleLine;
@end
@implementation QukanNewsSearchDetailHotView
- (instancetype)initWithFrame:(CGRect)frame itemBlock:(ItemBlock)itemBlock{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.hotLab];
        [self.hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(19);
            make.height.offset(17);
        }];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.mas_equalTo(self.hotLab.mas_bottom).offset(11);
        }];
        
        [self.contentView addSubview:self.verticleLine];
        [self.verticleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.bottom.offset(0);
            make.width.offset(0.5);
        }];
        self.itemBlock = itemBlock;
        
    }
    return self;
}
- (CGFloat)heightOfHotView {
    return 19+17+11+(_dataArray.count/2 + 1) * 27;
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self initContentView];
}
- (void)initContentView {
    CGFloat width =  (kScreenWidth-SCALING_RATIO(65))/2;
    [self.contentView removeAllSubviews];
    for (int i = 0;i<_dataArray.count;i++) {
        QukanSearchHotModel *model = _dataArray[i];
        UIView *labBackView = [UIView new];
        [self.contentView addSubview:labBackView];
        [labBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 2 == 0) {
                make.left.offset(15);
            } else {
                make.right.offset(-15);
            }
            make.top.offset(i/2 *(20 + 7));
            make.height.offset(20);
            make.width.offset(width);
        }];
        
        UILabel *lab = [UILabel new];
        [labBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            make.width.mas_lessThanOrEqualTo(@(width-17));
        }];
        lab.text = model.title;
        lab.font = kFont14;
        lab.textColor = HEXColor(0x27313C);
        lab.numberOfLines = 0;
        UIColor *baoColor = kThemeColor;
        UIColor *reColor = HEXColor(0xF12B2B);
        
        UILabel *statusLab = [UILabel new];
        [labBackView addSubview:statusLab];
        [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_right).offset(3);
            make.width.height.offset(14);
            make.centerY.mas_equalTo(lab.mas_centerY).offset(0);
        }];
        statusLab.textColor = kCommonWhiteColor;
        statusLab.backgroundColor = model.isBurstPoint.integerValue == 1 ? baoColor :reColor;
        statusLab.layer.cornerRadius = 2;
        statusLab.layer.masksToBounds = 1;
        statusLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        statusLab.textAlignment = NSTextAlignmentCenter;
        statusLab.text = model.isBurstPoint.integerValue == 1 ? @"爆" : @"热";
        
        UIButton *btn = [UIButton new];
        [labBackView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_left).offset(0);
            make.top.bottom.offset(0);
            make.right.mas_equalTo(statusLab.mas_right).offset(0);
        }];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.itemBlock) {
                self.itemBlock(lab.text);
            }
        }];
    }
}

- (UIView *)verticleLine {
    if (!_verticleLine) {
        _verticleLine = [UIView new];
        _verticleLine.backgroundColor = kSecondTableViewBackgroudColor;
    }
    return _verticleLine;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}
- (UILabel *)hotLab {
    if (!_hotLab) {
        _hotLab = [UILabel new];
        _hotLab.textColor = kTextGrayColor;
        _hotLab.font = kFont12;
        _hotLab.text = @"热门搜索";
    }
    return _hotLab;
}
@end
