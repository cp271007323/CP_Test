//
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanWithRedDetailsCell.h"

@implementation QukanWithRedDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setlabTitle:(NSString *)labTitle labSubTitle:(NSString *)labSubTitle{
    self.labTitle.text = [NSString stringWithFormat:@"%@：",labTitle];
    
    if ([labTitle isEqualToString:FormatString(@"%@说明",[kCacheManager QukangetStStatus])]) {
        if (labSubTitle.length == 0) {
            labSubTitle = @"暂无说明";
        }
    }
    self.labSubTitle.text = labSubTitle;
}

@end
