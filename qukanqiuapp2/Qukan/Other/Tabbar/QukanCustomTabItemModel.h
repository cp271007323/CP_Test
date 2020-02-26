//
//  QukanCustomTabItem.h
//  Qukan
//
//  Created by leo on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanCustomTabItemModel : NSObject

/**标题*/
@property(nonatomic, copy) NSString   * itemTitle;
/**默认标题颜色*/
@property(nonatomic, strong) UIColor   * normalColor;
/**选中标题颜色*/
@property(nonatomic, strong) UIColor   * selectColor;
/**选中图片名称*/
@property(nonatomic, copy) NSString   * selectImgName;
/**默认图片名称*/
@property(nonatomic, copy) NSString   * mormalImgName;

@end

NS_ASSUME_NONNULL_END
