//
//  HTCollectionViewCell.h
//  CollectionView区域获取
//
//  Created by liupeng on 2020/6/10.
//  Copyright © 2020 mac02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface HTCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HTItemModel *model;

- (void)changeSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
