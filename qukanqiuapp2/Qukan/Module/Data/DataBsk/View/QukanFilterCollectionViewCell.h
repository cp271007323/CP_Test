//
//  CollectionViewCell.h
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import <UIKit/UIKit.h>

#define kCellIdentifier_CollectionView @"CollectionViewCell"

@interface QukanFilterCollectionViewCell : UICollectionViewCell

//@property (nonatomic, strong) SubCategoryModel *model;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;
@end