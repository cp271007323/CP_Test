//
//  QukanTextLiveHeaderView.h
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QukanNodeDidClick <NSObject>

- (void)QukanNodeDidClick:(UIButton *)btn;

@end



@interface QukanTextLiveHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong) UIButton   * lab_content;

@property(nonatomic, weak) NSObject<QukanNodeDidClick> *delegate;


@end

NS_ASSUME_NONNULL_END
