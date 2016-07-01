//
//  HVWGirl+CoreDataProperties.h
//  HVWMagicalRecord+YYModel
//
//  Created by SimonHuang on 16/7/1.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HVWGirl.h"

NS_ASSUME_NONNULL_BEGIN

@interface HVWGirl (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int64_t pid;
@property (nullable, nonatomic, retain) HVWBoy *boyfriend;

@end

NS_ASSUME_NONNULL_END
