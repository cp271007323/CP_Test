//
//  QukanJHGridCell.m
//  Qukan
//
//  Created by blank on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanJHGridCell.h"

@implementation QukanJHGridCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLab = [UILabel new];
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        self.contentLab.textAlignment = NSTextAlignmentCenter;
        
        self.botLine = [UIView new];
        [self.contentView addSubview:self.botLine];
        [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(0.5);
        }];
        
    }
    return self;
}

@end
