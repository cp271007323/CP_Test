//\
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanWithRedDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubTitle;

-(void)setlabTitle:(NSString *)labTitle labSubTitle:(NSString *)labSubTitle;
@end

NS_ASSUME_NONNULL_END
