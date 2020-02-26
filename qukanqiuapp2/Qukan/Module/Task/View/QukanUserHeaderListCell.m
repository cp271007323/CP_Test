//
//  TopicUserHeaderListCell.m
//  Topic
//
//  Created by leo on 2019/9/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanUserHeaderListCell.h"

@implementation QukanUserHeaderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)fullCellWithIndex:(NSInteger)index andDatas:(NSArray *)arr {
    NSArray *QukanIcon_arr = @[@"user_center_redPoint",@"user_center_jf",@"touPing"];
    NSArray *QukanTitle_arr = @[kStStatus.pageSize,kStStatus.duration,@"投屏"];
    
    if ([QukanIcon_arr[index] isEqualToString:@"user_center_redPoint"]) {
        [self.img_item sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"user_center_redPoint"]];
    }else if ([QukanIcon_arr[index] isEqualToString:@"user_center_jf"]) {
        [self.img_item sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"user_center_jf"]];
    }else {
        self.img_item.image = kImageNamed(QukanIcon_arr[index]);
    }
    self.lab_itemContent.text = QukanTitle_arr[index];
    NSString *str = FormatString(@"首次%@%@", kGetImageType(15),kGetImageType(16));
    if (arr.count >= 3) {
        self.lab_item.text = arr[index];
        if (index == 2 && [arr[index] isEqualToString:str]) {
            self.lab_item.font = kFont12;
        }else {
            self.lab_item.font = [UIFont fontWithName:@"DINCondensed-Bold" size:24];
        }
    }else {
        self.lab_item.font = [UIFont fontWithName:@"DINCondensed-Bold" size:24];
        self.lab_item.text = @"0";
    }
}

@end
