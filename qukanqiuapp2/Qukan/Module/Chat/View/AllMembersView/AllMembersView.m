//
//  AllMembersView.m
//  ixcode
//
//  Created by Mac on 2019/11/9.
//  Copyright © 2019 macmac. All rights reserved.
//

#import "AllMembersView.h"

@interface AllMembersView ()

@property (nonatomic , strong) NSMutableArray<NSString *> *dataSource;

@end

@implementation AllMembersView


#pragma mark - set



#pragma mark - Life
+ (instancetype)allMemberViewWithType:(AllMembersViewType)type
{
    AllMembersView *view = [[AllMembersView alloc] initWithFrame:CGRectMake(0, 0, CPScreenWidth(), 100) type:type];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame type:(AllMembersViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}

#pragma mark - Private
- (void)setupInitLayoutForAllMembersView
{
    //加好按钮
    BOOL isAddInvite = NO;
    //超过多少人显示更多状态
    BOOL isOverMembers = NO;
    
    //判断是否群主。添加几个按钮、另外要考虑可能存在 非好友情况的可能性，点击进来是不显示 加号 减号
    //单聊
    if(self.type == AllMembersViewType_Chat)
    {
        isAddInvite = YES;
    }
    //群聊
    else
    {
        //判断是否为群主的地方
    }
    
    NSInteger count = 5;    //每行的个数
    CGFloat magine = CPAuto(20);    //每个头像的间距和左右两边的间距
    CGFloat width = (CPScreenWidth() - magine * (count + 1)) / count;   //宽
    CGFloat height = width + CPAuto(20);        //高
    
    __block UIView *preView = self; //上方个视图
    
    NSMutableArray*arr = [NSMutableArray array];
    
    //群主
    if (self.isGroup)
    {
        //人数超过18个
        if (self.dataSource.count >= 17)
        {
            [arr addObjectsFromArray:[self.dataSource subarrayWithRange:NSMakeRange(0, 18)]];
            isOverMembers = YES;
        }
        //未超过18个
        else
        {
            [arr addObjectsFromArray:self.dataSource];
        }

        [arr addObject:@"+"];
        [arr addObject:@"-"];
    }
    
    //群成员
    else
    {
        
        //人数超过18个
        if (self.dataSource.count >= 18)
        {
            [arr addObjectsFromArray:[self.dataSource subarrayWithRange:NSMakeRange(0, 19)]];
            isOverMembers = YES;
        }
        //未超过18个
        else
        {
            [arr addObjectsFromArray:self.dataSource];
        }
        
        if (isAddInvite)
        {
            [arr addObject:@"+"];
        }
    }
    
    
    __block CGFloat topSpace = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [arr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        //这是个按钮通过继承的方式重新布局
        MembersView *view = [MembersView membersView];
        [self addSubview:view];
        view.sd_layout
        .topSpaceToView(preView, topSpace)
        .widthIs(width)
        .heightIs(height)
        .leftSpaceToView(self, magine + (width + magine) * (idx % 5));
        
        //点击事件
        [[view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            if (![obj isEqual:@"+"] && ![obj isEqual:@"-"])
            {
                if (self.cpDelegate && [self.cpDelegate respondsToSelector:@selector(allMembersView:didSelector:)])
                {
                    [self.cpDelegate allMembersView:self didSelector:obj];
                }
            }
            else
            {
                if (self.cpDelegate &&
                    [self.cpDelegate respondsToSelector:@selector(allMembersViewWithAdd:)] &&
                    [obj isEqual:@"+"])
                {
                    [self.cpDelegate allMembersViewWithAdd:self];
                }
                
                if (self.cpDelegate && [self.cpDelegate respondsToSelector:@selector(allMembersViewWithRemove:)] && [obj isEqual:@"-"])
                {
                    [self.cpDelegate allMembersViewWithRemove:self];
                }
            }
        }];
        
        //判断类型  判断是否为加号，减号
        if ([obj isEqual:@"+"] || [obj isEqual:@"-"])
        {
            if ([obj isEqual:@"+"]) {
                [view setImage:CPImageName(@"Qukan_blackAdd") forState:UIControlStateNormal];
            }
            else
            {
                [view setImage:CPImageName(@"Qukan_delete_icon") forState:UIControlStateNormal];
            }
        }
        //头像、昵称 写入位置
        else
        {
            [view sd_setImageWithURL:[NSURL URLWithString:@" "] forState:UIControlStateNormal placeholderImage:CPImageName(@"Qukan_headIcon")];
            [view setTitle:obj forState:UIControlStateNormal];
        }
        
        
        if ((idx + 1) % 5 == 0)
        {
            preView = view;
            topSpace = CPAuto(10);
        }
        
        //是否显示群主
        view.isGroup = self.isGroup;
        
    }];
    
    //判断是否需要显示查看更多群成员
    //查看
    if (isOverMembers)
    {
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookBtn setTitle:@"查看更多群成员 >" forState:UIControlStateNormal];
        lookBtn.titleLabel.font = CPFont_Regular(14);
        [lookBtn setTitleColor:CPColor(@"666666") forState:UIControlStateNormal];
        [self addSubview:lookBtn];
        
        [[lookBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.cpDelegate && [self.cpDelegate respondsToSelector:@selector(allMembersViewForLookAllMembers:)])
            {
                [self.cpDelegate allMembersViewForLookAllMembers:self];
            }
        }];
        
        lookBtn.sd_layout
        .topSpaceToView(preView, CPAuto(10))
        .centerXEqualToView(self);
        [lookBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:CPAuto(40)];
        [self setupAutoHeightWithBottomViewsArray:self.subviews bottomMargin:CPAuto(0)];
    }
    //不显示查看
    else
    {
        [self setupAutoHeightWithBottomViewsArray:self.subviews bottomMargin:CPAuto(10)];
    }
    
    
}

- (void)setupInitBindingForAllMembersView
{

}


#pragma mark - Public
//- (void)addMemberForFriendModel:(NSMutableArray<NSString *> *)dataSource
//{
//    [self reAddMemberForFriendModel:dataSource];
//}
//
- (void)reAddMemberForFriendModel:(NSMutableArray<NSString *> *)dataSource
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    [self setupInitLayoutForAllMembersView];
}

- (void)addMemberForDictionary:(NSMutableArray<NSString *> *)dataSource;
{
    [self reAddMemberForDictionary:dataSource];
}

- (void)reAddMemberForDictionary:(NSMutableArray<NSString *> *)dataSource
{
    [self.dataSource removeAllObjects];
    [dataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSource addObject:obj];
    }];
    [self setupInitLayoutForAllMembersView];
}

#pragma mark - get
- (NSMutableArray<NSString *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
