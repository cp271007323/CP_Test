//
//  QukanNewsSearchDetailFiledView.m
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewsSearchDetailFiledView.h"
@interface QukanNewsSearchDetailFiledView()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *fieldBackView;
@property (nonatomic, strong)UIImageView *searchIcon;
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, strong)UIButton *cancelButton;
@end
@implementation QukanNewsSearchDetailFiledView

- (instancetype)initWithFrame:(CGRect)frame cancelBlock:(void (^)(void))cancelBlock fieldBlock:(void (^)(NSString *field))fieldBlock clearBlock:(nonnull void (^)(void))clearBlock clickFieldBlock:(nonnull void (^)(void))clickFieldBlock{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.fieldBackView];
        [self.fieldBackView addSubview:self.searchIcon];
        [self.fieldBackView addSubview:self.searchField];
        [self addSubview:self.cancelButton];
        [self.fieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(kStatusBarHeight);
            make.right.offset(-60);
            make.bottom.offset(-8);
        }];
        [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.width.height.offset(24);
            make.centerY.offset(0);
        }];
        [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchIcon.mas_right).offset(8);
            make.right.offset(-8);
            make.top.bottom.offset(0);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.left.mas_equalTo(self.fieldBackView.mas_right).offset(0);
            make.height.offset(36);
            make.centerY.mas_equalTo(self.fieldBackView.mas_centerY).offset(0);
        }];
        
        [[[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            cancelBlock();
        }];
        self.fieldBlock = fieldBlock;
        self.clearBlock = clearBlock;
        self.clickFieldBlock = clickFieldBlock;
        
    }
    return self;
}
- (void)tapClearButton:(UIButton *)btn {
    [self endEditing:1];
    self.searchField.text = @"";
    if (self.clearBlock) {
        self.clearBlock();
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
    if (self.clickFieldBlock) {
        self.clickFieldBlock();
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:1];
        if (self.fieldBlock) {
            self.fieldBlock(textField.text);
        }
    return YES;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.searchField.placeholder = placeholder;
}
- (UIView *)fieldBackView {
    if (!_fieldBackView) {
        _fieldBackView = [UIView new];
        _fieldBackView.backgroundColor = HEXColor(0xf4f4f4);
        _fieldBackView.layer.cornerRadius = 4;
        _fieldBackView.layer.masksToBounds = 1;
    }
    return _fieldBackView;
}
- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [UIImageView new];
        _searchIcon.image = kImageNamed(@"Qukan_News_search");
    }
    return _searchIcon;
}
- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [UITextField new];
        _searchField.textColor = kTextGrayColor;
        _searchField.font = kFont15;
        _searchField.delegate = self;
        _searchField.tintColor = HEXColor(0x666666);
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIButton *clearButton = [_searchField valueForKey:@"_clearButton"];
        [clearButton addTarget:self action:@selector(tapClearButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDown];
    }
    return _searchField;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kFont15;
        [_cancelButton setTitleColor:kCommonTextColor forState:UIControlStateNormal];
    }
    return _cancelButton;
}
@end
