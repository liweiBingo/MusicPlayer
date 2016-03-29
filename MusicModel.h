//
//  MusicModel.h
//  MusicPlayer
//
//  Created by dllo on 16/1/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *blurPicUrl;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *artists_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lyric;

+ (instancetype)musicModelWithDic:(NSDictionary *)dict;



@end
