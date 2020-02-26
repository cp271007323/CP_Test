//
//  QukanBoilingPointTableView1Cell.m
//  Qukan
//
//  Created by mac on 2018/11/11.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanBoilingPointTableView1Cell.h"
#import "QukanBoilingPointTableViewModel_1.h"
#import "QukanApiManager+Boiling.h"

@interface QukanBoilingPointTableView1Cell()
@property (nonatomic, strong) QukanBoilingPointTableViewModel_1 *model;
@end

@implementation QukanBoilingPointTableView1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.cornerRadius = 14.0;
}

- (void)setData:(QukanBoilingPointTableViewModel_1 *)model {
    self.model = model;

    self.contentLabel.text = model.title;
    self.otherLabel.text = [NSString stringWithFormat:@"%ld个关注者 · %ld 沸点", model.fansCount, model.postCount];
    if (model.is_follow) {
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.followButton setTitle:@"+关注" forState:UIControlStateNormal];
    }
}



- (IBAction)follow:(id)sender {
    kGuardLogin
    if (self.followBlock) {
        
        NSString *typeStr = @"Y";
        if (self.model.is_follow) {
            typeStr = @"N";
        } else {
            typeStr = @"Y";
        }
        @weakify(self)
        [[[kApiManager QukanusersLikeWithModuleId:[NSNumber numberWithInteger:self.model.infoId] addOperation:typeStr] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.model.is_follow = !self.model.is_follow;
            NSDictionary *dict = @{@"InfoId":[NSNumber numberWithInteger:self.model.infoId],
                                   @"IsFollow":[NSNumber numberWithInteger:self.model.is_follow],
                                   @"Type":[NSNumber numberWithInteger:1]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QukanBoilingPointDetailFollowNotificationName" object:dict];
            NSString *title;
            int tag;
            title = [typeStr isEqualToString:@"Y"] ?  @"关注成功" : @"取消关注成功";
            tag =  [typeStr isEqualToString:@"Y"] ? 1 : 0;
            [SVProgressHUD showSuccessWithStatus:title];
            if (self.followBlock) {
                self.followBlock(tag);
            }
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
    }
}
@end
