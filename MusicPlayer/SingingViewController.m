//
//  SingingViewController.m
//  MusicPlayer
//
//  Created by dllo on 16/1/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "SingingViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"

@interface SingingViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>

@property (nonatomic, retain) NSTimer *timer;






@end

@implementation SingingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    右滑返回
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    同时显示left 和 back item
//    ViewController *root = [[ViewController alloc]init];
//    
//    root.deleGate = self;
    
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    

    self.view.backgroundColor = [UIColor blackColor];
    self.lrcAll = [[NSMutableArray alloc]init];
    self.lrcTime = [[NSMutableArray alloc]init];
   
    
    self.playOrPause = NO;
    self.lycYesOrNo = NO;
    
    [self creatPage];
    
    [self creatTableView];
    
    [self creatBtn];
    
    [self volume];
    
    [self creatSegment];
    
}

//铺页面
- (void)creatPage{
    MusicModel *model = [[MusicModel alloc]init];
    model = [self takeModel];
    
//    调用背景
    [self creatScrollViewBack];
    [self creatScrollLeftView];
    [self creatScrollRightView:model.blurPicUrl];
    
  
    
//    调用光盘方法
    self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self creatPicture:model.picUrl];
//调用播放器
//    [self musicplay:model.mp3Url];
 // 歌名 navgationBar 标题
    self.navigationItem.title = model.name;
//   调用歌词
    [self creatLrc:model.lyric];
    
}
//把传过来的model解析

- (MusicModel *)takeModel{
    
    MusicModel *model = [[MusicModel alloc]init];
    
    model = [self.listArray objectAtIndex:self.i];
    
    return model;
}
//歌词
- (void)creatLrc:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [array count]; i++) {
        
        NSString *lineString = [array objectAtIndex:i];
        
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        
        if ([lineArray[0] length] > 8) {
            
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                
                for (int i = 0; i < lineArray.count - 1; i++) {
                    
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    
                    //分割区间求歌词时间
                    NSString *timeString = [[lineArray objectAtIndex:i] substringWithRange:NSMakeRange(1, 5)];
                   
                 
                    
                    
                    //把时间 和 歌词 加入
                    [self.lrcTime addObject:timeString];
                    [self.lrcAll addObject:lrcString];
                    

                    
                }
            }
        }
    }
 
}

- (void)time{
int hh= 0,mm = 0,ss = 0;



NSString *mmStr= nil;

NSString *ssStr= nil;

hh = self.player.currentTime / 360;

mm = (self.player.currentTime -hh * 360)/ 60;

ss = (int)self.player.currentTime % 60;



if (mm< 10){
    
    mmStr= [NSString stringWithFormat:@"0%d",mm];
    
} else {
    
    mmStr= [NSString stringWithFormat:@"%d",mm];
    
}

if (ss< 10){
    
    ssStr= [NSString stringWithFormat:@"0%d",ss];
    
} else {
    
    ssStr= [NSString stringWithFormat:@"%d",ss];
    
}
    NSString *currTime0 = [mmStr stringByAppendingString:@":"];
    self.currTime = [currTime0 stringByAppendingString:ssStr];
    
 
    if (self.lrcTime != nil&&self.lrcAll != nil) {
        for (int i = 0; i < self.lrcTime.count; i++) {
         
            if ([self.lrcTime[i] isEqualToString:self.currTime]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                
              
            }
            
            
        }
        
    }

    
    

    
    
    

}
//音乐播放器

- (void)musicplay:(NSString *)str{

    
//    播放器运行
    NSString *urlStr = [NSString stringWithFormat:@"%@",str];
    
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //将数据保存到本地指定位置
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
//    [audioData writeToFile:filePath atomically:YES];
//    NSLog(@"%@",filePath);
//    //播放本地音乐
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    self.player = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
    
    
    
    
    [self.player prepareToPlay];
    
    self.player.delegate = self;
    
    self.player.volume = 8;
    
    [self.player play];

}

//按钮
- (void)creatBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(3, 590, [UIScreen mainScreen].bounds.size.width - 6, 130)];
    view.alpha = 0.6;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [[UIColor blackColor]CGColor];
    view.layer.borderWidth = 2;
    view.layer.cornerRadius = 24;
//    按钮

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.frame = CGRectMake(10, 5, 100, 100);
    
    
   
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.frame = CGRectMake(150, 20, 50, 50);
    
    
  
    
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btn3.frame = CGRectMake(240, 20, 50, 50);
    

    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn4.frame = CGRectMake(320, 20, 50, 50);
    
//    添加背景图片
    [btn1 setBackgroundImage:[UIImage imageNamed:@"iconfont-yutoubaoicon"] forState:UIControlStateNormal];
    
    [btn2 setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqishangyiqu"] forState:UIControlStateNormal];
    
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
    
    [btn4 setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqixiayiqu"] forState:UIControlStateNormal];
    
//    给按钮添加事件
//    播放
    [self.btn3 addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(too) forControlEvents:UIControlEventTouchUpInside];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(120, 90, 280, 20)];
    
    self.slider.thumbTintColor = [UIColor blackColor];
    
    self.slider.maximumValue = self.player.duration;
    self.slider.minimumValue = 0;
   
    
    [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    
    


    
     [view addSubview:btn1];
     [view addSubview:btn2];
     [view addSubview:self.btn3];
     [view addSubview:btn4];
     [view addSubview:self.slider];
    
//     UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
     [self.view addSubview:view];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerTake) userInfo:nil repeats:YES];
    [self.timer fire];

}
- (void)timerTake{
    
   self.slider.value = self.player.currentTime;

    [self time];
}
- (void)go{
    if (self.playOrPause == YES) {
           [self.player play];
        self.playOrPause = NO;
        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        
    }else{
        [self.player pause];
        self.playOrPause = YES;
           [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqibofang"] forState:UIControlStateNormal];
    }
    
 
    

    
    
}
- (void)next{
    NSLog(@"下一首");
    self.i = self.i + 1;
    MusicModel *model = [[MusicModel alloc]init];
    model = [self takeModel];
    self.lrcAll = [[NSMutableArray alloc]init];
    self.lrcTime = [[NSMutableArray alloc]init];
    self.navigationItem.title = model.name;
    [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    [self musicplay:model.mp3Url];
    [self creatLrc:model.lyric];
    [self.tableView reloadData];
}
- (void)back{
    self.i = self.i - 1;
    MusicModel *model = [[MusicModel alloc]init];
    model = [self takeModel];
    self.lrcAll = [[NSMutableArray alloc]init];
    self.lrcTime = [[NSMutableArray alloc]init];
    self.navigationItem.title = model.name;
    [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    [self musicplay:model.mp3Url];
    [self creatLrc:model.lyric];
    [self.tableView reloadData];
}
//需要修改
- (void)too{
    
    NSLog(@"再听一遍");
    
    [self back];
    [self next];
    
}
//slider触发事件
- (void)slider:(UISlider *)slider{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    self.player.currentTime = slider.value;
    NSTimer *timerOnce = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerOnce) userInfo:nil repeats:NO];
    [timerOnce fire];
}
- (void)timerOnce{
    [self.timer setFireDate:[NSDate distantPast]];
    
}
//铺tableView 在ScrollView 上面
- (void)creatTableView{

    
    self.tableView = [[UITableView alloc]
    initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width + 30, 290, 350, 200)];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    

    
    [self.scrollView addSubview:self.tableView];
    
  
}
//协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return self.lrcAll.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
  

        cell.textLabel.text = [self.lrcAll objectAtIndex:indexPath.row];
        
//        NSLog(@"%@",[self.lrcAll objectAtIndex:indexPath.row]);
    


    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
//    [cell.textLabel setNumberOfLines:0];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    cell.textLabel.textColor = [UIColor cyanColor];
 
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置文字高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:1];
    
    
    // 设置被选取的cell
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}
//光盘 music 里面调用
- (void)creatPicture:(NSString *)str{
   
    
    self.picImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width + 207, 120);
    
    self.picImageView.layer.cornerRadius = 100;
    
    
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:str]];

    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    CGFloat point = M_PI_4;
    
    
    ani.values = @[@(9 * point),@(8 * point),@(7 * point),@(6 * point),@(5 * point),@(4 * point),@(3 * point),@(2 * point),@(point)];
    
    ani.repeatCount = MAXFLOAT;
    
    ani.duration = 5;
    
    
    
    [self.picImageView.layer addAnimation:ani forKey:nil];
    

     [self.picImageView.layer setMasksToBounds:YES];
    
     [self.scrollView addSubview:self.picImageView];
    
}
//Scroll music 里面调用
- (void)creatScrollViewBack{
     self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 736)];
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 0);
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
}
- (void)creatScrollLeftView{
    
    UIImageView *imageViewFirst = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 750)];
    
    imageViewFirst.image = [UIImage imageNamed:@"bake.jpg"];
    
    [self.scrollView addSubview:imageViewFirst];
}
- (void)creatScrollRightView:(NSString *)str{

    //播放背景图片
    self.imageViewSceond = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 750)];
    
    [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:str]];
    //    self.imageViewSceond.image = [UIImage imageNamed:@"bakeThree.jpg"];
    //    毛玻璃
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //
    //    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //
    //    effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 680);
    //
    //    effectView.alpha = 0.8;
    //
    //    [self.imageViewSceond addSubview:effectView];
    
    //    ----------
    [self.scrollView addSubview:self.imageViewSceond];

}
//音量按钮
- (void)volume{
//    控制声音大小的两个按钮
    UIButton *leftOneButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [leftOneButton setImage:[UIImage imageNamed:@"iconfont-icon1"]forState:UIControlStateNormal];
    
    [leftOneButton addTarget:self action:@selector(btnA) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftOneItem = [[UIBarButtonItem alloc]initWithCustomView:leftOneButton];
    

    UIButton *leftTwoButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [leftTwoButton setImage:[UIImage imageNamed:@"iconfont-icon2"]forState:UIControlStateNormal];
    
    [leftTwoButton addTarget:self action:@selector(btnL) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftTwoItem = [[UIBarButtonItem alloc]initWithCustomView:leftTwoButton];
    
//    返回按钮

//    UIBarButtonItem *goBack = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(goBackClick)];
//    
//    self.navigationItem.backBarButtonItem = goBack;
    
    
    
    
    NSArray *array = [[NSArray alloc]init];
    
    array = @[leftOneItem,leftTwoItem];
    
    self.navigationItem.leftBarButtonItems = array;
    
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [rightBtn setImage:[UIImage imageNamed:@"iconfont-diaozhenggeci"]forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(btnR) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

 
    self.navigationItem.rightBarButtonItem = rightItem;
    
   
    
}
- (void)btnA{
    NSLog(@"+");
    
    if (self.player.volume > 100) {
   
        
        
    }else{
        
        self.player.volume = self.player.volume + 1;
        
    }
    self.alert = [UIAlertController alertControllerWithTitle:@"音量" message:[NSString stringWithFormat:@"%d",(int)self.player.volume] preferredStyle:1];
    
    

    [self presentViewController:self.alert animated:YES completion:^{
        
        
    }];
    
    NSTimer *timeVolume = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVolumeGo) userInfo:nil repeats:NO];
    [timeVolume fire];
}
- (void)timeVolumeGo{
    NSLog(@"弹框消失");
    [self.alert dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}
- (void)btnL{
    NSLog(@"-");
    if (self.player.volume < 0) {
        
        self.player.volume = 0;
    }else{
        
        self.player.volume = self.player.volume - 1;

    }
    self.alert = [UIAlertController alertControllerWithTitle:@"音量" message:[NSString stringWithFormat:@"%d",(int)self.player.volume] preferredStyle:1];
    
    
    
    [self presentViewController:self.alert animated:YES completion:^{
        
        
    }];
    
    NSTimer *timeVolume = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVolumeGo) userInfo:nil repeats:NO];
    [timeVolume fire];

}
- (void)btnR{
    if (self.lycYesOrNo == NO) {
        self.tableView.alpha = 0;
        self.lycYesOrNo = YES;
        
    }else if (self.lycYesOrNo == YES){
        
        self.tableView.alpha = 1;
        self.lycYesOrNo = NO;
    }
    
}
- (void)goBackClick{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.player stop];
}
//AV的协议方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self next];
}

//声道
- (void)creatSegment{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"左声道",@"立体声",@"右声道"]];
    segment.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
    
    [segment addTarget:segment action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    segment.selectedSegmentIndex = 1;
    
    segment.tintColor = [UIColor grayColor];
  
    
    [self.scrollView addSubview:segment];
}
- (void)segmentClick:(UISegmentedControl *)btn{
//    if (btn.selectedSegmentIndex == 1) {
//        self.player.pan = -1;
//    }else if (btn.selectedSegmentIndex == 2){
//        self.player.pan = 0;
//
//    }else if (btn.selectedSegmentIndex == 3){
//        self.player.pan = 1;
//
//    }
//    
}
//警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//页面将要进入前台，开启定时器
//-(void)viewWillAppear:(BOOL)animated
//{
//    //开启定时器
//    [self.timer setFireDate:[NSDate distantPast]];
//}
//
////页面消失，进入后台不显示该页面，关闭定时器
//-(void)viewDidDisappear:(BOOL)animated
//{
//    //关闭定时器
//    [self.timer setFireDate:[NSDate distantFuture]];
//}
@end
