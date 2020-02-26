//
//  QukanAirPlayLandscapeQualityListView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/6.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayLandscapeQualityListView.h"
#import "QukanAirPlayManager.h"
#import "SDAutoLayout.h"

@interface LandScapeQualityCell : UITableViewCell
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,copy) void (^clickBlock)(void);
@end
@implementation LandScapeQualityCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
        _btn.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(120).heightIs(36);
        
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 3.0;
        _btn.layer.borderWidth = 1.0;
        _btn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:RGB(248, 69, 110) forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    return self;
}
- (void)handleBtn{
    if (_clickBlock) {
        _clickBlock();
    }
}

@end

@interface QukanAirPlayLandscapeQualityListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*dataSourceArr;
@end
@implementation QukanAirPlayLandscapeQualityListView
+ (void)showInView:(UIView *)superView{
    QukanAirPlayLandscapeQualityListView *view = [[QukanAirPlayLandscapeQualityListView alloc] init];
    [superView addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0.5];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.sd_layout.topSpaceToView(self, 0).bottomSpaceToView(self, 0).centerXEqualToView(self).widthIs(150);
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:LandScapeQualityCell.class forCellReuseIdentifier:@"cell"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self)
            [self removeFromSuperview];
            
        }];
        
        [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self removeFromSuperview];
        }];
//         _dataSourceArr = [[QukanAirPlayManager.sharedManager.currentSubset.playInfo reverseObjectEnumerator] allObjects];
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = kScreenHeight;
    CGFloat cellTotalHeight = 56.0 * _dataSourceArr.count;
    if (cellTotalHeight>height) {
        return 0.1;
    }
    return (height-cellTotalHeight)/2.0;

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
    return 56.0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandScapeQualityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    playInfoRes *model = _dataSourceArr[indexPath.row];
//    [cell.btn setTitle:model.videoFormatName forState:UIControlStateNormal];
//    if (model == QukanAirPlayManager.sharedManager.selectedPlayInfo) {
//       cell.btn.layer.borderColor = RGB(248, 69, 110).CGColor;
//        cell.btn.selected = YES;
//
//
//    }else{
//        cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn.selected = NO;
//    }
    
    
    
    @weakify(self)
    cell.clickBlock = ^{
        @strongify(self)
        [self cellClickWithIndex:indexPath.row];
    };
    
    return cell;
}
- (void)cellClickWithIndex:(NSInteger)index{
    
//    playInfoRes *playInfo = _dataSourceArr[index];
//    [QukanAirPlayManager.sharedManager playWithPlayInfo:playInfo withStartPosition:QukanAirPlayManager.sharedManager.currentPlayTime];
    
    [self.tableView reloadData];
    [self removeFromSuperview];
}

@end
