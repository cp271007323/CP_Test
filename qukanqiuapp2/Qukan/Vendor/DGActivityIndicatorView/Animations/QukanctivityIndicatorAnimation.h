//
//  QukanctivityIndicatorAnimation.h
//  DGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 8/10/16.
//  Copyright © 2016 Danil Gontovnik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QukanctivityIndicatorAnimationProtocol.h"

@interface QukanctivityIndicatorAnimation : NSObject <QukanctivityIndicatorAnimationProtocol>

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;

@end
