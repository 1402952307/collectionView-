//
//  HTCollectionViewCell.m
//  CollectionView区域获取
//
//  Created by liupeng on 2020/6/10.
//  Copyright © 2020 mac02. All rights reserved.
//

#import "HTCollectionViewCell.h"
#import "HTItemModel.h"

@implementation HTCollectionViewCell

- (void)changeSelected:(BOOL)selected {
    self.model.selected = selected;
    [self changeBackground];
}

- (void)changeBackground {
    self.contentView.backgroundColor = self.model.selected ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

- (void)setModel:(HTItemModel *)model {
    _model = model;
    [self changeBackground];
}

@end
