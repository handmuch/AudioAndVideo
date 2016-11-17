//
//  soundEffectPlay.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/16.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "soundEffectPlay.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation soundEffectPlay

+ (instancetype)shareInstance
{
    static soundEffectPlay *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)playSoundEffect:(NSString *)name AndCompletion:(void(^)())completionBlock
{
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFilePath];
    
    //获得系统soundID
    SystemSoundID soundId = 0;
    
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileUrl), &soundId);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    //使用回调block这个注册失效
    AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, soundCompleteCallback, NULL);
    //使用新版方法，block
    AudioServicesPlayAlertSoundWithCompletion(soundId, completionBlock);
    
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

@end
