//
//  QukanLiveLineModel.m
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanLiveLineModel.h"

@implementation QukanLiveLineModel

- (QukanLiveType)topicNewsType {
    if (self.liveType == 1) {
        return QukanLiveType_PlayerHdLive;
    } else if (self.liveType == 2) {
        return QukanLiveType_ThirdHdLive;
    } else if (self.liveType == 3) {
        return QukanLiveType_AnimationLive;
    } else if (self.liveType == 7) {
        return QukanLiveType_Ad;
    } else {
        return QukanLiveType_Other;
    }
}

@end
