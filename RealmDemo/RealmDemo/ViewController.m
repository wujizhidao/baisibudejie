//
//  ViewController.m
//  RealmDemo
//
//  Created by yeyeye on 2017/5/22.
//  Copyright © 2017年 yeyeye. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>

@interface dog : RLMObject

@property NSString *name;
@property NSInteger age;
@property NSData *picture;
@end
@implementation dog
@end
RLM_ARRAY_TYPE(dog)
@interface person : RLMObject
@property RLMArray <dog *><dog>* dog;
@property NSString *name;
@end
@implementation person
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dog *mydog = [[dog alloc]init];
    mydog.name = @"xiaohuang";
    mydog.age = 1;
    mydog.picture = nil;
    // 检索 Realm 数据库，找到小于 2 岁 的所有狗狗
    RLMResults<dog *> *puppies = [dog objectsWhere:@"age < 2"];
    //    puppies.count; // => 0 因为目前还没有任何狗狗被添加到了 Realm 数据库中
    //写进数据库
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:mydog];
    }];
    // 检索结果会实时更新
    [puppies count];
    
    // 可以在任何一个线程中执行检索操作
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            dog *theDog = [[dog objectsWhere:@"age == 1"] firstObject];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            theDog.age = 3;
            [realm commitWriteTransaction];
        }
    });
    
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
