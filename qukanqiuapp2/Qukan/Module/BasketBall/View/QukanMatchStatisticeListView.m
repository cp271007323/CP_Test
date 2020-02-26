//
//  QukanMatchStatisticeListView.m
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchStatisticeListView.h"



@implementation QukanMatchStatisticeListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *v = [UIView new];
    v.backgroundColor = HEXColor(0xE3E2E2);
    [self addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setSourceArr:(NSArray<NSString *> *)sourceArr {
    if (_sourceArr != sourceArr) {
        _sourceArr = sourceArr;
        
        [self removeAllSubviews];
        NSInteger c = _sourceArr.count <= 1 ? 1 : (_sourceArr.count-1);
        CGFloat itWidth = (kScreenWidth - teamNameWidth) / c;
        for (int i = 0; i < sourceArr.count; i ++) {
//            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(teamNameWidth + itemMargin + (itWidth +itemMargin) * i, 0, itWidth, itemHeight)];
//            if (i == 0) {
//                 lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, teamNameWidth, itemHeight)];
//            }
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                lab.frame = CGRectMake(0, 0, teamNameWidth, itemHeight);
            }else {
                lab.frame = CGRectMake(teamNameWidth + itemMargin + (itWidth +itemMargin) * (i - 1), 0, itWidth, itemHeight);
            }
            
            lab.text = sourceArr[i];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = kFont11;
            lab.textColor = kTextGrayColor;
            [self addSubview:lab];
        }
    }
}


- (void)setTeamSourceArr:(NSArray<NSString *> *)teamSourceArr {
    if (_teamSourceArr != teamSourceArr) {
        _teamSourceArr = teamSourceArr;
        
        [self removeAllSubviews];
        NSInteger c = _teamSourceArr.count <= 1 ? 1 : (_teamSourceArr.count-1);
        CGFloat itWidth = (kScreenWidth - teamNameWidth) / c;
        for (int i = 0; i < teamSourceArr.count; i ++) {
            
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                lab.frame = CGRectMake(0, 0, teamNameWidth, itemHeight);
            }else {
                lab.frame = CGRectMake(teamNameWidth + itemMargin + (itWidth +itemMargin) * (i - 1), 0, itWidth, itemHeight);
            }
            lab.text = teamSourceArr[i];
            lab.textAlignment = NSTextAlignmentCenter;
            
            lab.font = kFont11;
            lab.textColor = kCommonTextColor;
            [self addSubview:lab];
        }
        
    }
}
@end
