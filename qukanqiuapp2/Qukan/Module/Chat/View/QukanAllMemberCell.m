//
//  QukanAllMemberCell.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanAllMemberCell.h"


@interface QukanAllMemberCell ()



@end

@implementation QukanAllMemberCell

#pragma mark - set
- (void)setMembers:(NSArray<NSString *> *)members
{
    _members = members;
    [self.allMemberView reAddMemberForFriendModel:members];
}


#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitLayoutForQukanAllMemberCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark - Private
- (void)setupInitLayoutForQukanAllMemberCell
{
    [self.contentView addSubview:self.allMemberView];
    self.allMemberView.sd_layout
    .topSpaceToView(self.contentView, CPAuto(10))
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    [self setupAutoHeightWithBottomView:self.allMemberView bottomMargin:CPAuto(5)];
}

- (void)setupInitBindingForQukanAllMemberCell
{
    
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (AllMembersView *)allMemberView
{
    if (_allMemberView == nil) {
        _allMemberView = [AllMembersView allMemberViewWithType:AllMembersViewType_Chat];
    }
    return _allMemberView;
}

@end
