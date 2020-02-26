//
//  QukanMatchDetailLSJFHeaderView.m
//  Qukan
//
//  Created by leo on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMatchDetailLSJFHeaderView.h"
#import "QukanMatchDetailHistoryModel.h"

#import "QukanSharpBgView.h"

// 当数量为0时 显示的宽度
#define kWidthWhenIsZero 40

@interface QukanMatchDetailLSJFHeaderView ()

/**主队名称*/
@property(nonatomic, strong) UILabel   * lab_homeName;
/**客队名称*/
@property(nonatomic, strong) UILabel   * lab_awayName;
/**概况*/
@property(nonatomic, strong) UILabel   * lab_totleMatchDis;

/**展示数据view*/
@property(nonatomic, strong) UIView   * view_displayContent;

/**输赢总概况*/
@property(nonatomic, strong) UILabel   * lab_totleLoseWin;



@end

@implementation QukanMatchDetailLSJFHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self addSubview:self.lab_homeName];
    [self addSubview:self.lab_totleMatchDis];
    [self addSubview:self.lab_awayName];
    
    [self.lab_homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(20));
    }];
    
    [self.lab_totleMatchDis mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_homeName.mas_right);
        make.right.equalTo(self.lab_awayName.mas_left);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(20));
    }];
    [self.lab_awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(20));
    }];
    
    [self addSubview:self.view_displayContent];
    [self.view_displayContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_totleMatchDis.mas_bottom).offset(12);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(35));
    }];
    
    [self addSubview:self.lab_totleLoseWin];
    [self.lab_totleLoseWin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_displayContent.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
}

- (void)fullHeaderWithJFLSData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_lsjf  {
    if (arr_lsjf.count > 0) {
        self.hidden = NO;
        QukanMatchDetailHistoryModel *firstM = arr_lsjf.firstObject;
        if (firstM.selectTeamIsHomeTeam) {
            self.lab_homeName.text = firstM.homeName;
            self.lab_awayName.text = firstM.awayName;
        }else {
            self.lab_homeName.text = firstM.awayName;
            self.lab_awayName.text = firstM.homeName;
        }
        
        self.lab_totleMatchDis.text = [NSString stringWithFormat:@"最近%zd场交锋",arr_lsjf.count];
        
        CGFloat totleWin = 0;
        CGFloat totleLose = 0;
        CGFloat totlePlat = 0;
        
        for (QukanMatchDetailHistoryModel *m in arr_lsjf) {
            if (m.winState == 1) {
                totleWin ++;
            }
            if (m.winState == 2) {
                totleLose ++;
            }
            if (m.winState == 3) {
                totlePlat ++;
            }
        }
        
        CGFloat zeroCount = 0;
        
        if (totlePlat == 0) {
            zeroCount ++;
        }
        if (totleLose == 0) {
            zeroCount ++;
        }
        if (totleWin == 0) {
            zeroCount ++;
        }
        UIView *view_Win = [self.view_displayContent viewWithTag:10086];
        UIView *view_plat = [self.view_displayContent viewWithTag:10087];
        UIView *view_lose = [self.view_displayContent viewWithTag:10088];
        
        UILabel *lab_Win = [self.view_displayContent viewWithTag:100086];
        UILabel *lab_plat = [self.view_displayContent viewWithTag:100087];
        UILabel *lab_lose = [self.view_displayContent viewWithTag:100088];
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame_win = view_Win.frame;
            CGRect frame_plat = view_plat.frame;
            CGRect frame_lose = view_lose.frame;

            NSInteger allCount = totleWin + totlePlat + totleLose;
            allCount = allCount == 0 ? 1 : allCount;
            CGFloat allWidth = kScreenWidth - 30 - zeroCount * kWidthWhenIsZero;

            CGFloat width_win = (totleWin == 0 )? kWidthWhenIsZero : allWidth * (totleWin / allCount);
            CGFloat width_plat = (totlePlat == 0 )? kWidthWhenIsZero : allWidth * (totlePlat / allCount);
            CGFloat width_lose = (totleLose == 0 )? kWidthWhenIsZero : allWidth * (totleLose / allCount);

            frame_win.size.width = width_win;
            frame_lose.size.width = width_lose;
            frame_plat.size.width = width_plat;

            frame_plat.origin.x = width_win ;
            frame_lose.origin.x = width_win + width_plat;

            view_Win.frame = frame_win;
            view_lose.frame = frame_lose;
            view_plat.frame = frame_plat;

            [view_Win setNeedsDisplay];
            [view_Win layoutIfNeeded];
            [view_lose setNeedsDisplay];
            [view_lose layoutIfNeeded];
            [view_plat setNeedsDisplay];
            [view_plat layoutIfNeeded];
        }];
        
        lab_Win.text = [NSString stringWithFormat:@"%.0f胜",totleWin];
        lab_lose.text = [NSString stringWithFormat:@"%.0f负",totleLose];
        lab_plat.text = [NSString stringWithFormat:@"%.0f平",totlePlat];
        
        NSString *str_totle = [NSString stringWithFormat:@"%@%.0f胜%.0f平%.0f负",self.lab_homeName.text,totleWin,totlePlat,totleLose];
        NSMutableAttributedString *strM_totle = [[NSMutableAttributedString alloc] initWithString:str_totle];
        
        NSInteger homeNamelength = self.lab_homeName.text.length;
        NSInteger winlength = [NSString stringWithFormat:@"%.0f",totleWin].length;
        NSInteger platlength = [NSString stringWithFormat:@"%.0f",totlePlat].length;
        NSInteger loselength = [NSString stringWithFormat:@"%.0f",totleLose].length;
        
        [strM_totle addAttribute:NSForegroundColorAttributeName value:HEXColor(0xF12B2B) range:NSMakeRange(homeNamelength, winlength)];
        [strM_totle addAttribute:NSForegroundColorAttributeName value:HEXColor(0x18AB3A) range:NSMakeRange(homeNamelength + winlength + 1, platlength)];
        [strM_totle addAttribute:NSForegroundColorAttributeName value:HEXColor(0xF34A6F1) range:NSMakeRange(homeNamelength + winlength + platlength + 2, loselength)];
        
        
        self.lab_totleLoseWin.attributedText = strM_totle;
    }else {
        self.hidden = YES;
    }
}


#pragma mark ===================== lazy ==================================
- (UILabel *)lab_homeName {
    if (!_lab_homeName) {
        _lab_homeName = [UILabel new];
        _lab_homeName.textAlignment = NSTextAlignmentLeft;
        _lab_homeName.font = [UIFont boldSystemFontOfSize:14];
        
        [_lab_homeName setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lab_homeName;
}
- (UILabel *)lab_awayName {
    if (!_lab_awayName) {
        _lab_awayName = [UILabel new];
        _lab_awayName.textAlignment = NSTextAlignmentRight;
        _lab_awayName.font = [UIFont boldSystemFontOfSize:14];
        [_lab_awayName setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lab_awayName;
}
- (UILabel *)lab_totleMatchDis {
    if (!_lab_totleMatchDis) {
        _lab_totleMatchDis = [UILabel new];
        _lab_totleMatchDis.textAlignment = NSTextAlignmentCenter;
        _lab_totleMatchDis.font = [UIFont boldSystemFontOfSize:14];

    }
    return _lab_totleMatchDis;
}
- (UILabel *)lab_totleLoseWin {
    if (!_lab_totleLoseWin) {
        _lab_totleLoseWin = [UILabel new];
        _lab_totleLoseWin.textAlignment = NSTextAlignmentCenter;
        _lab_totleLoseWin.font = [UIFont boldSystemFontOfSize:12];
    }
    return _lab_totleLoseWin;
}

- (UIView *)view_displayContent {
    if (!_view_displayContent) {
        _view_displayContent = [UIView new];
        _view_displayContent.layer.masksToBounds = YES;
        _view_displayContent.layer.cornerRadius = 17.5;
        _view_displayContent.backgroundColor = kCommonWhiteColor;
        
        
        for (int i = 0; i < 3; i ++) {
            QukanSharpBgViewType sharpType = 0;
            UIColor *color = nil;
            if (i == 0) {
                sharpType = QukanSharpBgViewTypeRightTop;
                color = HEXColor(0xF12B2B);
            }
            if (i == 1) {
                sharpType = QukanSharpBgViewTypeLeftBottomAndRightTop;
                color = HEXColor(0x18AB3A);
            }
            if (i == 2) {
                sharpType = QukanSharpBgViewTypeLeftBottom;
                color = HEXColor(0xF34A6F1);
            }
            UIView *view_sharp = [[QukanSharpBgView alloc] initWithFrame:CGRectMake(i * ((kScreenWidth - 30) / 3),0, (kScreenWidth - 30) / 3, 35) type:sharpType AndOffset:6 andFullColor:color];
            view_sharp.tag = 10086 + i;
            UILabel *lab= [UILabel new];
            lab.font = [UIFont systemFontOfSize:13];
            lab.tag = 100086 + i;
            lab.textColor = kCommonWhiteColor;
            lab.text = [NSString stringWithFormat:@"%d",i];
            [view_sharp addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view_sharp);
                make.left.top.equalTo(view_sharp).offset(10);
            }];
            [_view_displayContent addSubview:view_sharp];
        }
        
    }
    return _view_displayContent;
}


@end
