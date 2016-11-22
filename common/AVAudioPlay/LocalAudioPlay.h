//
//  LocalAudioPlay.h
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/17.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayProgressUpdate <NSObject>

@optional
- (void)updateAudioPlayWithProgress:(float)progress AndCurrentTime:(float)currentTime;

@end

@interface LocalAudioPlay : NSObject

@property (weak, nonatomic) id <AudioPlayProgressUpdate> delegate;

/**
 *  创建AudioPlayer
 *
 *  @param fileName 文件名
 *
 *  @return 
 */
- (void)audioPlayerWithFileUrl:(NSString *)pathUrl;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

@end
