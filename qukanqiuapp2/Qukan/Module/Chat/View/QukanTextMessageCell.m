//
//  QukanTextMessageCell.m
//  Cell
//
//  Created by park on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QukanTextMessageCell.h"

static NSString *const kphone = @"((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8}";
static NSString * const kgphone = @"0(10|2[0-5789]|\\d{3})\\d{7,8}";

static NSString *const kUrlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

@interface QukanTextMessageCell ()


@end

@implementation QukanTextMessageCell

- (void)buildView {
    [super buildView];
    
    _contentLab = [YYLabel new];
    _contentLab.userInteractionEnabled = YES;
    _contentLab.numberOfLines = 0;
    [self.bubbleView addSubview:_contentLab];
    
    UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellAction:)];
    tapCell.delegate = self;
    [self.contentLab addGestureRecognizer:tapCell];
}

- (void)configWithMessage:(NIMMessage *)message {
    [super configWithMessage:message];
    
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithData:[message.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    
    [attrs setAttributes:@{NSFontAttributeName: kFont16} range:NSMakeRange(0, attrs.length)];
    if (!self.message.isReceivedMsg) {
        [attrs addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrs.length)];
    }else {
        [attrs addAttribute:NSForegroundColorAttributeName value:kCommonBlackColor range:NSMakeRange(0, attrs.length)];
    }
    _contentLab.attributedText = attrs;
    
    [self adjustViewFrame];
}

- (void)adjustViewFrame {
    [super adjustViewFrame];
    
    UIEdgeInsets insets = self.message.isReceivedMsg ? leftContentInsets : rightContentInsets;
    CGFloat h = self.message.messageContentSize.height + 2*leftContentInsets.top > bubbleMinHeight ? self.message.messageContentSize.height : bubbleMinHeight-2*leftContentInsets.top;
    _contentLab.frame = CGRectMake(insets.left, insets.top,
                                   self.message.messageContentSize.width,
                                   h);
}


- (NSString *)removeSpaceAndNewline:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (CGSize)contentViewSize {
    return self.message.messageContentSize;
}

- (void)tapBubbleAction {
    
}

#pragma mark - UIGestureRecognizerDelegate

- (void)tapCellAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didTapBlankOnMessage:atCell:)]) {
        [self.delegate didTapBlankOnMessage:self.message atCell:self];
    }
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"YYLabel"]) {
//        return NO;
//    }
//
//    return YES;
//}

#pragma mark -
//// 将表情文本里的链接显示高亮、电话显示高亮
//- (NSAttributedString *)highlightLink:(NSAttributedString *)emjAtt {
//    NSString *text = emjAtt.string;
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:emjAtt];
//
//    NSArray *ranges = [[Rx rx:[NSString stringWithFormat:@"%@|%@", kphone, kUrlPattern]] matchesWithDetails:text];
//
//    UIColor *linkColor = ThemeBlueColor;
//    if (self.message.isMySend) {
//        linkColor = RGB(0, 252, 255);
//    }
//
//    for (RxMatch  *match in ranges) {
//        NSRange range = match.range;
//        NSString *subText = [text substringWithRange:range];
//
//        if ([RX(kphone) isMatch: subText]) {
//            __weak __typeof(self)weakSelf = self;
//            [attributedText yy_setTextHighlightRange:range color:linkColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                [weakSelf showAlert:subText];
//            }];
//        }
//        else if ([RX(kgphone) isMatch: subText]) {
//            __weak __typeof(self)weakSelf = self;
//            [attributedText yy_setTextHighlightRange:range color:linkColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                [weakSelf showAlert:subText];
//            }];
//        }
//        else if ([[NSRegularExpression rx:kUrlPattern ignoreCase:YES] isMatch:subText]) {
//            //        [attributedText appendAttributedString:subAttributedText];
//            [attributedText yy_setTextHighlightRange:range color:linkColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                __weak __typeof(self)weakSelf = self;
//                [weakSelf showWebView:subText];
//            }];
//        }
//
//    }
//
//    return attributedText;
//}

//- (void)showAlert:(NSString *)phone {
//    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//    alert.backgroundType = SCLAlertViewBackgroundBlur;
//    alert.circleIconHeight = 10;
//    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
//
//    SCLButton *button = [alert addButton:@"拨打电话" actionBlock:^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
//    }];
//
//    __weak __typeof(self)weakSelf = self;
//    SCLButton *button1 = [alert addButton:@"复制" actionBlock:^{
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        [pasteboard setString:phone];
//
//        [weakSelf.viewController.view showTip:@"复制成功"];
//    }];
//
//    button.buttonFormatBlock = ^NSDictionary* (void) {
//        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
//        buttonConfig[@"backgroundColor"] = ThemeBlueColor;
//        buttonConfig[@"textColor"] = [UIColor whiteColor];
//        return buttonConfig;
//    };
//
//    button1.buttonFormatBlock = ^NSDictionary* (void) {
//        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
//        buttonConfig[@"backgroundColor"] = ThemeBlueColor;
//        buttonConfig[@"textColor"] = [UIColor whiteColor];
//        return buttonConfig;
//    };
//
//    NSString *content = [NSString stringWithFormat:@"%@可能是一个电话号码", phone];
//
//    [alert showCustom:self.viewController image:[SCLAlertViewStyleKit imageOfInfo] color:ThemeBlueColor title:nil  subTitle:content closeButtonTitle:@"取消" duration:0.0f];
//}
//
//- (void)showWebView:(NSString *)urlString {
//    WebViewController *webVC = [WebViewController new];
//    webVC.url = urlString;
//    webVC.msg = self.message;
//    [self.viewController.navigationController pushViewController:webVC animated:YES];
//}

@end
