//
//  QukanPersonModel.m
//  Qukan
//
//  Created by Jeff on 2020/1/14.
//  Copyright © 2020 mac. All rights reserved.
//

@implementation QukanPersonModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


@end
