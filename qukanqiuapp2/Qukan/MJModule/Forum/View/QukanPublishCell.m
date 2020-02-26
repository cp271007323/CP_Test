//
//  QukanPublishCell.m
//  Qukan
//
//  Created by mac on 2018/10/10.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanPublishCell.h"

@implementation QukanPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteDidClick:(id)sender {
    if (self.deleteDidBlock) {
        self.deleteDidBlock();
    }
}

@end
