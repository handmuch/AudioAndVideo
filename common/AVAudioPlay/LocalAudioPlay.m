//
//  LocalAudioPlay.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/17.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LocalAudioPlay.h"

@interface LocalAudioPlay ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;//进度更新定时器

@end

@implementation LocalAudioPlay

/**
 *  创建AudioPlayer
 *
 *  @param fileName 文件名
 *
 *  @return 实例
 */
- (void)audioPlayerWithFileUrl:(NSString *)pathUrl
{
    if (nil == _audioPlayer) {
        
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathUrl]
                                                             error:&error];
        //循环次数
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        }
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [session setActive:YES error:nil];
        
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(routeChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];
    }
}

/**
 *  初始化定时器
 *
 *  @return timer
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(updateProgress)
                                              userInfo:nil
                                               repeats:true];
    }
    return _timer;
}

#pragma mark - avdioPlayer method

/**
 *  播放
 */
- (void)play
{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        //恢复定时器
        self.timer.fireDate = [NSDate distantPast];
    }
}

/**
 *  暂停
 */
- (void)pause
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        //暂停定时器
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"播放完毕");
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [self.timer invalidate];
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error;
{
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
}

#pragma mark - delegate

- (void)updateProgress
{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAudioPlayWithProgress:AndCurrentTime:)]) {
        [self.delegate updateAudioPlayWithProgress:progress AndCurrentTime:self.audioPlayer.currentTime];
    }
}

#pragma mark - notifition

- (void)routeChange:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}



@end
