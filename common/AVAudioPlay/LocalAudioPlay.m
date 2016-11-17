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
@property (strong ,nonatomic) NSTimer *timer;//进度更新定时器

@end

@implementation LocalAudioPlay

/**
 *  创建AudioPlayer
 *
 *  @param fileName 文件名
 *
 *  @return 实例
 */
- (void)audioPlayerWithFileName:(NSString *)fileName
{
    if (nil == _audioPlayer) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSURL *pathUrl = [NSURL fileURLWithPath:filePath];
        
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:pathUrl error:&error];
        //循环次数
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        }
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

- (void)updateProgress
{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateProgressWith:)]) {
        [self.delegate updateProgressWith:progress];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"播放完毕");
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



@end
