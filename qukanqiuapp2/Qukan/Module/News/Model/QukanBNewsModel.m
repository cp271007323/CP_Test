//
//  QukanBNewsModel.m
//  Qukan
//
//  Created by pfc on 2019/7/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanBNewsModel.h"

@implementation QukanBNewsModel

- (BOOL)isNews {
    return self.flag == 2;
}


- (NSArray *)validDatas {
    if (self.flag == 2) {
        return self.news;
    }
    
    return self.bas;
}
@end
