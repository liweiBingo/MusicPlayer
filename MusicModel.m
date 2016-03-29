//
//  MusicModel.m
//  MusicPlayer
//
//  Created by dllo on 16/1/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

- (instancetype)initWith:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}

+ (instancetype)musicModelWithDic:(NSDictionary *)dict{
    
    return [[MusicModel alloc]initWith:dict];
}

@end
