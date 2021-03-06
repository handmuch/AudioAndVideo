//
//  AudioPlayViewController.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/17.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "AudioPlayViewController.h"
#import "LocalAudioPlay.h"

#define Music_Name @"Say You Love Me.mp3"
#define Music_Title @"Say You Love Me"

@interface AudioPlayViewController ()<AudioPlayProgressUpdate>

@property (strong, nonatomic) UIView *controlbackground;
@property (strong, nonatomic) UILabel *controlPanel; //控制面板
@property (strong, nonatomic) UIProgressView *playProgress;//播放进度
@property (strong, nonatomic) UILabel *musicSinger; //演唱者
@property (strong, nonatomic) UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)

@property (strong, nonatomic) LocalAudioPlay *audioPlayer;

@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Music_Title;
    
    [self initView];
    [self initAudioPlay];
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
    [self.playOrPause setBackgroundImage:[UIImage imageNamed:@"playbg.png"] forState:UIControlStateNormal];
    self.playOrPause.tag = 0;
    [self.playOrPause addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.playOrPause];
}

- (void)initAudioPlay
{
    if (self.audioPlayer == nil) {
        self.audioPlayer = [[LocalAudioPlay alloc]init];
        self.audioPlayer.delegate = self;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:Music_Name ofType:nil];
        [self.audioPlayer audioPlayerWithFileUrl:filePath];
    }
}


/**
 *  显示当面视图控制器时注册远程事件
 *
 *  @param animated 是否以动画的形式显示
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //作为第一响应者
    //[self becomeFirstResponder];
}
/**
 *  当前控制器视图不显示时取消远程控制
 *
 *  @param animated 是否以动画的形式消失
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
}


#pragma mark - button seletor

- (void)playOrPause:(UIButton *)sender
{
    if(sender.tag){
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.audioPlayer pause];
    }else{
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.audioPlayer play];
    }
}

#pragma mark - localAudioPlayDelegate

- (void)updateAudioPlayWithProgress:(float)progress
                    AndCurrentTime:(float)currentTime
{
    [self.playProgress setProgress:progress animated:YES];
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = round(currentTime - minutes * 60);
    self.controlPanel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
