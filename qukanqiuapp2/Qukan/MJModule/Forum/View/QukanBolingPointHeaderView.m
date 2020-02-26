//
//  QukanBolingPointHeaderView.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBolingPointHeaderView.h"
#import "QukanBolingPointListModel.h"

@interface QukanBolingPointHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *lab_content;

@end

@implementation QukanBolingPointHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)fullData:(QukanBolingPointListModel *)model {
    
    self.lab_content.text = model.content;
}

@end
