//
//  QukanMessageViewController.m
//  Qukan
//
//  Created by pfc on 2019/6/21.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanMessageViewController.h"
#import "QukanMessageTableViewCell.h"
#import "QukanMessageModel.h"
#import "QukanSystemMessageViewController.h"
#import "QukanChatViewController.h"
#import "QukanApiManager+Mine.h"
#import "QukanApiManager+PersonCenter.h"

@interface QukanMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView                          *tableView;

@property(nonatomic, strong) NSMutableArray <QukanMessageModel *> *datas;

// 系统消息未读数
@property(nonatomic, copy) NSString *num_systemNum;

@property(nonatomic, strong) NSDictionary   *dic_lastMsgInfo;

@end

@implementation QukanMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self queryNoReadMessage];
}

- (void)interFace {
    self.title = @"我的消息";
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.datas = @[].mutableCopy;

//    NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
//    NIMRecentSession *recent = recentSessions.lastObject;
////    NSLog(@"%@",recent.lastMessage);
}

- (void)queryNoReadMessage {
    @weakify(self)
    [[[kApiManager QukanNoReadMessageWithUserId:[NSString stringWithFormat:@"%ld",kUserManager.user.userId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        DEBUGLog(@"%@",x);
        
        self.num_systemNum = [x objectForKey:@"count"];
        self.dic_lastMsgInfo = [x objectForKey:@"gcUserNotice"];
        [self.tableView reloadData];
        
        
        // 未读消息数量
        NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
        NSInteger nuReadNum = [[kUserDefaults objectForKey:unReadNumberStr] integerValue];
        
        if (self.num_systemNum.integerValue + nuReadNum > 0) {
            [self Qukan_setNavBarButtonItemWithShow:YES];
        }else {
            [self Qukan_setNavBarButtonItemWithShow:NO];
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)Qukan_setNavBarButtonItemWithShow:(BOOL)show {
    if (show) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self
                action:@selector(Qukan_leftBarButtonItemClick)
      forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:@"忽略未读消息" forState:UIControlStateNormal];
        btn.titleLabel.font = kFont13;
        btn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 28.0, 10.0, 0.0);
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = backItem;
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)Qukan_leftBarButtonItemClick {
    [self Qukan_gcUserNoticeSelectNoticeWithCursor:[self getNowTimeStr]];
}


- (void)Qukan_gcUserNoticeSelectNoticeWithCursor:(NSString *)cursor {
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanGcUserNoticeSelectNoticeWithCursor:cursor WithPagingSize:100] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        [self Qukan_setNavBarButtonItemWithShow:NO];
        self.num_systemNum = @"0";
        // 设置未读信息数量为0
        NSString *str = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
        [kUserDefaults setObject:@"0" forKey:str];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}


- (NSString *)getNowTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *nowDate = [NSDate date];
    NSString *nowStr = [dateFormatter stringFromDate:nowDate];
    return nowStr;
}


#pragma mark ===================== SubViews ==================================
- (void)addTableView {
    [self.tableView reloadData];
}

#pragma mark ===================== UITableViewDataSoucre ==================================


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imageArray = @[@"Qukan_systemMessage",@"Qukan_serviceMessage"];
    NSArray *titleArray = @[@"系统消息",@"客服消息"];
    QukanMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanMessageTableViewCell class])];
//    QukanMessageModel *model = self.datas[indexPath.row];
//    [cell Qukan_SetMessageWith:model WithType:1];
    
    if (indexPath.row == 0) {
        if (self.num_systemNum.integerValue > 0) {
            cell.unreadLabel.hidden = NO;
            cell.unreadLabel.text = [NSString stringWithFormat:@"%@条未读",self.num_systemNum];
            cell.view_redPoint.hidden = NO;
        }else {
            cell.view_redPoint.hidden = YES;
            cell.unreadLabel.text = @"0条未读消息";
            cell.unreadLabel.hidden = YES;
        }
        
        if (self.dic_lastMsgInfo) {
            NSLog(@"%@",[self.dic_lastMsgInfo objectForKey:@"content"]);
            NSString *htmlString = [self.dic_lastMsgInfo objectForKey:@"content"];
            NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];
            
//            [nameText setAttributes:@{NSFontAttributeName: kFont14} range:NSMakeRange(0, nameText.length)];
            cell.contentLabel.attributedText = nameText;
            
            cell.timeLabel.text = [self compareCurrentTime:[self.dic_lastMsgInfo objectForKey:@"createTime"]];
        }else {
            cell.contentLabel.text = @"暂无消息";
            cell.timeLabel.text = @"现在";
        }
        
    }else {
        NIMMessage *msg = [QukanIMChatManager sharedInstance].lastedMessage;
        if(msg) {
            if (msg.messageType == NIMMessageTypeText) {
                
                NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithData:[msg.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
                
                [attrs setAttributes:@{NSFontAttributeName: kFont14} range:NSMakeRange(0, attrs.length)];
                cell.contentLabel.attributedText = attrs;
            }
            if (msg.messageType == NIMMessageTypeImage) {
                cell.contentLabel.text = @"[图片]";
            }
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",[self compareCurrentTime:[self cStringFromTimestamp:msg.timestamp]]];
        }else {
            cell.contentLabel.text = @"暂无消息";
            cell.timeLabel.text = @"现在";
        }
        
        NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
        NSInteger nuReadNum = [[kUserDefaults objectForKey:unReadNumberStr] integerValue];
       
        if (nuReadNum > 0) {
            cell.unreadLabel.hidden = NO;
            cell.unreadLabel.text = [NSString stringWithFormat:@"%zd条未读",nuReadNum];
            cell.view_redPoint.hidden = NO;
        }else {
            cell.view_redPoint.hidden = YES;
            cell.unreadLabel.text = @"0条未读消息";
            cell.unreadLabel.hidden = YES;
        }
        
    }
    
    cell.headerImageView.image = kImageNamed(imageArray[indexPath.row]);
    cell.typeLabel.text = titleArray[indexPath.row];
    return cell;
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


-(NSString*)cStringFromTimestamp:(NSInteger)timestamp {
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        QukanSystemMessageViewController *vc = [[QukanSystemMessageViewController alloc] init];
        self.num_systemNum = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        QukanChatViewController *vc = [[QukanChatViewController alloc] initWithUserId:CustomerServiceID headUrl:@""];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== Getters =================================

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.backgroundColor = kCommentBackgroudColor;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[QukanMessageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanMessageTableViewCell class])];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
