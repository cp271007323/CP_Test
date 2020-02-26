//
//  QukanMessageBaseTableViewCell.m
//  Cell
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QukanMessageBaseTableViewCell.h"
#import <YYLabel.h>
#import "QukanUIImage+Crop.h"
#import "QukanNSDate+Time.h"

static const CGFloat headWidth = kHeadWidth; // 头像宽
static const CGFloat headHeight = kHeadWidth; // 头像高
//static const CGFloat headXGap = 15; //

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface QukanMessageBaseTableViewCell ()


@end

@implementation QukanMessageBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildView];
    }
    
    return self;
}

- (void)buildView {
//    _headImgView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_headImgView addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [_headImgView addTarget:self action:@selector(headlongClick) forControlEvents:UIControlEventTouchDown];
    _headImgView = [UIImageView new];
    _headImgView.layer.cornerRadius = kHeadWidth/2.0;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
    [self.headImgView addGestureRecognizer:tapHead];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headlongClick:)];
    longTap.minimumPressDuration = 0.6;
    [self.headImgView addGestureRecognizer:longTap];
    
    _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bubbleView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    [longPress setMinimumPressDuration:0.4f];
    [self.bubbleView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubbleAction)];
    tap.delegate = self;
    [self.bubbleView addGestureRecognizer:tap];
//
    UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellAction:)];
    tapCell.delegate = self;
    [self.contentView addGestureRecognizer:tapCell];
    
    _labSeparator = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_labSeparator];
    
    _timeView = [UIView new];
    _timeView.hidden = YES;
//    _timeView.backgroundColor = RGB(210, 210, 210);
    _timeView.backgroundColor = UIColor.clearColor;
//    _timeView.layer.cornerRadius = 10;
    _timeLab = [UILabel new];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font = [UIFont systemFontOfSize:11];
    _timeLab.textColor = kTextGrayColor;
    [self.contentView addSubview:_timeView];
    [_timeView addSubview:_timeLab];
    
    _nickLab = [UILabel new];
    _nickLab.font = [UIFont systemFontOfSize:13];
    _nickLab.textColor = [UIColor grayColor];
    _nickLab.text = @"高清";
    _nickLab.hidden = YES;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    _resendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _resendButton.layer.cornerRadius = 10;
    _resendButton.layer.masksToBounds = YES;
    _resendButton.opaque = NO;
    _resendButton.hidden = YES;
    [_resendButton setImage:[UIImage imageNamed:@"Qukan_sendLost"] forState:UIControlStateNormal];
    [_resendButton addTarget:self action:@selector(onResendButtonClick) forControlEvents:UIControlEventTouchUpInside];

    _headImgView.contentMode = UIViewContentModeScaleToFill;
    
    [self.contentView addSubview:_headImgView];
    [self.contentView addSubview:_bubbleView];
    [self.contentView addSubview:_nickLab];
    [self.contentView addSubview:_indicatorView];
    [self.contentView addSubview:_resendButton];
}

- (CGSize)contentViewSize {
    NSAssert(NO, @"must be override");
    return CGSizeZero;
}

- (BOOL)showBubbleImage {
    return YES;
}

- (void)adjustViewFrame {
//    BOOL showSep = [self.delegate shouldDisplayHistorySeparatorOnMessage:self.message];
//    if (showSep) {
//        _labSeparator.hidden = NO;
//        _labSeparator.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 28);
//        _labSeparator.textColor = [UIColor lightGrayColor];
//        _labSeparator.textAlignment = NSTextAlignmentCenter;
//        _labSeparator.font = [UIFont systemFontOfSize:13];
//        _labSeparator.text = @"———————以下是新消息———————";
//    }else {
//        _labSeparator.hidden = YES;
//    }
    
    BOOL showTime = [self.delegate shouldDisplayTimestampOnMessage:self.message];
    if (showTime) {
        _timeView.hidden = NO;
        //TODO: 此处可以优化，增加滑动流畅性
        CGSize s = [QukanMessageBaseTableViewCell contentHeigthForText:_timeLab.text fixedWidth:200 font:_timeLab.font];
        _timeView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds)/2-s.width/2.0-10, 15, s.width+20, 20);
        _timeLab.frame = _timeView.bounds;
    }else {
        _timeView.hidden = YES;
    }
    
    
    CGFloat xGap = !self.message.isReceivedMsg ? screenWidth - headWidth - 10 : 10;
//    CGFloat yGap = showSep ? CGRectGetMaxY(_labSeparator.frame) + 8 : 0;
    CGFloat yGap = (showTime ? CGRectGetMaxY(_timeView.frame) + 8 : 8);
    _headImgView.frame = CGRectMake(xGap, yGap, headWidth, headHeight);
    CGSize contentSize = [self contentViewSize];
    CGFloat h;
    if (self.message.messageType == NIMMessageTypeText) {
        h = contentSize.height+2*leftContentInsets.top > bubbleMinHeight ? contentSize.height+2*leftContentInsets.top : bubbleMinHeight;
    }else {
        h = contentSize.height;
    }
    
   
//    if (self.message.isGroupChat) {
//        _nickLab.hidden = NO;
//
//        if (self.message.sender == MessageSenderSelf) {
//            _nickLab.textAlignment = NSTextAlignmentRight;
//            xGap = screenWidth - 240 - headXGap - headWidth - 8;
//        }else {
//            _nickLab.textAlignment = NSTextAlignmentLeft;
//            xGap = CGRectGetMaxX(_headImgView.frame)+8;
//        }
//
//        _nickLab.frame = CGRectMake(xGap, CGRectGetMinY(_headImgView.frame)-5, 240, 24);
//    }
    
    CGFloat bubbleY = CGRectGetMinY(_headImgView.frame);
    
    CGFloat bubbleXGap = !self.message.isReceivedMsg ? screenWidth - contentSize.width - kLeftContentGap - kRightContentGap -  CGRectGetWidth(_headImgView.frame)-18 : CGRectGetMaxX(_headImgView.frame)+4;
    _bubbleView.frame = CGRectMake(bubbleXGap,
                                   bubbleY,
                                   contentSize.width+kLeftContentGap+kRightContentGap,
                                   h);
    
    CGFloat indicatX = !self.message.isReceivedMsg ? CGRectGetMinX(_bubbleView.frame) - 25 : CGRectGetMaxX(_bubbleView.frame)+5;
    _indicatorView.frame = CGRectMake(indicatX,
                                      CGRectGetMidY(_bubbleView.frame)-10, 20, 20);
    _resendButton.frame = CGRectMake(indicatX-5, CGRectGetMidY(_bubbleView.frame)-25/2.0, 25, 25);
    
    BOOL showSep = [self.delegate shouldDisplayHistorySeparatorOnMessage:self.message];
    if (showSep) {
        _labSeparator.hidden = NO;
        _labSeparator.frame = CGRectMake(0, CGRectGetMaxY(_bubbleView.frame)+3, CGRectGetWidth(self.contentView.bounds), 28);
        _labSeparator.textColor = [UIColor lightGrayColor];
        _labSeparator.textAlignment = NSTextAlignmentCenter;
        _labSeparator.font = [UIFont systemFontOfSize:13];
        _labSeparator.text = @"———————以下是新消息———————";
    }else {
        _labSeparator.hidden = YES;
    }
}

- (CGFloat)getTimeViewWidthForTimeString:(NSString *)timeString {
    
    return 100;
}

- (void)configWithMessage:(NIMMessage *)message {
    self.message = message;

    int status = message.deliveryState;
    if (status == NIMMessageDeliveryStateDelivering) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        self.resendButton.hidden = YES;
    }else if (status == NIMMessageDeliveryStateFailed) {
        self.resendButton.hidden = NO;
        self.indicatorView.hidden = YES;
    }else if (status == NIMMessageDeliveryStateDeliveried) {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        self.resendButton.hidden = YES;
    }
    
    BOOL showTime = [self.delegate shouldDisplayTimestampOnMessage:self.message];
    if (showTime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
        _timeLab.text = [date chatTimeInfo];
    }

    NSString *url = message.isReceivedMsg ? @"" : kUserManager.user.avatorId;
    if (message.isReceivedMsg) {
        _headImgView.image = [UIImage imageNamed:@"Qukan_serviceMessage"];
    }else {
        if([url containsString:@"null"]){
            _headImgView.image = kImageNamed(@"Qukan_user_DefaultAvatar");
        }else{
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
        }
    }
    
//    [Util imageView:_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kUserDefaultImage];
    
    NSString *name = !message.isReceivedMsg ? kUserManager.user.nickname : message.from;
//    int uid = !message.isReceivedMsg ? user.userId.integerValue : message.fromId;
//    NSDictionary *att = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [Util imageView:_headImgView size:CGSizeMake(40, 40) sd_setImageWithURL:[NSURL URLWithString:url] name:name userId:uid textAttribute:att];
    
    _nickLab.text = name;
    
    [self adjustViewFrame];
    
    if (![self showBubbleImage]) {
        return;
    }
    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
    UIEdgeInsets edgeInsets = !self.message.isReceivedMsg ?  UIEdgeInsetsMake(8, 8, 8, 15) : UIEdgeInsetsMake(8, 15, 8, 8);
    if (!self.message.isReceivedMsg) {
        UIImage * image = [UIImage imageNamed:@"Qukan_chatRightOrige"];
        _bubbleView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }else {
        UIImage * image = [UIImage imageNamed:@"Qukan_chatLeftWhite"];
        _bubbleView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
};

//#pragma mark - UIGestureRecognizerDelegate
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//
//}

#pragma mark - Action

- (void)headClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAvatarOnMessage:atCell:)]) {
        [self.delegate didTapAvatarOnMessage:self.message atCell:self];
    }
}

- (void)headlongClick:(UILongPressGestureRecognizer *)longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [longPressGes locationInView:self.contentView];
        if (!CGRectContainsPoint(self.bubbleView.frame, longPressPoint)) {
            if (CGRectContainsPoint(self.headImgView.frame, longPressPoint)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didLongTapAvatarOnMessage:atCell:)]) {
                    [self.delegate didLongTapAvatarOnMessage:self.message atCell:self];
                }
            }
            return;
        }
    }
}

- (void)onResendButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重发消息?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTapResendOnMessage:atCell:)]) {
            [self.delegate didTapResendOnMessage:self.message atCell:self];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    [self.firstViewController presentViewController:alert animated:YES completion:nil];
    
}

- (UIViewController *)firstViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)tapCellAction:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(didTapBlankOnMessage:atCell:)]) {
        [self.delegate didTapBlankOnMessage:self.message atCell:self];
    }
}

- (void)tapBubbleAction {}

- (void)longTapAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;

    NSArray *popMenuTitles = @[@"复制",/*@"转发",@"收藏",@"撤回",*/ @"删除",];
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < popMenuTitles.count; i ++) {
        NSString *title = popMenuTitles[i];
        SEL action = nil;
        switch (i) {
            case 0: {
                if (self.message.messageType == NIMMessageTypeText) {
                    action = @selector(copyed:);
                }
                break;
            }

            case 1: {
                action = @selector(deleteAction:);
                break;
            }
            default:
                break;
        }
        if (action) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:title action:action];
            if (item) {
                [menuItems addObject:item];
            }
        }
    }

    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];

    CGRect targetRect = self.bubbleView.frame;

    [menu setTargetRect:targetRect inView:self];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Menu Actions

- (void)copyed:(id)sender {
    //    NSMutableAttributedString
    NSString *str = self.message.text;
    [[UIPasteboard generalPasteboard] setString: str];
    [self resignFirstResponder];
}

- (void)transpond:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didForwardOnMessage:atCell:)]) {
        [_delegate didForwardOnMessage:self.message atCell:self];
    }
}

- (void)whDrawAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didWhdrawOnMessage:atCell:)]) {
        [_delegate didWhdrawOnMessage:self.message atCell:self];
    }
}

- (void)favorites:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didForwardOnMessage:atCell:)]) {
        [_delegate didCollectOnMessage:self.message atCell:self];
    }
}

- (void)deleteAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didDeleteOnMessage:atCell:)]) {
        [_delegate didDeleteOnMessage:self.message atCell:self];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(deleteAction:) || action == @selector(whDrawAction:) );
}

#pragma mark -
- (void)updateSendStatus:(NIMMessageDeliveryState)status {
//    self.message.deliveryState = status;
    
    if (status == NIMMessageDeliveryStateDelivering) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        self.resendButton.hidden = YES;
    }else if (status == NIMMessageDeliveryStateFailed) {
        self.indicatorView.hidden = YES;
        self.resendButton.hidden = NO;
    }else if (status == NIMMessageDeliveryStateDeliveried) {
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
        self.resendButton.hidden = YES;
    }
}

#pragma mark - Caclute height
+ (CGFloat)cacluteHeightForMessage:(NIMMessage *)message {
    CGFloat h = 0;
    
    h = 8;
    
//    h += message.isGroupChat ? 24 : 0;
    
    CGSize size;
    
    switch (message.messageType) {
        case NIMMessageTypeText:
        {
            size = [QukanMessageBaseTableViewCell contentHeigthForText:message.text fixedWidth:contentMaxWidth font:kFont16];
            CGFloat c = size.height + 2*8 > 55 ? size.height+16 : 55;
            h += c;
        }
            break;
        case NIMMessageTypeCustom:
        {
            CGFloat width = screenWidth - 30;
            size = [QukanMessageBaseTableViewCell contentHeigthForText:message.text fixedWidth:width font:[UIFont systemFontOfSize:12]];
            h = size.height+10;
        }
            break;
//        case kMessageTypeVideo:
        case NIMMessageTypeImage:
        {
            NIMImageObject *imgObj = (NIMImageObject *)message.messageObject;            
            size = [UIImage getAspectImageSizeForImageSize:imgObj.size];
            h += size.height+12;
        }
            break;
        default:
            size = CGSizeZero;
            break;
    }
    
//    h += 8;
    
    message.messageContentSize = size;
    
    return h;
}

+ (CGSize)contentHeigthForText:(NSString*)content fixedWidth:(CGFloat)width font:(UIFont *)font {
//    NSAttributedString *text = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: font}];
//    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
//    CGSize csize = layout.textBoundingSize;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr setAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attrStr.length)];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attrStr];
    return layout.textBoundingSize;
    
//    return csize;
    
}

- (void)dealloc
{
    DEBUGLog(@"%@ dealloced", NSStringFromClass([self class]));
}

@end
