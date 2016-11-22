//
//  AudioRecorder.h
//  AudioAndvideo_Demo
//
//  Created by POWER on 2016/11/21.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioRecorderProgressUpdate <NSObject>

@optional
- (void)updateAudioRecorderWithProgress:(float)progress;
- (void)recordComplete;
@end

@interface AudioRecorder : NSObject

@property (weak, nonatomic) id <AudioRecorderProgressUpdate> delegate;

- (void)audioRecorderWithFileName:(NSString *)fileName;
- (NSString *)getSavePathWithFileName:(NSString *)fileName;

- (void)record;
- (void)pause;
- (void)stop;

@end
