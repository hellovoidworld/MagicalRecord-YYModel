//
//  HVWBoy+CoreDataProperties.h
//  HVWMagicalRecord+YYModel
//
//  Created by SimonHuang on 16/7/1.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HVWBoy.h"

NS_ASSUME_NONNULL_BEGIN

@interface HVWBoy (CoreDataProperties)

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nick;
@property (nonatomic) int64_t pid;
@property (nullable, nonatomic, retain) NSSet<HVWGirl *> *girlfriends;

@end

@interface HVWBoy (CoreDataGeneratedAccessors)

- (void)addGirlfriendsObject:(HVWGirl *)value;
- (void)removeGirlfriendsObject:(HVWGirl *)value;
- (void)addGirlfriends:(NSSet<HVWGirl *> *)values;
- (void)removeGirlfriends:(NSSet<HVWGirl *> *)values;

@end

NS_ASSUME_NONNULL_END
