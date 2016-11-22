//
//  MPMediaPlayViewController.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/18.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "MPMediaPlayViewController.h"
#import "MPMediaPlay.h"

@interface MPMediaPlayViewController ()

@property (strong, nonatomic) UIView *controlbackground;
@property (strong, nonatomic) UILabel *controlPanel; //控制面板
@property (strong, nonatomic) UIProgressView *playProgress;//播放进度
@property (strong, nonatomic) UILabel *musicSinger; //演唱者
@property (strong, nonatomic) UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (strong, nonatomic) UIButton *nextSong;
@property (strong, nonatomic) UIButton *PreviousSong;

@property (strong, nonatomic) MPMediaPlay *mpMediaPlayer;

@end

@implementation MPMediaPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initMPMediaPlayer];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.controlbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 130, self.view.bounds.size.width, 130)];
    self.controlbackground.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:90/255.0 blue:90/255.0 alpha:0.6];
    self.controlbackground.userInteractionEnabled = YES;
    [self.view addSubview:self.controlbackground];
    
    self.playProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.playProgress.frame = CGRectMake(5, 40, self.controlbackground.bounds.size.width - 10, 1);
    self.playProgress.progressTintColor = [UIColor blueColor];
    self.playProgress.trackTintColor = [UIColor whiteColor];
    [self.controlbackground addSubview:self.playProgress];
    
    self.controlPanel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80, 20)];
    self.controlPanel.backgroundColor = [UIColor clearColor];
    self.controlPanel.textAlignment = NSTextAlignmentLeft;
    self.controlPanel.textColor = [UIColor whiteColor];
    self.controlPanel.font = [UIFont systemFontOfSize:14.0f];
    self.controlPanel.text = @"00:00";
    [self.controlbackground addSubview:self.controlPanel];
    
    self.playOrPause = [[UIButton alloc]initWithFrame:CGRectMake(self.controlbackground.bounds.size.width/2 - 32.5, 55, 65, 65)];
    [self.playOrPause setImage:[UIImage imageNamed:@"play.png"]
                      forState:UIControlStateNormal];
    self.playOrPause.tag = 0;
    [self.playOrPause addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.playOrPause];
    
    self.nextSong = [[UIButton alloc]initWithFrame:CGRectMake(self.controlbackground.bounds.size.width/2 + 30, 65, 45, 45)];
    [self.nextSong setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.nextSong addTarget:self action:@selector(playNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.nextSong];
    
    self.PreviousSong = [[UIButton alloc]initWithFrame:CGRectMake(self.controlbackground.bounds.size.width/2 - 80, 65, 45, 45)];
    [self.PreviousSong setImage:[UIImage imageNamed:@"pervious.png"] forState:UIControlStateNormal];
    [self.PreviousSong addTarget:self action:@selector(playPrevious:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.PreviousSong];
    
    UIBarButtonItem *ipodItem = [[UIBarButtonItem alloc]initWithTitle:@"选择"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(itemSelect:)];
    [self.navigationItem setRightBarButtonItem:ipodItem animated:NO];
}

- (void)initMPMediaPlayer
{
    self.mpMediaPlayer = [[MPMediaPlay alloc]init];
}

#pragma mark - method selector

- (void)playOrPause:(UIButton *)sender
{
    if(sender.tag){
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.mpMediaPlayer.playerControl pause];
    }else{
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.mpMediaPlayer.playerControl play];
    }
}

- (void)playNext:(UIButton *)sender
{
    [self.mpMediaPlayer.playerControl skipToNextItem];
}

- (void)playPrevious:(UIButton *)sender
{
    [self.mpMediaPlayer.playerControl skipToPreviousItem];
}

- (void)itemSelect:(id)sender
{
    [self.navigationController presentViewController:self.mpMediaPlayer.pickerControl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
