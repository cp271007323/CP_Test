//
//  QukanXuanModel.m
//  Qukan
//
//  Created by Kody on 2019/9/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanXuanModel.h"

@implementation QukanXuanModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


@end
