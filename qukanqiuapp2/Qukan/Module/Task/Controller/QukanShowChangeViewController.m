//
//  QukanShowChangeViewController.m
//  Qukan
//
//  Created by hello on 2019/8/21.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanShowChangeViewController.h"
#import "QukanShareCenterViewController.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanListDetailViewController.h"
#import "QukanWeekModel.h"

@interface QukanShowChangeViewController ()

@property (strong, nonatomic)  UIImageView *CodeImage;
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger code;

@property(nonatomic, strong) UIView          *allView;
@property(nonatomic, strong) UILabel          *labMon;
@property(nonatomic, strong) UIView          *showView;
@property(nonatomic, strong) UIButton          *wearButton;
@property(nonatomic, strong) UIButton          *NoButton;
@property(nonatomic, strong) UILabel          *titleLabel;
@property(nonatomic, strong) UILabel          *describeLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) QukanWeekModel *model;
@property (strong, nonatomic)  NSArray *arrRed;
@property(nonatomic, strong) NSString *sigString;

@end

@implementation QukanShowChangeViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = FormatString(@"%@%@",kStStatus.pageNum,kStStatus.pageSize);
    //    self.code = 803;
    
    [self addRightBtn];
    [self Qukan_GetRedList];
    
    
}

- (void)dealloc
{
    DEBUGLog(@"%@  dealloced", NSStringFromClass([QukanShowChangeViewController class]));
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    KHideHUD
}

- (void)addRightBtn {
    self.view.backgroundColor = RGB(245, 245, 245);
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:FormatString(@"%@详情",kStStatus.pageNum) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    rightBarItem.tintColor = kCommonWhiteColor;
    // 字体大小
    [rightBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12], NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn {
    QukanListDetailViewController *vc = [QukanListDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUI{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight - 60 - kTopBarHeight)];
    self.scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.scrollView];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UIView *view = [[UIView alloc] init];
    [self.scrollView addSubview:view];
    view.frame = CGRectMake(16,15,kScreenWidth - 32,80);
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,7);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 15;
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(16,view.height/2-10,84,20);
    [view addSubview:label1];
    label1.text = FormatString(@"当前%@%@",kStStatus.pageSize,kStStatus.otherName);
    label1.font = kFont11;
    label1.textColor = kTextGrayColor;
    label1.textAlignment = NSTextAlignmentCenter;
    
    
    _labMon= [[UILabel alloc] init];
    _labMon.frame = CGRectMake(15,view.height/2 - 21,view.width - 30,42);
    [view addSubview:_labMon];
    _labMon.text = FormatString(@"0%@",kStStatus.dark);
    _labMon.textColor = [UIColor colorWithRed:233/255.0 green:67/255.0 blue:52/255.0 alpha:1.0];
    _labMon.font = [UIFont boldSystemFontOfSize:35];
    _labMon.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(16,view.mj_y+view.height+15,64,22);
    [self.scrollView addSubview:label3];
    label1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    label3.textAlignment = NSTextAlignmentCenter;
    
    
    
    view = [[UIView alloc] init];
    view.frame = CGRectMake(16,CGRectGetMaxY(label3.frame) + 15,122,36);
    [self.scrollView addSubview:view];
    view.layer.backgroundColor = [UIColor colorWithRed:19/255.0 green:194/255.0 blue:38/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 5;
    
    UIImage *im = [UIImage imageNamed:@"Qukan_wxIcon"];
    UIImageView *img = [[UIImageView alloc] initWithImage:im];
    img.frame = CGRectMake(20, 8, im.size.width, im.size.height);
    [view addSubview:img];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(CGRectGetMaxX(img.frame) + 15,view.height/2 - 11,40,22);
    [view addSubview:label4];
    label4.text = kStStatus.name;
    label4.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    label4.textAlignment = NSTextAlignmentLeft;
    
    
    label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(16,view.mj_y+view.height+30,64,22);
    [self.scrollView addSubview:label3];
    label3.text = FormatString(@"%@%@",kStStatus.pageNum,kStStatus.page);
    label3.font = kFont13;
    label3.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label6 = [[UILabel alloc] init];
    label6.text = FormatString(@"每日可%@2次",kStStatus.pageNum);
    label6.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    label6.font = kFont11;
    [self.scrollView addSubview:label6];
    
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(10);
        make.centerY.equalTo(label3.mas_centerY);
    }];
    
    CGFloat btnWith = (kScreenWidth - 15*3)/2;
    CGFloat btnheight = 67;
    CGFloat margin = 15;
    
    
    for (int i = 0; i < self.arrRed.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+100;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        [btn setTitle:[NSString stringWithFormat:@"%@%@",self.arrRed[i],kStStatus.dark] forState:UIControlStateNormal];
        [btn setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        btn.backgroundColor = kCommonWhiteColor;
        [self.scrollView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label6.mas_bottom ).offset( (i / 2 ) * (margin + btnheight) +margin) ;
            make.left.mas_equalTo((margin + btnWith) * (i % 2) + margin);
            make.width.mas_equalTo(btnWith);
            make.height.mas_equalTo(btnheight);
        }];
        
        switch (i) {//进来默认选中 1 这个
            case 0:{
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 25, 0, 25)];
                self.index = btn.tag - 100;
                [btn setSelected:YES];
                btn.layer.borderColor = kThemeColor.CGColor;
                btn.layer.borderWidth = 0.5;
                
                UILabel *jslab = [UILabel new];
                jslab.text = FormatString(@" 急速%@ ",kStStatus.countText);
                jslab.font = [UIFont systemFontOfSize:11];
                jslab.textColor = kCommonWhiteColor;
                jslab.backgroundColor = kThemeColor;
                jslab.layer.masksToBounds = YES;
                jslab.layer.cornerRadius = 3;
                
                [btn addSubview:jslab];
                [jslab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(btn.titleLabel.mas_centerY);
                    make.left.equalTo(btn.titleLabel.mas_right).offset(10);
                }];
            }
                break;
                
        }
        
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSLog(@"%ld",x.tag);
            for (int i = 0; i < self.arrRed.count; i ++) {
                UIButton *bb = [self.view viewWithTag:i+100];
                [bb setSelected:NO];
                bb.layer.borderColor = kCommonWhiteColor.CGColor;
                bb.layer.borderWidth = 0;
            }
            [x setSelected:YES];
            x.layer.borderColor = kThemeColor.CGColor;
            x.layer.borderWidth = 0.5;
            self.index = x.tag - 100;
        }];
    }
    
    
    
    [self.view layoutIfNeeded];
    
    UIButton *bottm = [self.view viewWithTag:self.arrRed.count-1+100];
    label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(16,bottm.mj_y+bottm.height+30,64,22);
    [self.scrollView addSubview:label3];
    label3.text = FormatString(@"%@规则",kStStatus.pageNum);
    label3.font = kFont13;
    
    UILabel *content = [[UILabel alloc] init];
    
    
    self.sigString = [self.sigString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n" ];
    self.sigString = [self.sigString stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    self.sigString = [self.sigString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">" ];
    
    content.text = self.sigString;
    content.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    content.font = kFont10;
    content.numberOfLines = 0;
    [self.scrollView addSubview:content];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(10);
        make.left.equalTo(label3.mas_left);
        make.width.mas_equalTo(kScreenWidth - 16*2);
    }];
    
    [content layoutIfNeeded];
    
    [self performSelector:@selector(setMyContentSize:) withObject:content afterDelay:1.0];
    
    //    [self addContentView];
    
    
    view = [[UIView alloc] init];
    view.backgroundColor = kCommonWhiteColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-kSafeAreaBottomHeight);
        make.height.mas_equalTo(60);
    }];
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.tag = 1000;
    okButton.layer.masksToBounds = YES;
    okButton.layer.cornerRadius = 5;
    okButton.backgroundColor = kThemeColor;
    [okButton setTitle:FormatString(@"立即%@",kStStatus.pageNum) forState:UIControlStateNormal];
    [view addSubview:okButton];
    
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).inset(16);
        make.centerY.equalTo(view.mas_centerY);
        make.height.mas_equalTo(44);
    }];
    @weakify(self)
    [[okButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        //        for (int i = 0; i < self.arrRed.count; i ++) {
        //            UIButton *bb = [self.view viewWithTag:i+100];
        //            if (bb.isSelected) {
        //                NSString *str = [bb.titleLabel.text stringByReplacingOccurrencesOfString:FormatString(@"%@",kStStatus.dark) withString:@""];
        //                [self QukanUserReads:str];
        //            }
        //        }
        
        [self setPopType:3 text:@""];
        
        
        //        [self setPopType:self.index];
        //        self.index++;
    }];
    
}


-(void)setMyContentSize:(UILabel *)content{
    
    [self.scrollView setContentSize:CGSizeMake(0, content.mj_y+content.height+20)];
    
}

-(void)setPopView{
    UIView * allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    allView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [kKeyWindow addSubview:allView];
    _allView = allView;
    //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCilk:)];
    //        [allView addGestureRecognizer:tap];
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 654 / 2, 456 / 2)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.userInteractionEnabled = YES;
    showView.layer.cornerRadius = 5;
    showView.center = allView.center;
    _showView = showView;
    [allView addSubview:showView];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(showView.width/2-25,20 , 50 , 50)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:kUserManager.user.avatorId] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 5;
    [showView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iconImageView.bottom + 5, showView.width - 20, 25)];
    titleLabel.text = kUserManager.user.nickname.length > 0 ?  kUserManager.user.nickname : @"外星人";
    titleLabel.textColor = HEXColor(0x666666);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [showView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 10, showView.width - 20, 40)];
    describeLabel.text = FormatString(@"即将%@至您的%@%@",kStStatus.pageNum,kStStatus.name,kStStatus.takecount);
    describeLabel.numberOfLines = 0;
    describeLabel.textColor = kCommonTextColor;
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.font = [UIFont systemFontOfSize:13];
    [showView addSubview:describeLabel];
    _describeLabel = describeLabel;
    
    UIButton *wearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wearButton.frame = CGRectMake(showView.width / 2 - 132 / 2, describeLabel.bottom + 15,132, 44);
    
    // gradient
    //    CAGradientLayer *gl = [CAGradientLayer layer];
    //    gl.frame = wearButton.frame;
    //    gl.startPoint = CGPointMake(0, 1);
    //    gl.endPoint = CGPointMake(0.76, 0.5);
    //    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:142/255.0 blue:0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:85/255.0 blue:0/255.0 alpha:1.0].CGColor];
    //    gl.locations = @[@(0), @(1.0f)];
    //    [wearButton.layer addSublayer:gl];
    
    [wearButton setTitle:@"确 定" forState:UIControlStateNormal];
    [wearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wearButton.layer.cornerRadius = 10;
    wearButton.backgroundColor = kThemeColor;
    wearButton.titleLabel.font = kFont16;
    [showView addSubview:wearButton];
    _wearButton = wearButton;
    @weakify(self)
    [[wearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self tapCilk:nil];
        
        
        if ([wearButton.titleLabel.text containsString:@"去关注"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"";
            // wxString微信号然后就是在代码里需要跳转的地方直接调用，代码如下
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:url];
            }else{
                
            }
        }else if ([wearButton.titleLabel.text containsString:FormatString(@"去%@",kStStatus.trees)]){
            QukanShareCenterViewController *VC = [QukanShareCenterViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        } else if ([wearButton.titleLabel.text containsString:FormatString(@"去%@",kStStatus.pageNum)]) {
            for (int i = 0; i < self.arrRed.count; i ++) {
                UIButton *bb = [self.view viewWithTag:i+100];
                if (bb.isSelected) {
                    NSString *str = [bb.titleLabel.text stringByReplacingOccurrencesOfString:FormatString(@"%@",kStStatus.dark) withString:@""];
                    [self QukanUserReads:str];
                    break;
                }
            }
        }
        
    }];
    
    
    UIButton *NoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NoButton.frame = CGRectMake(showView.width / 2 - 132 / 2, describeLabel.bottom + 15,132, 44);
    [NoButton setTitle:FormatString(@"放弃%@",kStStatus.pageNum) forState:UIControlStateNormal];
    [NoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NoButton.backgroundColor = HEXColor(0xCCCCCC);
    NoButton.layer.cornerRadius = 10;
    NoButton.titleLabel.font = kFont16;
    NoButton.hidden = YES;
    [showView addSubview:NoButton];
    _NoButton = NoButton;
    
    [[NoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self tapCilk:nil];
    }];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(kScreenWidth / 2 - 30, showView.bottom + 20, 60, 60);
    [cancleButton setImage:kImageNamed(@"Qukan_txClose") forState:UIControlStateNormal];
    [allView addSubview:cancleButton];
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self tapCilk:nil];
    }];
    
    
    
}


-(void)setPopType:(NSInteger)type text:(NSString *)text{
    [self setPopView];
    switch (type) {
        case 0:
            _titleLabel.font = kFont13;
            _titleLabel.textColor = kCommonDarkGrayColor;
            _titleLabel.frame = CGRectMake(15, 55,_showView.width - 30, 50);
            //            _titleLabel.frame = CGRectMake(10, _iconImageView.bottom + 5, _showView.width - 20, 25);
            if (text.length > 0) {
                _titleLabel.text = text;
            }
            
            _wearButton.mj_x = _showView.width - _wearButton.width - 20;
            [_wearButton setTitle:@"去关注" forState:UIControlStateNormal];
            
            _NoButton.mj_x = 15;
            _NoButton.hidden = NO;
            
            _describeLabel.hidden = YES;
            
            _iconImageView.hidden = YES;
            
            
            break;
        case 1:
            _titleLabel.font = kFont13;
            _titleLabel.textColor = kCommonDarkGrayColor;
            _titleLabel.frame = CGRectMake(15, 45,_showView.width - 30, 40);
            if (text.length > 0) {
                _titleLabel.text = text;
            }
            
            _wearButton.mj_x = _showView.width / 2 - 132 / 2;
            [_wearButton setTitle:@"确 定" forState:UIControlStateNormal];
            
            _NoButton.hidden = YES;
            
            _describeLabel.hidden = YES;
            
            _iconImageView.hidden = YES;
            
            
            
            break;
        case 2:
            //            _titleLabel.font = kFont13;
            //            _titleLabel.textColor = kCommonDarkGrayColor;
            _titleLabel.frame = CGRectMake(10, _iconImageView.bottom + 5, _showView.width - 20, 25);
            
            
            _wearButton.mj_x = _showView.width / 2 - 132 / 2;
            [_wearButton setTitle:@"确 定" forState:UIControlStateNormal];
            
            _NoButton.hidden = YES;
            
            _describeLabel.hidden = NO;
            if (text.length > 0) {
                _describeLabel.text = text;
            }
            
            _iconImageView.hidden = NO;
            
            break;
        case 3:
            //            _titleLabel.font = kFont13;
            //            _titleLabel.textColor = kCommonDarkGrayColor;
            _titleLabel.frame = CGRectMake(10, _iconImageView.bottom + 5, _showView.width - 20, 25);
            
            
            _wearButton.mj_x = _showView.width / 2 - 132 / 2;
            [_wearButton setTitle:FormatString(@"去%@",kStStatus.pageNum) forState:UIControlStateNormal];
            
            _NoButton.hidden = YES;
            
            _describeLabel.hidden = NO;
            if (text.length > 0) {
                _describeLabel.text = text;
            }
            
            _iconImageView.hidden = NO;
            
            break;
            
        case 4:
            //            _titleLabel.font = kFont13;
            //            _titleLabel.textColor = kCommonDarkGrayColor;
            _titleLabel.frame = CGRectMake(10, _iconImageView.bottom + 5, _showView.width - 20, 25);
            
            
            _wearButton.mj_x = _showView.width / 2 - 132 / 2;
            [_wearButton setTitle:@"确 定" forState:UIControlStateNormal];
            
            _NoButton.hidden = YES;
            
            _describeLabel.hidden = NO;
            if (text.length > 0) {
                _describeLabel.text = [NSString stringWithFormat:@"申请%@成功",kStStatus.pageNum];
            }
            
            _iconImageView.hidden = NO;
            
            break;
            
    }
}


- (void)tapCilk:(UITapGestureRecognizer *)ges {
    [_allView removeAllSubviews];
    [_allView removeFromSuperview];
}

#pragma mark ===================== NetWork ==================================
#pragma mark 查询用户鸿包列表
- (void)Qukan_GetRedList {
    
    
    RACSignal *redListSignal = [kApiManager QukanGetInfoList];
    RACSignal *monSignal = [kApiManager QukanSelectDate];
    RACSignal *sigSignal = [kApiManager QukanGetSig];
    @weakify(self)
    KShowHUD
    [[[RACSignal zip:@[redListSignal, monSignal,sigSignal] ] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        KHideHUD
        self.arrRed = [(NSString *)x.first componentsSeparatedByString:@","];
        if ([x.third isKindOfClass:[NSString class]]) {
            self.sigString = (NSString *)x.third;
        }
        if (self.arrRed.count != 0 ){
            [self setUI];
        }
        
        self.model = [QukanWeekModel modelWithJSON:x.second];
        self.labMon.text =[NSString stringWithFormat:@"%@%@",self.model.changeNum,kStStatus.dark];
        self.labMon.textColor = [UIColor colorWithRed:233/255.0 green:67/255.0 blue:52/255.0 alpha:1.0];
        self.labMon.font = [UIFont boldSystemFontOfSize:35];
        
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

#pragma mark 查询用户鸿包余额
- (void)QukanSelectDate {
    @weakify(self)
    
    KShowHUD
    [[[kApiManager QukanSelectDate] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        self.model = [QukanWeekModel modelWithJSON:x];
        self.labMon.text =[NSString stringWithFormat:@"%@%@",self.model.changeNum,kStStatus.dark];
        self.labMon.textColor = [UIColor colorWithRed:233/255.0 green:67/255.0 blue:52/255.0 alpha:1.0];
        self.labMon.font = [UIFont boldSystemFontOfSize:35];
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        KHideHUD
        [SVProgressHUD showInfoWithStatus:FormatString(@"获取%@失败",kStStatus.page)];
    }];
}

#pragma mark
- (void)QukanUserReads:(NSString *)red {
    KShowHUD
    @weakify(self)
    [[[kApiManager QukanUserReads:red] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        KHideHUD
        [self setPopType:4 text: [NSString stringWithFormat:@"申请%@成功",kStStatus.pageNum]];
        [self QukanSelectDate];
        if (red.integerValue != 0) {
            if (self.PopClickBlock) {
                self.PopClickBlock(red.integerValue);
            }
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        switch (error.code) {
            case 803:
                //请关注公众号
                [self setPopType:0 text:error.localizedDescription];
                break;
            case 805:
                //余额不够
                [self setPopType:2 text:error.localizedDescription];
                [self.wearButton setTitle:FormatString(@"去%@",kStStatus.trees) forState:UIControlStateNormal];
                self.wearButton.hidden = YES;
                break;
            case 806:
                //不能大于100
                [self setPopType:2 text:error.localizedDescription];
                break;
            case 807:
                //已有一笔正在审核
                [self setPopType:2 text:error.localizedDescription];
                [self.wearButton setTitle:@"知道了" forState:UIControlStateNormal];
                break;
            case 808:
                //还有未处理
                [self setPopType:2 text:error.localizedDescription];
                break;
            case 809:
                //次数不足
                [self setPopType:2 text:error.localizedDescription];
                break;
                
            default:
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                break;
        }
        //        self.code++;
        
    }];
}




@end
