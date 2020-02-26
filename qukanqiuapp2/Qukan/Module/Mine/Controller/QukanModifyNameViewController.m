#import "QukanModifyNameViewController.h"
#import "QukanApiManager+Mine.h"

@interface QukanModifyNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end
@implementation QukanModifyNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改名字";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = [self.view viewWithTag:300];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4.0;
    btn.backgroundColor = kThemeColor;
    self.nameTextField.text = kUserManager.user.nickname;
    [self lawe];
    
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (NSString *)specialSymbolsAction {
    //数学符号
    NSString *matSym = @" ﹢﹣×÷±/=≌∽≦≧≒﹤﹥≈≡≠=≤≥<>≮≯∷∶∫∮∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙√∟⊿㏒㏑%‰⅟½⅓⅕⅙⅛⅔⅖⅚⅜¾⅗⅝⅞⅘≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩⊰⊱⋛⋚∫∬∭∮∯∰∱∲∳%℅‰‱øØπ";
    
    //标点符号
    NSString *punSym = @"。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑·¨….¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿_-ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽_﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼❝❞!():,'[]｛｝^・.·．•＃＾＊＋＝＼＜＞＆§⋯`－–／—|\"\\";

    
    //制表符
    NSString *tabSym = @"─ ━│┃╌╍╎╏┄ ┅┆┇┈ ┉┊┋┌┍┎┏┐┑┒┓└ ┕┖┗ ┘┙┚┛├┝┞┟┠┡┢┣ ┤┥┦┧┨┩┪┫┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╪ ╫ ╬═║╒╓╔ ╕╖╗╘╙╚ ╛╜╝╞╟╠ ╡╢╣╤ ╥ ╦ ╧ ╨ ╩ ╳╔ ╗╝╚ ╬ ═ ╓ ╩ ┠ ┨┯ ┷┏ ┓┗ ┛┳ ⊥ ﹃ ﹄┌ ╮ ╭ ╯╰";
    
    return [NSString stringWithFormat:@"%@%@%@",matSym,punSym,tabSym];
}

//是否含有表情
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (IBAction)save:(id)sender {
    
    if ([self stringContainsEmoji:self.nameTextField.text]) {
        [self.nameTextField resignFirstResponder];
        [self.view showTip:@"请勿输入表情"];
        return;
    }
    
    NSString *name = [self.nameTextField.text stringByTrim];
    
    [self.nameTextField resignFirstResponder];
    if (name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入名字"];
    } else {
        if (name.length > 10) {
            [SVProgressHUD showErrorWithStatus:@"输入过长，限制字符不能超过10个"];
        }else{

            //        NSDictionary *parameters = @{@"nickname":self.nameTextField.text};

            //        [QukanNetworkTool Qukan_POST:@"gcuser/update" parameters:parameters success:^(NSDictionary *response) {
            //            @strongify(self)
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            if ([response[@"status"] integerValue]==200) {
            //                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            //                kUserManager.user.nickname = self.nameTextField.text;
            ////                [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:Qukan_Name_Key];
            //                [self.navigationController popViewControllerAnimated:YES];
            //            } else {
            //                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            //            }
            //        } failure:^(NSError *error) {
            //            [MBProgressHUD hideHUDForView:self.view animated:NO];
            //            [SVProgressHUD showErrorWithStatus:@"保存失败"];
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            //        }];
            KShowHUD
            @weakify(self)
            [[[kApiManager QukangcuserUpdateWithNickname:name] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                KHideHUD
                [self dataSourceDealWith:x];
            } error:^(NSError * _Nullable error) {
                KHideHUD;
//                [SVProgressHUD showErrorWithStatus:@"保存失败"];
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        }
    }
}

- (void)dataSourceDealWith:(id)response {
    [SVProgressHUD showSuccessWithStatus:FormatString(@"您的昵称已修改成功，正在%@中，请耐心等待~",kStStatus.phone)];
//    kUserManager.user.nickname = self.nameTextField.text;
//
//    QukanUserModel *userModel = [[QukanUserModel alloc] init];
//    userModel = kUserManager.user;
//    userModel.nickname = self.nameTextField.text;
//    [kUserManager setUserData:userModel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)textFieldDidChange:(UITextField *)textField {
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:[self specialSymbolsAction]];
//    NSString *text = [[textField.text componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
//    textField.text = text;
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData* da = [text dataUsingEncoding:enc];
//    NSUInteger lengthTest = [da length];
//    if (lengthTest > 16) {
//        NSString *effectiveStr = [self subTextString:text len:8];
//        textField.text = effectiveStr;
//    }
    
    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }else{
            
        }
    }
}

//按照字节来截取字符串
-(NSString*)subTextString:(NSString*)str len:(NSInteger)len{
    if(str.length<=len)return str;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    
    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@",[sb copy]];
        }
    }
    return str;
}


- (void)lawe {
    UITextRange* textRange = [self.nameTextField textRangeFromPosition:self.nameTextField.beginningOfDocument toPosition:self.nameTextField.beginningOfDocument];
    [self.nameTextField setSelectedTextRange:textRange];
//    [self.nameTextField resignFirstResponder];x
}
@end


























