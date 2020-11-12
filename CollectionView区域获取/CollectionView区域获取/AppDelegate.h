//
//  AppDelegate.h
//  CollectionView区域获取
//
//  Created by mac02 on 2020/6/9.
//  Copyright © 2020 mac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

