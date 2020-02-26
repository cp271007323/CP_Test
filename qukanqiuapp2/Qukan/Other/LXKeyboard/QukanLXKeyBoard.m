//
//  QukanLXKeyBoard.m
//  QukanLXKeyBoardTextView
//
//  Created by chenergou on 2017/12/21.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "QukanLXKeyBoard.h"
#import "QukanLXTextView.h"
#import "QukanLxButton.h"


#import "QukanSensitiveTextTool.h"

@interface QukanLXKeyBoard()<UITextViewDelegate>
@property(nonatomic,strong)QukanLXTextView *textView;
@property(nonatomic,strong)QukanLxButton *sendBtn;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign)CGFloat btnH;
@property(nonatomic,assign)CGFloat NavHeight;
@property(nonatomic,assign)BOOL isKeyBoard;
@end
@implementation QukanLXKeyBoard
{
    CGFloat keyboardY;
    
}

#define Device_Width  [[UIScreen mainScreen] bounds].size.width//获取屏幕宽高
#define Device_Height [[UIScreen mainScreen] bounds].size.height

#define NAVH (MAX(Device_Width, Device_Height)  == 812 ? 88 : 64)
#define TABBARH (MAX(Device_Width, Device_Height)  == 812 ? 83 : 49)

#define LXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LXRandomColor LXColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

-(void)awakeFromNib{
    [super awakeFromNib];
    
     [[NSNotificationCenter defaultCenter]removeObserver:self];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor =[UIColor hexStringToColor:@"A5A5A5"].CGColor;
//
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];;
    
    //设置默认属性
    self.topOrBottomEdge = 8;
    self.font = Font(18);
    self.maxLine = 3;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    
    
    if (self) {
//        self.layer.borderWidth = 1;
//        self.layer.borderColor =[UIColor hexStringToColor:@"A5A5A5"].CGColor;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardWillShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden) name:UIKeyboardWillHideNotification object:nil];

        //设置默认属性
        self.topOrBottomEdge = 8;
        self.font = Font(18);
        self.maxLine = 3;
        
//        self.NavHeight = isIPhoneXSeries()?88.0:64.0;
        self.NavHeight = 0;
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (void)keyboardWasShown {
//    self.isKeyBoard = YES;
//}
- (void)keyboardWillBeHiden {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isKeyBoard = NO;
    });
}

-(void)beginUpdateUI{
    //初始化高度 textView的lineHeight + 2 * 上下间距
    CGFloat orignTextH  = ceil (self.font.lineHeight) + 2 * self.topOrBottomEdge;
    
    self.frame =  CGRectMake(0, Device_Height, Device_Width, orignTextH);
    
    
    self.btnH = self.height;
    
    
    [self setup];
    
  
}
-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    UIView *bottomLine = [[UIView alloc] init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.2);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    [self addSubview:self.textView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView).mas_offset(-7.0);
        make.right.mas_equalTo(self.textView).mas_offset(7.0);
        make.top.mas_equalTo(self.textView).mas_offset(-7.0);
        make.bottom.mas_equalTo(self.textView).mas_offset(7.0);
    }];
    
    [self addSubview:self.sendBtn];
    self.sendBtn.centerY = self.textView.centerY;
    
//    [self.sendBtn addSubview:self.line];
    
    LXWS(weakSelf);
    [self.sendBtn addClickBlock:^(UIButton *button) {
        
        if (weakSelf.sendBlock) {
            NSString *str = [[QukanSensitiveTextTool sharedInstance] filter:weakSelf.textView.text];
            weakSelf.sendBlock(str);
        }
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView endEditing:YES];
        NSString *str = [[QukanSensitiveTextTool sharedInstance] filter:self.textView.text];
        self.sendBlock(str);
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat lineH = self.textView.font.lineHeight;
    
    CGFloat maxHeight = ceil(lineH * self.maxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxHeight) {
        self.textView.height = contentSizeH;
    }else{
        self.textView.height = maxHeight;
    }
    
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
  
    
    CGFloat totalH = ceil(self.textView.height) + 2 * self.topOrBottomEdge;
    self.frame = CGRectMake(0, keyboardY - totalH-self.NavHeight-self.yOffset, self.width, totalH);
   
  
//    self.sendBtn.height = totalH;
    self.sendBtn.centerY = self.self.textView.centerY;
    self.line.height = totalH - 10;
    
    if (textView.text.length<=0) {
        self.sendBtn.userInteractionEnabled = NO;
        self.sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        self.sendBtn.userInteractionEnabled = YES;
        self.sendBtn.layer.borderColor = kThemeColor.CGColor;
        [self.sendBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    }
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification{

    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        NSLog(@"%@",NSStringFromCGRect(keyboardF));
    keyboardY = keyboardF.origin.y;

    if (!_isDisappear) {

        [self dealKeyBoardWithKeyboardF:keyboardY duration:duration];
       
    }


}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        NSLog(@"%@",NSStringFromCGRect(keyboardF));
    keyboardY = keyboardF.origin.y;
//    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (_isDisappear) {
        [self dealKeyBoardWithKeyboardF:keyboardY duration:duration];
    }
}
#pragma mark---处理高度---
-(void)dealKeyBoardWithKeyboardF:(CGFloat)keyboardY duration:(CGFloat)duration {
    
    if (!_isDisappear) {
        [UIView animateWithDuration:duration animations:^{
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            
            if (keyboardY > Device_Height) {
                self.top = Device_Height- self.height-self.NavHeight-self.yOffset;
            }else
            {
                self.top = keyboardY - self.height-self.NavHeight-self.yOffset;
            }
        }];
    }else{
        if (keyboardY > Device_Height) {
            self.top = Device_Height- self.height-self.NavHeight-self.yOffset;
        }else
        {
            self.top = keyboardY - self.height-self.NavHeight-self.yOffset;
        }
    }
    
    if (self.top >=Device_Height-self.size.height-self.NavHeight-100.0-self.yOffset) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}
#pragma mark---setter---
-(void)setTopOrBottomEdge:(CGFloat)topOrBottomEdge{
    _topOrBottomEdge  = topOrBottomEdge;
    
    if (!_topOrBottomEdge) {
        topOrBottomEdge = 10;
    }
}
-(void)setMaxLine:(int)maxLine{
    _maxLine = maxLine;
    
    if (!_maxLine || _maxLine <=0) {
        _maxLine = 3;
    }
    
}
-(void)setFont:(UIFont *)font{
    _font = font;
    if (!font) {
        _font = Font(16);
    }
    
    
}
-(void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
}


#pragma mark---getter---
-(QukanLXTextView *)textView{
    if (!_textView) {
        _textView =[[QukanLXTextView alloc]initWithFrame:CGRectMake(20, self.topOrBottomEdge, self.width - 100, ceil(self.font.lineHeight))];
        _textView.font = self.font;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
         _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
        _textView.textContainerInset = UIEdgeInsetsZero; 
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}
-(QukanLxButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn =[QukanLxButton LXButtonWithTitle:@"发送" titleFont:Font(14) Image:nil backgroundImage:nil backgroundColor:[UIColor clearColor] titleColor:[UIColor lightGrayColor] frame:CGRectMake(self.width - 60, 0, 50, 30.0)];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5.0;
        _sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _sendBtn.layer.borderWidth = 0.5;
    }
    return _sendBtn;
}
-(UIView *)line{
    if (!_line) {
        _line =[[UIView alloc]initWithFrame:CGRectMake(0, 5, 1,  self.btnH - 10)];
        _line.backgroundColor = HEXColor(0xc2c2c2);
//        [UIColor hex :@"c2c2c2"];
    }
    return _line;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textView.placeholder = placeholder;

}

- (void)becomeFirstResponder {
    if (self.isKeyBoard) {
        return;
    }
    [self.textView becomeFirstResponder];
    self.isKeyBoard = YES;
}
- (void)endEditing {
    self.isKeyBoard = NO;
    [self.textView endEditing:YES];
}
- (void)clearText {
    self.textView.text = nil;
}
@end
