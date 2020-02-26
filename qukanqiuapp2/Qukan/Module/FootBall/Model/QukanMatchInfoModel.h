#import <Foundation/Foundation.h>
@class QukanMatchInfoContentModel;
@interface QukanMatchInfoModel : NSObject
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray<QukanMatchInfoContentModel *> *dataArray;
@end
@interface QukanMatchInfoContentModel : NSObject<NSCopying>

@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic ,copy)   NSString *away_id;
@property (nonatomic ,copy)   NSString *home_id;
@property (nonatomic ,copy)   NSString *isAttention;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, assign) NSInteger redTips;
@property (nonatomic, assign) NSInteger goalTips;
@property (nonatomic, assign) NSInteger match_id;
@property (nonatomic, copy) NSString *league_name;
@property (nonatomic, copy) NSString *match_time;
@property (nonatomic, copy) NSString *pass_time;
@property (nonatomic, assign) NSInteger bc1;
@property (nonatomic, assign) NSInteger bc2;
@property (nonatomic, assign) NSInteger corner1;
@property (nonatomic, assign) NSInteger corner2;
@property (nonatomic, copy) NSString *home_name;
@property (nonatomic, copy) NSString *away_name;
@property (nonatomic, assign) NSInteger home_score;
@property (nonatomic, assign) NSInteger away_score;
@property (nonatomic, copy) NSString *order1;
@property (nonatomic, copy) NSString *order2;
@property (nonatomic, copy) NSString *ajilv;
@property (nonatomic, copy) NSString *dxjilv;
@property (nonatomic, assign) NSInteger red1;
@property (nonatomic, assign) NSInteger red2;
@property (nonatomic, assign) NSInteger yellow1;
@property (nonatomic, assign) NSInteger yellow2;
@property (nonatomic, copy) NSString *flag1;
@property (nonatomic, copy) NSString *flag2;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *gqLive;
@property (nonatomic, copy) NSString *dLive;
/**赛季*/
@property(nonatomic, copy) NSString   * season;
/**联赛id*/
@property(nonatomic, copy) NSString   * league_id;

@property (nonatomic, assign) NSInteger locationRowIndex;
@property (nonatomic, assign) NSInteger locationSectionIndex;


- (instancetype)initQukan_WithDict:(NSDictionary *)dict;
@end
