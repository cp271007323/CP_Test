//
//  QukanTeamSubBaseVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamSubBaseVC.h"

@interface QukanTeamSubBaseVC ()
@property(nonatomic,strong) id model;
@property(nonatomic,strong) NSString* currentSeason;
@end

@implementation QukanTeamSubBaseVC

- (instancetype)initWithModel:(id )model atSeason:(NSString*)season{
    if(self = [super init]){
        _model = model;
        _currentSeason = season;
    }
    return self;
}

- (instancetype)initWithModel:(id )model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)myModel{
    return _model;
}

- (NSString*)season{
    return  _currentSeason;
}


#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
