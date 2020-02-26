//
//  QukanMessageTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanMessageTableViewCell.h"
#import "QukanMessageModel.h"

@interface QukanMessageTableViewCell ()

@end

@implementation QukanMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    headerImageView.image = [UIImage imageNamed:@""];
    headerImageView.backgroundColor = [UIColor redColor];
    headerImageView.layer.cornerRadius = headerImageView.width / 2;
    headerImageView.layer.masksToBounds = YES;
    [self addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.right + 10, 10, 200, 20)];
    typeLabel.text = @"系统消息";
    typeLabel.textColor = kCommonDarkGrayColor;
    typeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:typeLabel];
    _typeLabel = typeLabel;
    
    UIView *view_redP = [[UIView alloc] initWithFrame:CGRectMake(headerImageView.right - 3, headerImageView.top - 3, 6, 6)];
    view_redP.backgroundColor = [UIColor redColor];
    view_redP.layer.cornerRadius = 3;
    view_redP.layer.masksToBounds = YES;
    [self addSubview:view_redP];
    _view_redPoint = view_redP;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.right + 10, typeLabel.bottom + 10, kScreenWidth - 130, 20)];
    contentLabel.text = @"你好，在吗";
    contentLabel.textColor = kTextGrayColor;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 25, 70, 20)];
    timeLabel.text = @"今天";
    timeLabel.textColor = kTextGrayColor;
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UILabel *unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.left - 50, 15, 50, 13)];
    unreadLabel.text = @"10条未读";
    unreadLabel.textColor = kThemeColor;
    unreadLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:unreadLabel];
    _unreadLabel = unreadLabel;
    
}
- (void)Qukan_SetMessageWith:(QukanMessageModel *__nullable)model WithType:(NSInteger)type {
    if (type == 1) {
        _typeLabel.numberOfLines = 1;
    } else {
        _headerImageView.image = kImageNamed(@"Qukan_systemMessage");
        _view_redPoint.hidden = YES;
        

        NSString *htmlString = model.content;
        NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];
        _typeLabel.attributedText = nameText;
        _typeLabel.numberOfLines = 3;
        
        CGSize attSize = [nameText boundingRectWithSize:CGSizeMake(kScreenWidth - 134, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        
        _typeLabel.frame = CGRectMake(_headerImageView.right + 10, 10, kScreenWidth - 134 , attSize.height);
        
        _timeLabel.text = [self compareCurrentTime:model.createTime];
        _contentLabel.text = @"";
        _unreadLabel.hidden = YES;
    }
}



-(NSString *)compareCurrentTime:(NSString *)str {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM-dd"];
    
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    // timeInterval = timeInterval - 86060;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else{
        result = [dateFormatter1 stringFromDate:timeDate];
    }
    
    return  result;
    
}

- (NSMutableAttributedString *)modifyDigitalColor:(UIColor *)color normalColor:(UIColor *)normalColor beginStr:(NSString *)str
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : normalColor}];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName : color} range:ranges[i].range];
    }
    return attStr;
}

@end
