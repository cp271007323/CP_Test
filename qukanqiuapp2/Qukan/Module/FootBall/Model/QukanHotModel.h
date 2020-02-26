
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanHotModel : NSObject

@property (nonatomic, copy) NSString *away_id;
@property (nonatomic, copy) NSString *away_name;
@property (nonatomic, copy) NSString *away_score;
@property (nonatomic, copy) NSString *bc1;
@property (nonatomic, copy) NSString *bc2;
@property (nonatomic, copy) NSString *corner1;
@property (nonatomic, copy) NSString *corner2;
@property (nonatomic, copy) NSString *home_id;
@property (nonatomic, copy) NSString *home_name;
@property (nonatomic, copy) NSString *home_score;
@property (nonatomic, copy) NSString *ishot;
@property (nonatomic, copy) NSString *league_id;
@property (nonatomic, copy) NSString *league_name;
@property (nonatomic, copy) NSString *match_id;
@property (nonatomic, copy) NSString *match_time;
@property (nonatomic, copy) NSString *flag1;
@property (nonatomic, copy) NSString *flag2;
@property (nonatomic, copy) NSString *isAttention;
@property (nonatomic, copy) NSString *gqLive;
@property (nonatomic, copy) NSString *dhLive;



@property (nonatomic, copy) NSString *order1;
@property (nonatomic, copy) NSString *order2;
@property (nonatomic, copy) NSString *pass_time;
@property (nonatomic, copy) NSString *red1;
@property (nonatomic, copy) NSString *red2;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *yellow1;
@property (nonatomic, copy) NSString *yellow2;


- (instancetype)initQukan_WithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
