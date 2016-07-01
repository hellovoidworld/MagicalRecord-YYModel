//
//  NSManagedObject+Common.h
//  HVWYYModelSupportCoreDataDemo
//
//  Created by SimonHuang on 16/6/28.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Common)

+ (NSArray *)getAllObjects:(NSManagedObjectContext *)context;
+ (void)deleteAllObjects:(NSManagedObjectContext *)context;

+ (instancetype)getObjectWithPrimaryKeyPredicates:(NSArray *)predicates context:(NSManagedObjectContext *)context;
+ (void)deleteObjectWithPrimaryKeyPredicates:(NSArray *)predicates context:(NSManagedObject *)context;

+ (instancetype)insertOrReplaceWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
+ (NSArray *)insertWithArray:(NSArray *)array context:(NSManagedObjectContext *)context;

// 原NSManagedObject需要实现的方法
+ (NSArray *)primaryKeys;
+ (NSDictionary *)coreDataModelContainerPropertyGenericClass;

@end
