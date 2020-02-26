//
//  QukanAirPlayQualityListView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/6.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayQualityListView.h"
#import "QukanAirPlayManager.h"
#import "SDAutoLayout.h"

@interface QualityCell : UITableViewCell
@property (nonatomic,strong) UILabel *label;
@end
@implementation QualityCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [UILabel new];
        _label.font = kFont15;
        _label.textColor = kCommonBlackColor;
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        _label.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        
        
    }
    return self;
    
}


@end

@interface QukanAirPlayQualityListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*dataSourceArr;
@end
@implementation QukanAirPlayQualityListView

+ (void)show{
    QukanAirPlayQualityListView *container = [[QukanAirPlayQualityListView alloc] init];
   
    CGFloat height = 50 * container.dataSourceArr.count + 45 + 50 + kSafeAreaBottomHeight;
 
    [self showWithContainer:container containerHeight:height];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topView = [self setupTopView];
        [self addSubview:topView];
        topView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(45);
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:closeBtn];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:HEXColor(0x999990) forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeBtn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, kSafeAreaBottomHeight).rightSpaceToView(self, 0).heightIs(50);
        UIView *sep1 = [[UIView alloc] init];
        [closeBtn addSubview:sep1];
        sep1.backgroundColor = kTableViewCommonBackgroudColor;
        sep1.sd_layout.leftSpaceToView(closeBtn, 0).topSpaceToView(closeBtn, 0).rightSpaceToView(closeBtn, 0).heightIs(1);
        @weakify(self);
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self dismiss];
        }];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(topView, 0).rightSpaceToView(self, 0).bottomSpaceToView(closeBtn, 0);
        [_tableView registerClass:QualityCell.class forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _dataSourceArr = QukanAirPlayManager.sharedManager.currentSubset.playInfo;
        
        [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self dismiss];
            
        }];
        [[QukanAirPlayManager.sharedManager.disConnectSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self dismiss];
        }];
    }
    return self;
}

- (UIView *)setupTopView{
    UIView *view = [[UIView alloc] init];
    UILabel *label = [UILabel new];
    label.font = kFont12;
    label.textColor = HEXColor(0x999990);
    label.text = @"选择清晰度";
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(view, 15).topSpaceToView(view, 0).bottomSpaceToView(view, 0).rightSpaceToView(view, 15);
    UIView *separator = [[UIView alloc] init];
    [view addSubview:separator];
    separator.sd_layout.leftSpaceToView(view, 0).bottomSpaceToView(view, 0).rightSpaceToView(view, 0).heightIs(1);
    separator.backgroundColor = kTableViewCommonBackgroudColor;
    
    
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark ===============tableview delegate============
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QualityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.label.text = @"高清";
//    playInfoRes *playInfo = _dataSourceArr[indexPath.row];
//    cell.label.text = playInfo.videoFormatName;
////    if (playInfo.isSelected) {
////        cell.label.textColor = [UIColor colorWithHexString:@"3476EF"];
////    }else{
////        cell.label.textColor = kCommonBlackColor;
////    }
//
//    if (playInfo == QukanAirPlayManager.sharedManager.selectedPlayInfo) {
//        cell.label.textColor = [UIColor colorWithHexString:@"3476EF"];
//        cell.label.font = [UIFont systemFontOfSize:18];
//    }else{
//        cell.label.textColor = kCommonBlackColor;
//        cell.label.font = [UIFont systemFontOfSize:15];
//    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    playInfoRes *playInfo = _dataSourceArr[indexPath.row];
//    [QukanAirPlayManager.sharedManager playWithPlayInfo:playInfo withStartPosition:QukanAirPlayManager.sharedManager.currentPlayTime];
//    QukanAirPlayManager.sharedManager.player.item.startPosition = QukanAirPlayManager.sharedManager.currentPlayTime;
    NSLog(@"%ld",QukanAirPlayManager.sharedManager.currentPlayTime);
    [self dismiss];
    [self.tableView reloadData];
    
    
}
@end
