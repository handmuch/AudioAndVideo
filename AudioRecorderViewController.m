//
//  AudioRecorderViewController.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 2016/11/21.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import "AudioRecorder.h"
#import "LocalAudioPlay.h"

#define fileName    @"MyVoice.caf"

@interface AudioRecorderViewController ()<AudioRecorderProgressUpdate>

@property (strong, nonatomic) UIView *controlbackground;
@property (strong, nonatomic) UILabel *controlPanel; //控制面板

@property (strong, nonatomic) UIButton *playOrPauseBtn; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (strong, nonatomic) UIButton *recordBtn;//开始录音
@property (strong, nonatomic) UIButton *stopBtn;//停止录音
@property (strong, nonatomic) UIProgressView *audioPower;//音频波动

@property (strong, nonatomic) LocalAudioPlay *audioPlayer;
@property (strong, nonatomic) AudioRecorder *audioRecorder;

@end

@implementation AudioRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self initAudio];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.controlbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 130, self.view.bounds.size.width, 130)];
    self.controlbackground.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:90/255.0 blue:90/255.0 alpha:0.6];
    self.controlbackground.userInteractionEnabled = YES;
    [self.view addSubview:self.controlbackground];
    
    self.audioPower = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.audioPower.frame = CGRectMake(5, 40, self.controlbackground.bounds.size.width - 10, 1);
    self.audioPower.progressTintColor = [UIColor blueColor];
    self.audioPower.trackTintColor = [UIColor whiteColor];
    [self.controlbackground addSubview:self.audioPower];
    
    self.controlPanel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80, 20)];
    self.controlPanel.backgroundColor = [UIColor clearColor];
    self.controlPanel.textAlignment = NSTextAlignmentLeft;
    self.controlPanel.textColor = [UIColor whiteColor];
    self.controlPanel.font = [UIFont systemFontOfSize:14.0f];
    self.controlPanel.text = @"00:00";
    [self.controlbackground addSubview:self.controlPanel];
    
    self.recordBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.controlbackground.bounds.size.width/4) - 27.5, 55, 55, 55)];
    [self.recordBtn setImage:[UIImage imageNamed:@"RecordView_Ready.png"]
                 forState:UIControlStateNormal];
    self.recordBtn.tag = 0;
    [self.recordBtn addTarget:self action:@selector(beginRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.recordBtn];
    
    self.stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(((self.controlbackground.bounds.size.width/4) * 2) - 27.5, 55, 55, 55)];
    [self.stopBtn setImage:[UIImage imageNamed:@"RecordView_Stop.png"]
                  forState:UIControlStateNormal];
    [self.stopBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.stopBtn];
    
    self.playOrPauseBtn = [[UIButton alloc]initWithFrame:CGRectMake(((self.controlbackground.bounds.size.width/4) * 3) - 27.5, 55, 55, 55)];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"RecordView_Play.png"]
                      forState:UIControlStateNormal];
    [self.playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlbackground addSubview:self.playOrPauseBtn];
    
}

- (void)initAudio
{
    if (self.audioRecorder == nil) {
        self.audioRecorder = [[AudioRecorder alloc]init];
        self.audioRecorder.delegate = self;
        [self.audioRecorder audioRecorderWithFileName:fileName];
    }
    

}

- (void)beginRecord:(id)sender
{
    [self.audioRecorder record];
}

- (void)stopRecord:(id)sender
{
    [self.audioRecorder stop];
}

- (void)playOrPause:(id)sender
{
    [self.audioPlayer play];
}

#pragma mark - record delegate

- (void)updateAudioRecorderWithProgress:(float)progress
{
    [self.audioPower setProgress:progress animated:YES];
}

- (void)recordComplete
{
    if (self.audioPlayer == nil) {
        self.audioPlayer = [[LocalAudioPlay alloc]init];
        [self.audioPlayer audioPlayerWithFileUrl:[self.audioRecorder getSavePathWithFileName:fileName]];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
