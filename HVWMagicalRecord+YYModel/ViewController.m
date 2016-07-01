//
//  ViewController.m
//  HVWMagicalRecord+YYModel
//
//  Created by SimonHuang on 16/7/1.
//  Copyright © 2016年 hellovoidworld. All rights reserved.
//

#import "ViewController.h"
#import "HVWBoy.h"
#import "HVWGirl.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "NSManagedObject+Common.h"

@interface ViewController ()

- (IBAction)readJsonAndSave:(UIButton *)sender;
- (IBAction)readAllBoysFromDB:(UIButton *)sender;
- (IBAction)cleanDBData:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)readJsonAndSave:(UIButton *)sender {
    NSString *json = @"{\"data\":[{\"girlfriends\":[{\"pid\":200,\"name\":\"Judy\"},{\"pid\":201,\"name\":\"Summer\"},{\"pid\":202,\"name\":\"Sufia\"}],\"pid\":100,\"name\":\"John\",\"nick\":\"Programer\",\"age\":25},{\"girlfriends\":[{\"pid\":203,\"name\":\"Aoi\"}],\"pid\":101,\"name\":\"Peter\",\"nick\":\"PM\",\"age\":30}]}";
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    
    // 在使用NSManagedObject+Common之前，需要手动先创建实例，再进行字典转模型，且不能处理容器属性
    //    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    //
    //    for (NSDictionary *dic in [dataDic objectForKey:@"data"]) {
    //        HVWBoy *boy = [HVWBoy MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"pid = %d", [[dic objectForKey:@"pid"] intValue]]];
    //        if (!boy) {
    //            boy = [HVWBoy MR_createEntityInContext:context];
    //        }
    //
    //        [boy yy_modelSetWithDictionary:dic];
    //        [context MR_saveToPersistentStoreAndWait];
    //    }
    
    // 使用NSManagedObject+Common之后
    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    
    // 只需要调用一个方法，就可以自动从json转换到Core模型对象并存储
    [HVWBoy insertWithArray:[dataDic objectForKey:@"data"] context:context];
    
    NSLog(@"Save data into DB succeeded!");
}

- (IBAction)readAllBoysFromDB:(UIButton *)sender {
    //    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *boys = [HVWBoy MR_findAll];
    
    if (!boys.count) {
        NSLog(@"No data in DB!");
        return;
    }
    
    for (HVWBoy *boy in boys) {
        NSLog(@"boy --> pid:%lld, name:%@, age:%d, nick:%@", boy.pid, boy.name, boy.age, boy.nick);
        
        for (HVWGirl *girl in boy.girlfriends) {
            NSLog(@"%@'s girlfriend --> pid:%lld, name:%@", boy.name, girl.pid, girl.name);
        }
    }
}

- (IBAction)cleanDBData:(UIButton *)sender {
    NSArray *boys = [HVWBoy MR_findAll];
    for (HVWBoy *boy in boys) {
        [boy MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    NSLog(@"Clean DB succeeded");
}

@end
