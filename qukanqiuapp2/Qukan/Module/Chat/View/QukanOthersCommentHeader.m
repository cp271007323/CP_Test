//
//  HaokanOthersCommentHeader.m
//  Haokan
//
//  Created by Charlie on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanOthersCommentHeader.h"
#import "QukanBolingPointListModel.h"

#define HeadViewH 80.0

@interface QukanOthersCommentHeader()

@property(nonatomic, strong)UIImageView* backImageView;
@property(nonatomic, strong)UIImageView* headeImageV;
@property(nonatomic, strong)UILabel* nameLabel;
@property(nonatomic, strong)UIButton* subscribeBtn;
@property(nonatomic, strong)UIButton* chatBtn;
@property(nonatomic, strong)UIButton* blockBtn;
@property(nonatomic, strong)QukanBolingPointListModel* model;

@end

@implementation QukanOthersCommentHeader

- (instancetype)initWithFrame:(CGRect)frame andModel:(QukanBolingPointListModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        [self creatSubView];
        [self layoutUI];
        [self updateUI];
    }
    return self;
}

- (void)creatSubView{
    [self addSubview: self.backImageView];
    [self addSubview: self.headeImageV];
    [self addSubview: self.nameLabel];
    [self addSubview: self.subscribeBtn];
    [self addSubview: self.chatBtn];
    [self addSubview: self.blockBtn];
}

-(void)layoutUI{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.backImageView.image = kImageNamed(@"Qukan_OtherInfo_backImg");
    
    [self.headeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(HeadViewH);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headeImageV.mas_right).offset(12);
        make.centerY.mas_equalTo(self.headeImageV);
        make.size.mas_equalTo(CGSizeMake(200,20));
    }];
    
    [self.subscribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headeImageV.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100,48));
    }];
    [self.subscribeBtn setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    self.subscribeBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.subscribeBtn.layer.cornerRadius = 15;
    self.subscribeBtn.layer.masksToBounds = YES;
    self.subscribeBtn.backgroundColor = kCommonWhiteColor;
    [self.subscribeBtn setImage:kImageNamed(@"Qukan_OtherInfo_subscribe") forState:UIControlStateNormal];
    self.subscribeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);

    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.subscribeBtn);
        make.size.mas_equalTo(self.subscribeBtn);
    }];

    [self.chatBtn setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    self.chatBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.chatBtn.layer.cornerRadius = 15;
    self.chatBtn.layer.masksToBounds = YES;
    self.chatBtn.backgroundColor = kCommonWhiteColor;
    [self.chatBtn setImage:kImageNamed(@"Qukan_OtherInfo_chat") forState:UIControlStateNormal];
    self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);

    [self.blockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subscribeBtn);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(self.subscribeBtn);
    }];

    [self.blockBtn setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    self.blockBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.blockBtn.layer.cornerRadius = 15;
    self.blockBtn.layer.masksToBounds = YES;
    self.blockBtn.backgroundColor = kCommonWhiteColor;
    [self.blockBtn setImage:kImageNamed(@"Qukan_OtherInfo_block") forState:UIControlStateNormal];
    self.blockBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);

}

- (BOOL)checkIfIsMyself{
    return kUserManager.user.userId == self.model.user_id;
}

- (void)buttonClicked:(UIButton*)sender{
    DEBUGLog(@"tag = %ld",(long)sender.tag);
    kGuardLogin
//    NSInteger myId = kUserManager.user.userId;
    if(kUserManager.user.userId == self.model.user_id){
        [self showTip:@"不能对自己做操作哦"];
        return;
    }
    
    if(sender.tag == 1001 && self.subscribeBtnClick){
        self.subscribeBtnClick(self.model);
    }else if(sender.tag == 1002 && self.chatBtnClick){
        self.chatBtnClick(self.model);
    }else if(sender.tag == 1003 && self.blockBtnClick){
        self.blockBtnClick(self.model);
    }
    [self updateUI];
}

- (void)updateUI{
    BOOL followed = kUserManager.isLogin && _model.user_follow;
    BOOL blocked = kUserManager.isLogin && [[QukanFilterManager sharedInstance] isBlockedUser:_model.user_id];
    
    if(self.model){
        NSString *headUrl = self.model.user_icon ? self.model.user_icon : @"";
        [self.headeImageV sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
        self.nameLabel.text = self.model.username;
        [self.subscribeBtn setTitle:followed? @"已关注":@"关注" forState:UIControlStateNormal];
        [self.blockBtn setTitle:blocked? @"已拉黑":@"拉黑" forState:UIControlStateNormal];
        [self.subscribeBtn setImage:kImageNamed(followed?@"Qukan_OtherInfo_subscribed":@"Qukan_OtherInfo_subscrib") forState:UIControlStateNormal];
        [self.blockBtn setImage:kImageNamed(blocked?@"Qukan_OtherInfo_blocked":@"Qukan_OtherInfo_block") forState:UIControlStateNormal];
    }
}

#pragma mark --------getter--------

- (UIImageView *)backImageView{
    if(!_backImageView){
        _backImageView = [[UIImageView alloc]init];
    }
    return _backImageView;
}

- (UIImageView *)headeImageV{
    if(!_headeImageV){
        _headeImageV = [[UIImageView alloc]init];
        _headeImageV.layer.cornerRadius = HeadViewH/2.0;
        _headeImageV.layer.masksToBounds = YES;
    }
    return _headeImageV;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = kCommonBlackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _nameLabel;
}

- (UIButton *)subscribeBtn{
    if(!_subscribeBtn){
        _subscribeBtn = [[UIButton alloc]init];
        [_subscribeBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_subscribeBtn setTag:1001];
        [_subscribeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _subscribeBtn;
}

- (UIButton *)chatBtn{
    if(!_chatBtn){
        _chatBtn = [[UIButton alloc]init];
        [_chatBtn setTitle:@"私信" forState:UIControlStateNormal];
        [_chatBtn setTag:1002];
        [_chatBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIButton *)blockBtn{
    if(!_blockBtn){
        _blockBtn = [[UIButton alloc]init];
        [_blockBtn setTitle:@"拉黑" forState:UIControlStateNormal];
        [_blockBtn setTag:1003];
        [_blockBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blockBtn;
}

@end
