//
//  HVWBoy.m
//  HVWMagicalRecord+YYModel
//
//  Created by SimonHuang on 16/7/1.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//

#import "HVWBoy.h"
#import "HVWGirl.h"

@implementation HVWBoy

// Insert code here to add functionality to your managed object subclass
// 自定义的“主键”，为了插入的时候不造成数据“冗余”，因为每次插入数据是CoreData自己生成真正的主键的
+ (NSArray *)primaryKeys {
    return @[@"pid"];
}

// 容器元素类，使用了NSManagedObject+Common，需要实现这个类似于YYModel中containerPropertyGenericClass的方法，用来指明容器属性中元素的类型
+ (NSDictionary *)coreDataModelContainerPropertyGenericClass {
    return @{@"girlfriends" : [HVWGirl class]};
}

// 黑名单，因为YYModel并不能自动进行转换，需要先屏蔽容器类属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"girlfriends"];
}


@end
