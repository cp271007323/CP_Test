//
//  QukanPersonChangeViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanPersonChangeViewController.h"
#import "QukanChangeTableViewCell.h"
#import "QukanScreenModel.h"
#import "QukanApiManager+PersonCenter.h"


@interface QukanPersonChangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView                        *tableView;
@property(nonatomic, strong) UIView                             *subView;
@property(nonatomic, strong) UIButton                           *cancleButton;

@property(nonatomic, strong) QukanScreenModel                   *currentModel;
@end

@implementation QukanPersonChangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
}


- (void)interFace {
    self.view.backgroundColor = COLOR_HEX(0x000000, 0.1);
}

- (void)setDatas:(NSArray<QukanScreenModel *> *)datas {
    if (datas == _datas) {
        return;
    }
    _datas = datas;
    
    
    [self addSubviews];
    
    [self startAnimation];
}

- (void)startAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.subView.frame = CGRectMake(0, kScreenHeight - self.subView.height - kSafeAreaBottomHeight , kScreenWidth, self.subView.height + kSafeAreaBottomHeight);
    }];
}

#pragma mark ===================== initUI ==================================

- (void)addSubviews {
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    allButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:allButton];
    [allButton addTarget:self action:@selector(allButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.datas.count * 40 + 60)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.userInteractionEnabled = YES;
    [self.view addSubview:subView];
    _subView = subView;

    //添加表格
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.datas.count * 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [subView addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[QukanChangeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanChangeTableViewCell class])];

    
    //添加按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(kScreenWidth / 2 - 135 / 2, _tableView.bottom + 13, 135, 33);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    cancleButton.layer.borderColor = kThemeColor.CGColor;
    cancleButton.layer.borderWidth = 1;
    cancleButton.layer.cornerRadius = cancleButton.height / 2;
    cancleButton.titleLabel.font = kFont14;
    [subView addSubview:cancleButton];
    _cancleButton = cancleButton;
    
    [cancleButton addTarget:self action:@selector(cancleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addExcView {
    @weakify(self);
    UIView *sureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 268, 138)];
    sureView.backgroundColor = [UIColor whiteColor];
    sureView.layer.cornerRadius = 5;
    sureView.layer.masksToBounds = YES;
    sureView.center = self.view.center;
    [self.view addSubview:sureView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, sureView.width - 20, 30)];
    titleLabel.text = [NSString stringWithFormat:@"是否确认%@%ld个%@",kStStatus.email,self.currentModel.vals,kStStatus.duration];
    titleLabel.textColor = kCommonBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [sureView addSubview:titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 10, sureView.width, 1)];
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [sureView addSubview:lineLabel];
    
    CGFloat buttonW = 92;
    CGFloat buttonH = 31;
    CGFloat margin = (sureView.width - 2 * buttonW) / 3;
    UIButton *canleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    canleButton.frame = CGRectMake(margin, lineLabel.bottom + 25, buttonW, buttonH);
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    canleButton.backgroundColor = [UIColor whiteColor];
    canleButton.layer.borderColor = kThemeColor.CGColor;
    canleButton.titleLabel.font = kFont16;
    canleButton.layer.borderWidth = 1;
    canleButton.layer.cornerRadius = buttonH / 2;
    [sureView addSubview:canleButton];
    [[canleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self disappearTap:nil];
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(canleButton.right + margin, lineLabel.bottom + 25, buttonW, buttonH);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = kThemeColor;
    sureButton.layer.borderColor = kThemeColor.CGColor;
    sureButton.titleLabel.font = kFont16;
    sureButton.layer.borderWidth = 1;
    sureButton.layer.cornerRadius = buttonH / 2;
    [sureView addSubview:sureButton];
    [[sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [sureView removeFromSuperview];
//        [self addSuccessfulView];
        [self Qukan_changeScoreWithScore:self.currentModel.code];
    }];
}


- (void)addSuccessfulViewWithImageName:(NSString *)imageName titleLabel:(NSString *)title describeLabel:(NSString *)describe addTag:(NSInteger)tag {
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 654 / 2, 456 / 2)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.userInteractionEnabled = YES;
    showView.layer.cornerRadius = 5;
    showView.center = self.view.center;
    [self.view addSubview:showView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, showView.width - 40 , 100)];
    iconImageView.image = [UIImage imageNamed:imageName];
    if (tag != 0) {
        if (tag == QukanImageNumber_DHCG) {
            [iconImageView sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_DHCG)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 iconImageView.image = [image imageByResizeToSize:CGSizeMake(750 / 2, 1334 / 2) contentMode:0];
            }];
        } else {
            [iconImageView sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_DHSB)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 iconImageView.image = [image imageByResizeToSize:CGSizeMake(290 / 2, 370 / 2) contentMode:0];
            }];
        }
    }
    iconImageView.tag = 100;
    iconImageView.contentMode = UIViewContentModeCenter;
    iconImageView.backgroundColor = [UIColor clearColor];
    [showView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iconImageView.bottom - 80, showView.width - 20, 25)];
    titleLabel.text = title;
    
    titleLabel.textColor = kCommonDarkGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:titleLabel];
    
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 9, showView.width - 20, 30)];
    describeLabel.text = describe;
    
    describeLabel.textColor = kCommonDarkGrayColor;
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.font = [UIFont systemFontOfSize:25];
    [showView addSubview:describeLabel];
    
    UIButton *wearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wearButton.frame = CGRectMake(showView.width / 2 - 267 / 2, describeLabel.bottom + 25, 267, 34);
    [wearButton setTitle:FormatString(@" 去做%@，获得更多%@和%@》",kStStatus.caseNum,kStStatus.duration,kStStatus.pageSize) forState:UIControlStateNormal];
    [wearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wearButton.backgroundColor = kThemeColor;
    wearButton.layer.cornerRadius = wearButton.height / 2;
    wearButton.titleLabel.font = kFont14;
    [wearButton setTitleColor:HEXColor(0x683e13) forState:UIControlStateNormal];
    wearButton.backgroundColor = HEXColor(0xfff1db);
    [showView addSubview:wearButton];
    @weakify(self);
    [[wearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        BOOL  isLogin = kUserManager.isLogin;
        if (self.RenWuClickBlock) {
            [self disappearTap:nil];
            self.RenWuClickBlock(isLogin);
        }
    }];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(kScreenWidth / 2 - 30, showView.bottom + 20, 60, 60);
    [cancleButton setImage:kImageNamed(@"Qukan_windowClosed") forState:UIControlStateNormal];
    [self.view addSubview:cancleButton];
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self disappearTap:nil];
    }];
    
    
//    CGRect viewRect = showView.frame;
//    viewRect.size.width += 20;
//    viewRect.size.height += 20;
//    viewRect.origin.x = (kScreenWidth - viewRect.size.width + 20) / 2;
//    viewRect.origin.y = (kScreenHeight - viewRect.size.height + 20) /2;
//    [UIView beginAnimations:@"FrameAni" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationRepeatCount:1];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    showView.frame = viewRect;
//    [UIView commitAnimations];
}


#pragma mark ===================== UITableViewDataSource ==================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanChangeTableViewCell class])];
    QukanScreenModel *model = self.datas[indexPath.row];
    [cell Qukan_SetScreenWith:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tableView removeFromSuperview];
    [_subView removeFromSuperview];
    QukanScreenModel *model = self.datas[indexPath.row];
    self.currentModel = model;
    [self addExcView];
}


#pragma mark ===================== Actions ============================

- (void)disappearTap:(UITapGestureRecognizer *)ges {
    [UIView animateWithDuration:0.25 animations:^{
        self.subView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//- (void)removeSubViews {
//    [self.view removeAllSubviews];
//    [self.view removeFromSuperview];
//}

- (void)allButtonCilck:(UIButton *)button {
    [self disappearTap:nil];
}

- (void)cancleButtonCilck:(UIButton *)button {
    [self disappearTap:nil];
}

#pragma mark ===================== NetWork ==================================


- (void)Qukan_changeScoreWithScore:(NSString *)code {
    @weakify(self)
    [[[kApiManager QukanGetInfoWithCode:code] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [SVProgressHUD showSuccessWithStatus:FormatString(@"%@成功",kStStatus.email)];
        
        //    @"恭喜获得";
        //    self.currentModel.name;
        [self addSuccessfulViewWithImageName:@"" titleLabel:@"恭喜获得" describeLabel:self.currentModel.name addTag:QukanImageNumber_DHCG];
        UIImageView *img = [self.view viewWithTag:100];
        img.contentMode = UIViewContentModeCenter;
        
        if (self.CodeClickBlock) {
            self.CodeClickBlock(YES);
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        if (error.code == -1) {
            [self addSuccessfulViewWithImageName:@"" titleLabel:@"哎~~~" describeLabel:FormatString(@"%@不足%@失败",kStStatus.duration,kStStatus.email) addTag:QukanImageNumber_DHSB];
            UIImageView *img = [self.view viewWithTag:100];
            img.mj_y = -50;
        }
//        [self removeSubViews];
    }];
}


-(void)dealloc {
    DEBUGLog(@"111");
}

@end
