//
//  QukanBasketLineImgView.h
//  Qukan
//
//  Created by leo on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketLineImgView : UIView

@property (nonatomic, copy) void (^didSelectPointBlock)(NSString *dateStr, NSString *moeStr);


@property (nonatomic, copy) NSString *checkInDateStr;

@property (nonatomic, copy) NSString *checkOutDateStr;



@property (nonatomic, strong) UIColor *gradientColor;


@property (nonatomic, strong) NSArray * yellowValueArr;
@property (nonatomic, strong) NSArray * redValueArr;

@property (nonatomic, assign) UIEdgeInsets contentInsets;


@property (assign, nonatomic)  CGPoint chartOrigin;


@property (nonatomic, strong) NSArray * xLineDataArr;
@property (nonatomic, strong) NSArray * yLineDataArr;

@property(nonatomic, copy) NSString   * str_redTeamName;
@property(nonatomic, copy) NSString   * str_yellowTeamName;


@property (nonatomic,assign) BOOL showYLine;
@property (nonatomic,assign) BOOL showYLevelLine;


@property (nonatomic, strong) NSArray * valueLineColorArr;

-(void)showAnimation;

@end

NS_ASSUME_NONNULL_END
