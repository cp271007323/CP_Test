//
//  TopicUserHeaderListCell.h
//  Topic
//
//  Created by leo on 2019/9/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanUserHeaderListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_item;
@property (weak, nonatomic) IBOutlet UILabel *lab_item;
@property (weak, nonatomic) IBOutlet UILabel *lab_itemContent;


- (void)fullCellWithIndex:(NSInteger)index andDatas:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
