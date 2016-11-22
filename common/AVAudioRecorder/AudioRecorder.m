//
//  AudioRecorder.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 2016/11/21.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *timer;//进度更新定时器

@end

@implementation AudioRecorder

- (void)audioRecorderWithFileName:(NSString *)fileName
{
    if(_recorder == nil)
    {
        //创建录音文件保存路径
        NSURL *fileUrl = [self creatSavePathWithFileName:fileName];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:setting error:&error];
        _recorder.delegate=self;
        _recorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
    }
}


/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
- (NSURL *)creatSavePathWithFileName:(NSString *)fileName
{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:fileName];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

- (NSString *)getSavePathWithFileName:(NSString *)fileName
{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:fileName];
    NSLog(@"file path:%@",urlStr);
    return urlStr;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

#pragma mark - timer selector

- (void)audioPowerChange
{
    [self.recorder updateMeters];//更新测量值
    float power= [self.recorder averagePowerForChannel:0];//取得第一个通道的平均音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAudioRecorderWithProgress:)]) {
        [self.delegate updateAudioRecorderWithProgress:progress];
    }
}

#pragma mark -

/**
 *  点击录音按钮
 *
 */
- (void)record
{
    if (![self.recorder isRecording]) {
        [self.recorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

/**
 *  暂定
 *
 */
- (void)pause
{
    if ([self.recorder isRecording]) {
        [self.recorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  停止
 *
 */
- (void)stop
{
    [self.recorder stop];
    self.timer.fireDate=[NSDate distantFuture];
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

    if (self.delegate && [self.delegate respondsToSelector:@selector(recordComplete)]) {
        [self.delegate recordComplete];
    }
}

@end
