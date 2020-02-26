//
//  QukanMessageDetailCell.m
//  Qukan
//
//  Created by leo on 2019/11/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMessageDetailCell.h"
#import "QukanMessageModel.h"

@interface QukanMessageDetailCell ()

@end

@implementation QukanMessageDetailCell

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
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerImageView.image = [UIImage imageNamed:@"Qukan_systemMessage"];
    
    headerImageView.layer.cornerRadius = headerImageView.width / 2;
    headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@(50));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.text = @"今天";
    timeLabel.textColor = kTextGrayColor;
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@(50));
    }];
    
    
    [self.contentView addSubview:self.view_line];
    [self.view_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@(1));
    }];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.text = @"你好，在吗";
    contentLabel.textColor = kTextGrayColor;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
//        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
    }];
    
}
- (void)fullcellWithModel:(QukanMessageModel *__nullable)model {

    NSString *htmlString = model.content;
    NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];
    self.contentLabel.attributedText = nameText;
    
    self.timeLabel.text = [self compareCurrentTime:model.createTime];
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

- (UIView *)view_line {
    if (!_view_line) {
        _view_line = [UIView new];
        _view_line.backgroundColor = HEXColor(0xeeeeee);
    }
    return _view_line;
}

@end
