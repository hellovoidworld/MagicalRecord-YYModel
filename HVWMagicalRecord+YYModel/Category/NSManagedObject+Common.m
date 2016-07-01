//
//  NSManagedObject+Common.m
//  HVWYYModelSupportCoreDataDemo
//
//  Created by SimonHuang on 16/6/28.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//

#import "NSManagedObject+Common.h"
#import <objc/message.h>
#import <objc/runtime.h>

#define ENTITY_NAME NSStringFromClass([self class])

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation NSManagedObject (Common)
#pragma clang diagnostric pop

+ (NSArray *)getAllObjects:(NSManagedObjectContext *)context {
    return [self MR_findAllWithPredicate:nil inContext:context];
}

+ (void)deleteAllObjects:(NSManagedObjectContext *)context {
    if (!context) {
        return;
    }
    
    NSArray *objects = [self getAllObjects:context];
    for (NSManagedObject *object in objects) {
        [object MR_deleteEntityInContext:context];
        [context MR_saveToPersistentStoreAndWait];
    }
}

+ (instancetype)getObjectWithPrimaryKeyPredicates:(NSArray *)predicates context:(NSManagedObjectContext *)context {
    if (!predicates || !context) {
        return nil;
    }
    
    NSMutableString *preStr = [NSMutableString string];
    NSArray *primaryKeys = [self primaryKeys];
    if (predicates.count != primaryKeys.count) {
        return nil;
    }
    
    for (int i=0; i<primaryKeys.count; i++) {
        NSString *predicateKey = primaryKeys[i];
        NSObject *value = predicates[i];
        
        if ([value isKindOfClass:[NSString class]]) {
            [preStr appendString:[NSString stringWithFormat:@" (%@ = \"%@\") ", predicateKey, value]];
            
        } else {
            [preStr appendString:[NSString stringWithFormat:@" (%@ = %@) ", predicateKey, value]];
        }
        
        if (i != primaryKeys.count - 1) {
            [preStr appendString:@" AND "];
        }
    }
    
    return [self MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:preStr] inContext:context];
}

+ (void)deleteObjectWithPrimaryKeyPredicates:(NSArray *)predicates context:(NSManagedObjectContext *)context {
    NSManagedObject *object = [self getObjectWithPrimaryKeyPredicates:predicates context:context];
    [object MR_deleteEntityInContext:context];
    [context MR_saveToPersistentStoreAndWait];
}

+ (instancetype)insertOrReplaceWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context {
    if (!dict || !context) {
        return nil;
    }
    
    NSMutableArray *predicates = [NSMutableArray array];
    for (NSString *primaryKey in [self primaryKeys]) {
        [predicates addObject:[dict valueForKey:primaryKey]];
    }
    
    NSManagedObject *object = [self getObjectWithPrimaryKeyPredicates:predicates context:context];
    if (!object) {
        object = [self MR_createEntityInContext:context];
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
    [object yy_modelSetWithDictionary:dict];
    [object handleRelationsWithDictionary:dict context:context];
    
    [context MR_saveToPersistentStoreAndWait];
    
    return object;
}

+ (NSArray *)insertWithArray:(NSArray *)array context:(NSManagedObjectContext *)context {
    if (!array || !context) {
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        NSManagedObject *object = [self insertOrReplaceWithDictionary:dict context:context];
        [result addObject:object];
    }
    
    return result;
}

// 处理容器类属性，传入的dictionary中的NSArray，NSDictionary
- (void)handleRelationsWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context {
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSObject *obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            objc_property_t property = class_getProperty([self class], key.UTF8String);
            
            if ([[self class] respondsToSelector:@selector(coreDataModelContainerPropertyGenericClass)]) {
                NSDictionary *classDict = [[self class] coreDataModelContainerPropertyGenericClass];
                
                NSString *key = [NSString stringWithUTF8String:property_getName(property)];
                Class c = [classDict objectForKey:key];
                NSArray *savedRelationObjects = [c insertWithArray:(NSArray *)obj context:context];
                
                [self setValue:[NSSet setWithArray:savedRelationObjects] forKey:key];
                [context MR_saveToPersistentStoreAndWait];
            }
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            objc_property_t property = class_getProperty([self class], key.UTF8String);
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            
            unsigned int count = 0;
            objc_property_attribute_t *attrs = property_copyAttributeList(property, &count);
            for (int i=0; i<count; i++) {
                objc_property_attribute_t attr = attrs[i];
                
                NSString *attrName = [NSString stringWithUTF8String:attr.name];
                if ([@"T" isEqualToString:attrName]) { // 属性类名key是"T"
                    NSString *className = [NSString stringWithUTF8String:attr.value]; // 这是带有"@"和双引号的类名字符串，例如@"User"
                    className = [className stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    Class c = NSClassFromString(className);
                    
                    NSManagedObject *savedRelationObject = [c insertOrReplaceWithDictionary:(NSDictionary *)obj context:context];
                    
                    [self setValue:savedRelationObject forKey:key];
                    [context MR_saveToPersistentStoreAndWait];
                    
                    break;
                }
            }
        }
        
    }];
}

@end
