#import "QukanFeedbackViewController.h"
#import "QukanApiManager+Mine.h"

#define MAX_LIMIT_NUMS 140

@interface QukanFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic,strong)UILabel *numberWordsLab;

@end
@implementation QukanFeedbackViewController

-(UILabel *)numberWordsLab{
    
    if (!_numberWordsLab) {
        _numberWordsLab = UILabel.new;
//        _numberWordsLab.text = @"0/140";
        [_numberWordsLab sizeToFit];
        _numberWordsLab.textColor = kCommonBlackColor;
        [self.myTextView addSubview:_numberWordsLab];
        [_numberWordsLab mas_makeConstraints:^(MASConstraintMaker *make) {

            make.height.mas_equalTo(SCALING_RATIO(20));
//            make.width.mas_equalTo(SCALING_RATIO(50));
            make.right.equalTo(self.view);
            make.bottom.mas_equalTo(self.myTextView.mj_h);
        }];
    }
    return _numberWordsLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kCommentBackgroudColor;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4.0;
    self.button.backgroundColor = kThemeColor;
    self.myTextView.delegate = self;
    self.myTextView.text = @"请输入反馈内容";
    self.numberWordsLab.alpha = 1;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (IBAction)buttonClick:(id)sender {
    
    if(![self.myTextView.text isEqualToString:@"请输入反馈内容"] && self.myTextView.text.length > 0){
        [self.myTextView endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        NSString *content = self.myTextView.text;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:content forKey:@"content"];
        [parameters setObject:@"" forKey:@"contact"];
        [parameters setObject:@"" forKey:@"imgurl"];
        if (self.myTextView.text.length <= 140) {

            @weakify(self)
            [[[kApiManager QukangcUserFeedbackAddWithContent:content addcontact:@"" addImageUrl:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD showSuccessWithStatus:@"反馈成功~"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });

            } error:^(NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD showSuccessWithStatus:@"提交失败〜"];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD showSuccessWithStatus:@"反馈内容不能超过140个字~"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈的内容〜"];
    }
}
#pragma mark - UITextViewDelegate 限制病情描述输入字数(最多不超过140个字)
- (void)textViewDidEndEditing:(UITextView *)textView {

    if (textView == self.myTextView){

        if(textView.text.length == 0){
            textView.text = @"请输入反馈内容";
            textView.textColor = [UIColor grayColor];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if (textView == self.myTextView){

        if([textView.text isEqualToString:@"请输入反馈内容"]){
            textView.text = @"";
            textView.textColor=[UIColor grayColor];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView == self.myTextView){
        //不支持系统表情的输入
        if ([[textView textInputMode] primaryLanguage] == nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
            return NO;
        }
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //获取高亮部分内容
        //NSString * selectedtext = [textView textInRange:selectedRange];
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
            if (offsetRange.location <MAX_LIMIT_NUMS) {
                return YES;
            }else{
                return NO;
            }
        }
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen =MAX_LIMIT_NUMS - comcatstr.length;
        if (caninputlen >=0){
            return YES;
        }else{
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            if (rg.length >0){
                NSString *s =@"";
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                }else{
                    __block NSInteger idx =0;
                    __block NSString *trimString = @"";//截取出的字串
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                              if (idx >= rg.length) {
                                                  *stop =YES;//取出所需要就break，提高效率
                                                  return ;
                                              }
                                              trimString = [trimString stringByAppendingString:substring];
                                              idx++;
                                          }];
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
                //既然是超出部分截取了，哪一定是最大限制了。
                self.numberWordsLab.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            }
            return NO;
        }
    }
    return NO;
}

//显示当前可输入字数/总字数
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView == self.myTextView){
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //如果在变化中是高亮部分在变，就不要计算字符了
        if (selectedRange && pos) {
            return;
        }
        NSString *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        if (existTextNum >MAX_LIMIT_NUMS){
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
            [textView setText:s];
        }
        //不让显示负数
        self.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
