//
//  QukanFilterMatchViewController.m
//  Qukan
//
//  Created by jku on 2019/8/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanFilterMatchViewController.h"
#import "QukanScreenTableModel.h"
#import "QukanNullDataView.h"
#import "QukanBMChineseSort.h"

@interface QukanFilterMatchView : UIView

@property(nonatomic, strong) UILabel *matchNameLab;
@property(nonatomic, strong) UIImageView *selectedImageView;
//@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) QukanScreenTableModel *model;

@property(nonatomic, copy) void(^modelStateChangeBlock)(QukanScreenTableModel *model);


@end

@implementation QukanFilterMatchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kCommentBackgroudColor;
        self.layer.cornerRadius = 2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBlock)];
        [self addGestureRecognizer:tap];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
        _matchNameLab = lab;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = kCommonBlackColor;
        lab.font = [UIFont systemFontOfSize:12];
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textColor = HEXColor(0x666666);
        [self addSubview:lab];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectedImageView = imgView;
        imgView.image = [kImageNamed(@"Qukan_match_selcted") imageWithColor:kThemeColor];
        imgView.hidden = YES;
        //        imgView.backgroundColor = kRandomColor;
        [self addSubview:imgView];
    }
    return self;
}

- (void)selectBlock {
    self.model.isSelected = !self.model.isSelected;
    _selectedImageView.hidden = !self.model.isSelected;
    
    if (self.modelStateChangeBlock) {
        self.modelStateChangeBlock(self.model);
    }
    
    [self setNeedsLayout];
}

- (void)setModel:(QukanScreenTableModel *)model {
    _model = model;
    _selectedImageView.hidden = !model.isSelected;
    self.matchNameLab.text = [NSString stringWithFormat:@"%@[%ld]", model.gbShort, model.matchCount];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    _containerView.frame = self.bounds;
    CGFloat labWidth = [self.matchNameLab.text sizeForFont:self.matchNameLab.font size:CGSizeMake(300, 26) mode:NSLineBreakByCharWrapping].width;
    
    if (self.model.isSelected) {
        CGFloat width = self.width-labWidth;
        self.selectedImageView.frame = CGRectMake(width/2-6.5, self.height/2-6.5, 13, 13);
        self.matchNameLab.frame = CGRectMake(self.selectedImageView.right+5, 0, labWidth, self.height);
    }else {
        self.matchNameLab.frame = self.bounds;
    }
}

@end

@interface QukanFilterMatchCell : UITableViewCell

@property(nonatomic, copy) NSArray *models;
@property(nonatomic, strong) NSMutableArray *matchViews;
@property(nonatomic, copy) void(^modelStateChangeBlock)(QukanScreenTableModel *model);


@end

@implementation QukanFilterMatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _matchViews = @[].mutableCopy;
    }
    return self;
}

- (void)setModels:(NSArray *)models {
    _models = models;
    
    for (UIView *view in self.matchViews) {
        [view removeFromSuperview];
    }
    [_matchViews removeAllObjects];
    
    for (int i = 0; i < models.count; i++) {
        QukanFilterMatchView *view = [[QukanFilterMatchView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:view];
        [_matchViews addObject:view];
        
        view.model = models[i];
    }
    
    for (int i = 0; i < _matchViews.count; i++) {
        QukanFilterMatchView *view = _matchViews[i];
        
        view.modelStateChangeBlock = self.modelStateChangeBlock;
        if (i < models.count) {
            view.model = models[i];
            view.hidden = NO;
        }else {
            view.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.matchViews.count; i++) {
        UIView *view = self.matchViews[i];
        CGFloat width = (kScreenWidth-40)/3;
        NSInteger section = i/3;
        NSInteger x = i % 3;
        view.frame = CGRectMake(10 + x*(width+10), 12+section*50, (kScreenWidth-40-20)/3, 26);
        [view setNeedsLayout];
    }
}

@end

@interface QukanFilterMatchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSArray *indexsArray;
@property(nonatomic, copy, readwrite) NSArray<NSArray*> *matchArray;

@property(nonatomic, strong, readwrite) NSMutableArray *Qukan_dataArray;


@end

@implementation QukanFilterMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Qukan_dataArray = @[].mutableCopy;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = HEXColor(0x666666);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[QukanFilterMatchCell class] forCellReuseIdentifier:NSStringFromClass([QukanFilterMatchCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self Qukan_requestData];
}

#pragma mark ===================== UITableViewDataSource, UITableViewDelegate =================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexsArray.count;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexsArray;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.indexArray[section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    lab.text = [NSString stringWithFormat:@"    %@", self.indexsArray[section]];
    lab.textColor = kTextGrayColor;
    lab.backgroundColor = kCommonWhiteColor;
    lab.font = [UIFont systemFontOfSize:14];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *matchs = self.matchArray[indexPath.section];
    NSInteger row = matchs.count%3 > 0 ? 1 : 0;
    return (matchs.count/3 + row) * 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanFilterMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanFilterMatchCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    cell.modelStateChangeBlock = ^(QukanScreenTableModel *model) {
        @strongify(self)
        [self itemSelectStateChange:model];
    };
    cell.models = self.matchArray[indexPath.section];
    return cell;
}


- (void)itemSelectStateChange:(QukanScreenTableModel *)model {
    NSInteger matchCount = 0;
    for (QukanScreenTableModel *model in self.Qukan_dataArray) {
        if (model.isSelected) {
            matchCount += model.matchCount;
        }
    }
    self.Qukan_selectedMatchCount = matchCount;
    if (self.Qukan_selectedBlock) {
        self.Qukan_selectedBlock();
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ===================== Private Methods =========================

- (void)Qukan_requestData {
    KShowHUD
    @weakify(self)
    NSDictionary *parameters = @{@"labelFlag":self.Qukan_labelFlag?:@"",
                                 @"sendType":[NSString stringWithFormat:@"%ld", self.Qukan_type],
                                 @"fixDays":[NSString stringWithFormat:@"%ld", self.Qukan_fixDays]};
    [QukanNetworkTool Qukan_POST:@"v3/bf-zq-match/find-league-label" parameters:parameters success:^(NSDictionary *response) {
        @strongify(self)
        KHideHUD
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *data = (NSArray *)response[@"data"];
                [self handleData:data];
            }
        }
    } failure:^(NSError *error) {
        @strongify(self)
        KHideHUD
        [self.tableView reloadData];
        if (self.Qukan_dataArray.count==0) {
            [QukanFailureView Qukan_showWithView:self.view centerY:-180.0  block:^{
                [self Qukan_netWorkClickRetry];
            }];
        }
    }];
}

- (void)handleData:(NSArray *)data {
    NSArray *leagueIdsArray = [NSArray array];
    
    if ([self.Qukan_leagueIds isKindOfClass:[NSNumber class]]) {
        leagueIdsArray = @[[NSString stringWithFormat:@"%ld",[self.Qukan_leagueIds integerValue]]];
        self.Qukan_leagueIds = [NSString stringWithFormat:@"%ld",[self.Qukan_leagueIds integerValue]];
    } else if (![self.Qukan_leagueIds containsString:@","] && ![self.Qukan_leagueIds isEqualToString:@""]) {//说明只有一个id的时候
        leagueIdsArray = @[[NSString stringWithFormat:@"%@",self.Qukan_leagueIds]];
    } else {
        leagueIdsArray = [self.Qukan_leagueIds componentsSeparatedByString:@","];
    }
    self.Qukan_allMatchCount = 0;
    self.Qukan_selectedMatchCount = 0;
    
    
    for (NSDictionary *d in data) {
        
        QukanScreenTableModel *model = [[QukanScreenTableModel alloc] initQukan_WithDict:d];
        
   
        
        for (NSString *leagueId in leagueIdsArray) {
            if (self.Qukan_all && (!self.Qukan_leagueIds || self.Qukan_leagueIds.length==0)) {
                model.isSelected = YES;
                self.Qukan_selectedMatchCount += model.matchCount;
            } else {
                if ([model.leagueId isEqualToString:leagueId]) {
                    model.isSelected = YES;
                }
            }
        }
        model.isSelected = ([self.Qukan_leagueIds length] == 0) || ([self.Qukan_leagueIds length] > 1 && [leagueIdsArray containsObject:model.leagueId] );

        [self.Qukan_dataArray addObject:model];
        if (model.gbShort.length > 0) {
            self.Qukan_allMatchCount += model.matchCount;
        }
    }
    
    if (self.Qukan_dataArray.count==0) {
        [QukanNullDataView Qukan_showWithView:self.view contentImageView:@"Qukan_Null_Data" content:@"暂无数据~"];
        return;
    } else {
        [QukanNullDataView Qukan_hideWithView:self.view];
    }
    
    [QukanBMChineseSort sortAndGroup:self.Qukan_dataArray key:@"gbShort" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        self.indexsArray = [NSArray arrayWithArray:sectionTitleArr];
        self.matchArray = [NSArray arrayWithArray:sortedObjArr];
        [self.tableView reloadData];
        [self Qukan_calculateTotalMatchCount];
    }];
    
    
}

- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self Qukan_requestData];
}

- (void)Qukan_allAndReverseSelected:(BOOL)isAllSelected {
    for (NSArray *array in self.matchArray) {
        for (QukanScreenTableModel *model in array) {
            if (isAllSelected) {
                model.isSelected = YES;
            } else {
                model.isSelected = !model.isSelected;
            }
        }
    }
    [self Qukan_calculateTotalMatchCount];
    [self.tableView reloadData];
}

- (void)Qukan_calculateTotalMatchCount {
    NSInteger matchCount = 0;
    for (NSArray *array in self.matchArray) {
        for (QukanScreenTableModel *model in array) {
            if (model.isSelected) {
                matchCount += model.matchCount;
            }
        }
    }
    self.Qukan_selectedMatchCount = matchCount;
    if (self.Qukan_selectedBlock) {
        self.Qukan_selectedBlock();
    }
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (UIView *)listView {
    return self.view;
}

@end
