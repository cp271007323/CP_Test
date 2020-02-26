//
//  QukanBSKDataTeamDetailModel.m
//  Qukan
//
//  Created by blank on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKDataTeamDetailModel.h"

@implementation QukanBSKDataTeamDetailModel
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"playerList":[QukanPlayerList class]};
}
- (CGFloat)caculateHeight {
    self.introduce = [self.introduce stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName:kFont12,
                                  NSParagraphStyleAttributeName: paragraphStyle
                                  };
    CGSize textRect = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT);
    CGFloat textHeight = [self.introduce boundingRectWithSize:textRect
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     attributes:attributes
                                                        context:nil].size.height;
    return textHeight + 10 + 35 +10;
}
@end
@implementation QukanPlayerList

@end
@implementation QukanSelectScheduleTeamModel

@end
