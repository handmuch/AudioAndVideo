//
//  AudioStreamer.h
//  AudioAndvideo_Demo
//
//  Created by POWER on 2016/11/22.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAudioStream.h"

@interface AudioStreamer : NSObject

@property (strong, nonatomic) FSAudioStream *streamer;

+ (instancetype)shareInstance;

- (void)creatStreamerWithUrl:(NSURL *)url;

- (void)streamerPlayWithUrl:(NSURL *)url;

- (void)beginPlay;

- (void)stopPlay;

@end
