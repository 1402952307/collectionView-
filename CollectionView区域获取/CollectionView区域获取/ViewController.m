//
//  ViewController.m
//  CollectionView区域获取
//
//  Created by mac02 on 2020/6/9.
//  Copyright © 2020 mac02. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "HTItemModel.h"
#import "HTCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    int collectionView_W;
    int collectionView_H;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *eraserBtn;
@property (nonatomic, strong) UIButton *repaintBtn;

@property (nonatomic, strong) NSArray<NSArray<HTItemModel *> *> *dataSource;

@end

@implementation ViewController

#define kSelfWidth [UIScreen mainScreen].bounds.size.width
#define kSelfHeight [UIScreen mainScreen].bounds.size.height


- (void)viewDidLoad {
    [super viewDidLoad];
    

    collectionView_W = kSelfWidth;
    collectionView_H = kSelfWidth / 16 * 9;
    
    [self.view addSubview:self.collectionView];
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.offset(0);
//        make.top.offset(150);
//        make.height.offset(kSelfWidth / 16 * 9);
//    }];
    
    
    [self.view addSubview:self.buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(CGRectGetMaxY(self.collectionView.frame) + 1);
        make.leading.trailing.offset(0);
        make.height.offset(44);
    }];
    
    [_buttonView addSubview:self.repaintBtn];
    [_buttonView addSubview:self.eraserBtn];
    
    //功能按钮
    NSArray *masonryViewArray = @[self.repaintBtn,self.eraserBtn];
    // 实现masonry水平固定间隔方法
    [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:64 leadSpacing:10 tailSpacing:kSelfWidth - 148];
    // 设置array的垂直方向的约束
    [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(64, 40));
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.itemArray = self.collectionView.visibleCells;
//        NSLog(@"UICollectionViewCell总个数 = %ld",self.itemArray.count);
//
//        for (int i = 0; i < self.itemArray.count; i++) {
//            UICollectionViewCell *cell = self.itemArray[i];
//            CGRect rect = [cell convertRect: cell.bounds toView:self.collectionView];
//            if (cell.tag == 0) {
//                NSLog(@"rect = %@---------%ld",NSStringFromCGRect(rect),cell.tag);
//            }
//        }
//    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HTCollectionViewCell alloc] init];
        
    }
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {

    CGPoint point = [recognizer locationInView:_collectionView];
    for (int i = 0; i < self.collectionView.visibleCells.count - 1; i++) {
        
        HTCollectionViewCell *cell = self.collectionView.visibleCells[i];
        CGRect rect = [cell convertRect: cell.bounds toView:self.collectionView];
        if (point.x > rect.origin.x && point.x < rect.origin.x + 18) {
            if (point.y > rect.origin.y && point.y < rect.origin.y + 11) {
                [cell changeSelected:YES];
            }
        }
    }
    
    
    // 松开手指时判断滑动趋势让其计算滑动位置
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        for (NSArray<HTItemModel *> *modelList in self.dataSource) {
            
            int lastSelectIndex = -1;
            
            // 数据倒序 查询
            for (int i = (int)(modelList.count - 1); i >= 0; i--) {
                
                if (i > modelList.count -1) {
                    lastSelectIndex = -1;
                    break;
                }
                
                if (modelList[i].selected) {
                    lastSelectIndex = i;
                    break;
                }
            }
            
            if (lastSelectIndex >= 0) {
                
                BOOL startSelect = NO;
                for (int i = 0; i < modelList.count - 1; i++) {
                    
                    HTItemModel *model = modelList[i];
                    if (model.selected == YES) {
                        startSelect = YES;
                    }
                    
                    if (startSelect && i <= lastSelectIndex) {
                        model.selected = YES;
                    }
                }
            }
        }
        [self.collectionView reloadData];
    }
}

// 懒加载
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        flow.minimumInteritemSpacing = 0.5;
        flow.minimumLineSpacing = 0.5;
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        int item_W = collectionView_W / self.dataSource.firstObject.count;
        int row_H = (int)(collectionView_H - self.dataSource.count) / self.dataSource.count;
        flow.itemSize = CGSizeMake(item_W, row_H);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 150, kSelfWidth, kSelfWidth / 16 * 9) collectionViewLayout:flow];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HTCollectionViewCell class] forCellWithReuseIdentifier:@"HTCollectionViewCell"];
        // 拖拽
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_collectionView addGestureRecognizer:pan];

    }
    return _collectionView;
}

// 数据初始化
- (NSArray *)dataSource {
    if (!_dataSource) {
        
        NSMutableArray *dataSource = [NSMutableArray array];
        for (int i = 0; i < 18; i++) {
            
            NSMutableArray *models = [NSMutableArray array];
            for (int i = 0; i < 22; i++) {
                [models addObject:[[HTItemModel alloc] init]];
            }
            [dataSource addObject:[models copy]];
        }
        _dataSource = [dataSource copy];
    }
    return _dataSource;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = [UIColor lightGrayColor];
    }
    return _buttonView;
}


- (UIButton *)repaintBtn {
    if (!_repaintBtn) {
        _repaintBtn = [[UIButton alloc] init];
        [_repaintBtn setTitle:@"重绘" forState:UIControlStateNormal];
        _repaintBtn.backgroundColor = [UIColor orangeColor];
    }
    return _repaintBtn;
}

- (UIButton *)eraserBtn {
    if (!_eraserBtn) {
        _eraserBtn = [[UIButton alloc] init];
        [_eraserBtn setTitle:@"橡皮擦" forState:UIControlStateNormal];
        _eraserBtn.backgroundColor = [UIColor orangeColor];
    }
    return _eraserBtn;
}

@end
