//
//  LBLelinkService+Extension.m
//  dxMovie-ios
//
//  Created by james on 2019/6/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "LBLelinkService+Extension.h"

@implementation LBLelinkService (Extension)

- (void)setStatus:(ConnectStatus)status{
    objc_setAssociatedObject(self, @selector(status), @(status), OBJC_ASSOCIATION_ASSIGN);
}

- (ConnectStatus)status{
    
  return [objc_getAssociatedObject(self, _cmd) integerValue];
}


@end
