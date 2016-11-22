//
//  AudioStreamer.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 2016/11/22.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "AudioStreamer.h"

@implementation AudioStreamer

+ (instancetype)shareInstance
{
    static AudioStreamer *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)creatStreamerWithUrl:(NSURL *)url
{
    if (_streamer == nil) {
        _streamer = [[FSAudioStream alloc]init];
        _streamer.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
        };
        _streamer.onCompletion=^(){
            NSLog(@"播放完成!");
        };
    }
    [_streamer setUrl:url];
    [_streamer setVolume:0.5];//设置声音
}

- (void)streamerPlayWithUrl:(NSURL *)url
{
    if (_streamer == nil) {
        _streamer = [[FSAudioStream alloc]init];
        _streamer.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
        };
        _streamer.onCompletion=^(){
            NSLog(@"播放完成!");
        };
    }
    [_streamer setUrl:url];
    [_streamer setVolume:0.5];//设置声音
    [_streamer play];
}

- (void)beginPlay
{
    [_streamer play];
}

- (void)stopPlay
{
    [_streamer stop];
}

@end
