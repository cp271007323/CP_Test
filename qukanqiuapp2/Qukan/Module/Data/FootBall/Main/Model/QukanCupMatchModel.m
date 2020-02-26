//
//  QukanCupMatchModel.m
//  Qukan
//
//  Created by Charlie on 2020/1/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanCupMatchModel.h"

@implementation QukanCupMatchModel

-(NSString *)corner1{
    if(!_corner1){
        return @"0";
    }
    return _corner1;
}

-(NSString *)corner2{
    if(!_corner2){
        return @"0";
    }
    return _corner2;
}


@end
