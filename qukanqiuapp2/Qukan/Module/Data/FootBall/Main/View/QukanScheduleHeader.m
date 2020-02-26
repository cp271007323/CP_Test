//
//  QukanScheduleHeader.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanScheduleHeader.h"

@interface QukanScheduleHeader()

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation QukanScheduleHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    _leftButton = [self buttonWithTitle:@"上一轮" andImageName:@"triangle_left" titleAtLeft:NO];
    _curRoundBtn = [self buttonWithTitle:@"第1轮" andImageName:@"triangle_down" titleAtLeft:YES];
    _rightButton = [self buttonWithTitle:@"下一轮" andImageName:@"triangle_right" titleAtLeft:YES];
//    [self addSubview:_leftButton];
//    [self addSubview:_curRoundBtn];
//    [self addSubview:_rightButton];
    _leftButton.tag = 100;
    _curRoundBtn.tag = 101;
    _rightButton.tag = 102;
    
    _titleLabel = [_curRoundBtn viewWithTag:102];

    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(45);
    }];
//    [_leftButton setTitle:@"上一轮" forState:UIControlStateNormal];
//    _leftButton.titleLabel.font = kFont12;
//    [_leftButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
//    [_leftButton setImage:kImageNamed(@"triangle_left") forState:UIControlStateNormal];
    
    [_curRoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(55);
    }];
//    [_curRoundBtn setTitle:@"第一轮" forState:UIControlStateNormal];
//    _curRoundBtn.titleLabel.font = kFont12;
//    [_curRoundBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
//    [_curRoundBtn setImage:kImageNamed(@"triangle_down") forState:UIControlStateNormal];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(45);
    }];
//    [_rightButton setTitle:@"下一轮" forState:UIControlStateNormal];
//    _rightButton.titleLabel.font = kFont12;
//    [_rightButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    
//    [_rightButton setImage:kImageNamed(@"triangle_right") forState:UIControlStateNormal];
    
//    _leftButton.backgroundColor = _curRoundBtn.backgroundColor = _rightButton.backgroundColor = UIColor.redColor;

}

- (void)setRoundName:(NSString*)name{
    _titleLabel.text = name;
}

- (NSString*)curRoundName{
    return _titleLabel.text;
}

- (UIButton *) buttonWithTitle:(NSString *)title andImageName:(NSString*)imgName titleAtLeft:(BOOL)titleAtLeft{
    // 创建标题按钮
    UILabel* label = [UILabel new];
    label.text = title;
    label.font = kFont12;
    label.textColor = kCommonWhiteColor;
    label.tag = 102;
    
    UIImageView* imgV = [UIImageView new] ;
    imgV.image = kImageNamed(imgName);

    UIButton*button = [[UIButton alloc]init];
    [button addSubview:label];
    [button addSubview:imgV];
    
    [self addSubview:button];
    
  
    if(titleAtLeft){
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(3);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(8);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-4);
            make.centerY.mas_equalTo(0);
        }];
    }else{
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label.mas_left).offset(-3);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(8);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    
    
//
//    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 30)];
//
//    button.titleLabel.font = kFont12;
//    [button setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
//    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [button setImage:kImageNamed(imgName) forState:UIControlStateNormal];
//
//    [button setTitle:title forState:UIControlStateNormal];
//
//    [button sizeToFit];
//    if(titleAtLeft){
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width - button.frame.size.width + button.titleLabel.frame.size.width, 0, 0);
//
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.titleLabel.frame.size.width - button.frame.size.width + button.imageView.frame.size.width);
//    }
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)clickAction:(UIButton *)sender {
    if(!self.scheduleHeaderClickAtButton)
        return ;
    self.scheduleHeaderClickAtButton(sender);

}



@end
