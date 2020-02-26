//
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanWithDetailsViewController.h"
#import "QukanWithRedDetailsCell.h"

@interface QukanWithDetailsViewController ()
/**头部视图*/
@property (strong, nonatomic)  UIView *viewHead;
/**渐变视图*/
@property (strong, nonatomic)  UIView *viewColor;
/**状态*/
@property (strong, nonatomic)  UILabel *labType;
/**状态图片*/
@property (strong, nonatomic)  UIButton *btnIcon;
/**用户头像和名字*/
@property (strong, nonatomic)  UIButton *btnUser;
/**用户头像*/
@property (strong, nonatomic)  UIImageView *imgHead;
/**Number*/
@property (strong, nonatomic)  UIButton *btnMone;

@end

@implementation QukanWithDetailsViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCommonWhiteColor;
    self.title = FormatString(@"%@详情",kStStatus.pageNum);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerNib:[UINib nibWithNibName:@"QukanWithRedDetailsCell" bundle:nil] forCellReuseIdentifier:@"QukanWithRedDetailsCellID"];
    [self addHeadView];
    [self addFootView];
}


- (void)addHeadView{
    self.viewHead = [UIView new];
    self.viewHead.backgroundColor = kCommonWhiteColor;
    [self.tableView setTableHeaderView:self.viewHead];
    [self.viewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    
    
    self.viewColor = [UIView new];
    [self.viewHead addSubview:self.viewColor];
    [self.viewColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.viewHead);
        make.height.mas_equalTo(80);
    }];
    
    
    self.labType = [UILabel new];
    self.labType.textColor = UIColor. blackColor;
    self.labType.font = [UIFont boldSystemFontOfSize:20];
    //    [self.viewColor addSubview:self.labType];
    //    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.viewColor.mas_left).offset(16);
    //        make.centerY.equalTo(self.viewColor.mas_centerY);
    //    }];
    
    self.btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnIcon.userInteractionEnabled = NO;
    //    [self.btnIcon setImage:kImageNamed(@"笑") forState:UIControlStateNormal];
    //    [self.viewColor addSubview:self.btnIcon];
    //    [self.btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.viewColor.mas_right).inset(16);
    //        make.centerY.equalTo(self.viewColor.mas_centerY);
    //    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor. blackColor;
    label.text = FormatString(@"%@账号：",kStStatus.pageNum);
    label.font = [UIFont boldSystemFontOfSize:15];
    [self.viewHead addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewHead.mas_left).offset(16);
        make.top.equalTo(self.viewColor.mas_bottom).offset(20);
    }];
    
    self.imgHead = [UIImageView new];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:kUserManager.user.avatorId] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    self.imgHead.layer.masksToBounds = YES;
    self.imgHead.layer.cornerRadius = 21/2;
    [self.viewHead addSubview:self.imgHead];
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    self.btnUser = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnUser.userInteractionEnabled = NO;
    self.btnUser.titleLabel.font = kFont12;
    [self.btnUser setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    [self.btnUser setTitle:kUserManager.user.nickname.length == 0 ? @"外星人" : kUserManager.user.nickname forState:UIControlStateNormal];
    [self.viewHead addSubview:self.btnUser];
    [self.btnUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(5);
        make.centerY.equalTo(label.mas_centerY);
    }];
    
    UIView *view = [UIView new];
    [self.viewHead addSubview:view];
    view.backgroundColor = HEXColor(0xF9F9F9);
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewHead).offset(16).inset(16);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.mas_equalTo(68);
    }];
    
    self.btnMone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMone.userInteractionEnabled = NO;
    [self.btnMone setTitleColor:kCommonBlackColor forState:UIControlStateNormal];

    //    @"微信1"
    [self.btnMone setTitle:[NSString stringWithFormat:@"%@%@%@%@",kStStatus.name,kStStatus.pageNum,self.model.amount,kStStatus.dark] forState:UIControlStateNormal];

    self.btnMone.titleLabel.font = kFont13;
    [view addSubview:self.btnMone];
    [self.btnMone setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.btnMone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(26);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = UIColor. blackColor;
    label2.text = FormatString(@"%@%@",kStStatus.pageNum,kStStatus.page);
    label2.font = [UIFont boldSystemFontOfSize:15];
    [self.viewHead addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(view.mas_bottom).offset(20);
    }];
    
    UIView *line = [UIView new];
    [self.viewHead addSubview:line];
    line.backgroundColor = HEXColor(0xF9F9F9);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewHead).offset(16).inset(16);
        make.bottom.equalTo(self.viewHead.mas_bottom).offset(10);
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.viewHead layoutIfNeeded];
    
    [self setHeadViewType:self.model.status.integerValue];
    
}


-(void)addFootView{
    UIView *viewFoot = [UIView new];
    viewFoot.frame = CGRectMake(0, 0, kScreenWidth, 130);
    viewFoot.backgroundColor = kCommonWhiteColor;
    [self.tableView setTableFooterView:viewFoot];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = UIColor. blackColor;
    label2.text = FormatString(@"%@%@",kStStatus.pageNum,kStStatus.page);
    label2.font = [UIFont boldSystemFontOfSize:15];
    [viewFoot addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewFoot).offset(16);
        make.top.equalTo(viewFoot).offset(40);
    }];
    
    UIView *line = [UIView new];
    [viewFoot addSubview:line];
    line.backgroundColor = HEXColor(0xF9F9F9);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewFoot).offset(16).inset(16);
        
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textColor = kTextGrayColor;
    label3.text = kStStatus.title1;
    
    label3.numberOfLines = 0;
    label3.font = kFont12;
    [viewFoot addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewFoot).offset(16).inset(16);
        make.top.equalTo(line).offset(13);
        make.bottom.equalTo(viewFoot.mas_bottom).offset(10);
    }];
    
    [viewFoot layoutIfNeeded];
    
}

-(void)setHeadViewType:(NSInteger)type{
    switch (type) {
        case 0:{
            
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,kScreenWidth,80);
            gl.startPoint = CGPointMake(0.96, 0.5);
            gl.endPoint = CGPointMake(0.02, 0.5);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:224/255.0 blue:122/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:253/255.0 blue:234/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0), @(1.0f)];
            [self.viewColor.layer addSublayer:gl];
            
            self.labType.text = @"等待确认中";
            [self.viewColor addSubview:self.labType];
            [self.btnIcon setImage:kImageNamed(@"Qukan_waitSureIng") forState:UIControlStateNormal];
            [self.viewColor addSubview:self.btnIcon];
        }
            break;
            
        case 1:{
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,kScreenWidth,80);
            gl.startPoint = CGPointMake(1, 0.5);
            gl.endPoint = CGPointMake(0.02, 0.5);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:170/255.0 green:237/255.0 blue:169/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:247/255.0 green:255/255.0 blue:245/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0), @(1.0f)];
            [self.viewColor.layer addSublayer:gl];
            
            self.labType.text = FormatString(@"正在%@中",kStStatus.phone);
            [self.viewColor addSubview:self.labType];
            [self.btnIcon setImage:kImageNamed(@"Qukan_readingIcon") forState:UIControlStateNormal];
            [self.viewColor addSubview:self.btnIcon];
        }
            
            break;
        case 2:{
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,kScreenWidth,80);
            gl.startPoint = CGPointMake(0, 0.5);
            gl.endPoint = CGPointMake(1, 0.5);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:251/255.0 blue:252/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:130/255.0 green:170/255.0 blue:242/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0), @(1.0f)];
            [self.viewColor.layer addSublayer:gl];
            
            self.labType.text = FormatString(@"%@成功",kStStatus.pageNum);
            [self.viewColor addSubview:self.labType];
            [self.btnIcon setImage:kImageNamed(@"Qukan_smile") forState:UIControlStateNormal];
            [self.viewColor addSubview:self.btnIcon];
        }
            
            break;
        case 3:{
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,kScreenWidth,80);
            gl.startPoint = CGPointMake(1, 0.5);
            gl.endPoint = CGPointMake(-0.08, 0.5);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0), @(1.0f)];
            [self.viewColor.layer addSublayer:gl];
            
            self.labType.text = FormatString(@"%@失败",kStStatus.pageNum);
            [self.viewColor addSubview:self.labType];
            [self.btnIcon setImage:kImageNamed(@"Qukan_cry") forState:UIControlStateNormal];
            [self.viewColor addSubview:self.btnIcon];
        }
            
            break;
    }
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewColor.mas_left).offset(16);
        make.centerY.equalTo(self.viewColor.mas_centerY);
    }];
    
    [self.btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewColor.mas_right).inset(16);
        make.centerY.equalTo(self.viewColor.mas_centerY);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    createdDate 提交时间
    //    updateDate 失败更新
    //    checkDate 校验
    //    doneDate 完成
    //    状态 0等待确认 1 2成功 3失败
    
    
    return self.arrModel.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try{
        QukanWithRedDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanWithRedDetailsCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setlabTitle:self.arrModel[indexPath.row][@"title"] labSubTitle:self.arrModel[indexPath.row][@"content"]];
        return cell;
        
        
    }
    @catch(NSException *exception) {
        NSLog(@"异常错误是:%@", exception);
    }
    @finally {
        
    }
    
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 40;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [UIView new];
    v.backgroundColor = kCommonWhiteColor;
    return v;
}

@end
