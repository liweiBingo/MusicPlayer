//
//  TableViewCell.h
//  MusicPlayer
//
//  Created by dllo on 16/1/24.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface TableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *imageViewPic;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *deqLabel;

@property (nonatomic, retain) MusicModel *model;



@end
