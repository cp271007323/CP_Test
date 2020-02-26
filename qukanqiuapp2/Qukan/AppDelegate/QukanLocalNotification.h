#define MatchTypeFootball       @"football"
#define MatchTypeBasketball     @"basketball"
#define BasketballTeam          @"BasketballTeam"
#define FootballTeam            @"FootballTeam"
#define MatchBody               @"比赛就要开始啦,快来看吧"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QukanLocalNotification : NSObject

/**
 notice

 @param matchType 篮球/足球
 @param model 比赛模型
 */
+(void)noticeWithType:(NSString *)matchType model:(id)model;

/**
 取消notice

 @param identifier identifier
 */
+(void)cancleLocationIdentifier:(NSString *)identifier;
@end
