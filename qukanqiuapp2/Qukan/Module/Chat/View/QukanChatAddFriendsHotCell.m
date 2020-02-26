//
//  QukanChatAddFriendsHotCell.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatAddFriendsHotCell.h"

#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanChatAddFriendsHotCell ()

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UIView *topView; //记录推荐师ID对应的lab 顶部布局的视图

@property (nonatomic , strong) NSMutableArray<UIView *> *labs;

@end

@implementation QukanChatAddFriendsHotCell

#pragma mark - set
- (void)setIds:(NSArray<NSString *> *)ids
{
    _ids = ids;
    
    [self.labs enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    self.topView = self.titleLab;
    
    [ids enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.topView = [self createLabWithContent:obj tag:idx + 1];
    }];
    [self setupAutoHeightWithBottomViewsArray:self.labs bottomMargin:15];
}


#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitLayoutForQukanChatAddFriendsHotCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark - Private
- (void)setupInitLayoutForQukanChatAddFriendsHotCell
{
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    [self.titleLab setSingleLineAutoResizeWithMaxWidth:200];
}

- (void)setupInitBindingForQukanChatAddFriendsHotCell
{
    
}

- (UILabel *)createLabWithContent:(NSString *)content tag:(NSInteger)tag
{
    UILabel *lab = [UILabel new];
    lab.textColor = HEXColor(0x111111);
    lab.font = kFont14;
    lab.text = [NSString stringWithFormat:@"高能推荐师ID:%@",content];
    lab.tag = tag;
    [self.contentView addSubview:lab];
    
    lab.sd_layout
    .topSpaceToView(self.topView, 15)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(20);
    [lab setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    [self.labs addObject:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:kImageNamed(@"Qukan_add") forState:UIControlStateNormal];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",content);
        UIPasteboard *pasterboard = [UIPasteboard generalPasteboard];
        pasterboard.string = content;
        //需要增加个提示框 提示复制成功
        
    }];
    [self.contentView addSubview:btn];
    
    btn.sd_layout
    .centerYEqualToView(lab)
    .leftSpaceToView(lab, 10)
    .widthIs(20)
    .heightEqualToWidth();
    
    return lab;
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.textColor = HEXColor(0x111111);
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.text = @"热门搜索";
    }
    return _titleLab;
}

- (NSMutableArray<UIView *> *)labs
{
    if (_labs == nil) {
        _labs = [NSMutableArray array];
    }
    return _labs;
}

@end
