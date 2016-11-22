//
//  MPMediaPlay.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/18.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "MPMediaPlay.h"

@implementation MPMediaPlay

- (instancetype)init
{
    if (self = [super init]) {
        
        [self creatMPMediaPicker];
        [self creatMPMediaPlayer];
    }
    
    return self;
}

/**
 *  获得音乐播放器
 *
 *  @return 音乐播放器
 */
- (void)creatMPMediaPlayer
{
    if (_playerControl == nil) {
        _playerControl = [MPMusicPlayerController systemMusicPlayer];
        [_playerControl beginGeneratingPlaybackNotifications];
        [self addNotification];
        //如果不使用MPMediaPickerController可以使用如下方法获得音乐库媒体队列
        //[_playerControl setQueueWithItemCollection:[self getLocalMediaItemCollection]];
    }
}

/**
 *  创建媒体选择器
 *
 *  @return 媒体选择器
 */
- (void)creatMPMediaPicker
{
    if (_pickerControl == nil) {
//      初始化媒体选择器，这里设置媒体类型为音乐，其实这里也可以选择视频、广播等
//      _pickerControl = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
        _pickerControl = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
        _pickerControl.allowsPickingMultipleItems = YES; //允许多选
//      _pickerControl.showsCloudItems=YES;//显示icloud选项
        _pickerControl.prompt = @"请选择要播放的音乐";
        _pickerControl.delegate = self;
        [_pickerControl loadView];
    }
}

/**
 *  取得媒体队列
 *
 *  @return 媒体队列
 */
-(MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection=[[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark - MPMediaPicker Delagate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPickerSelectItem:)]) {
        [self.delegate mediaPickerSelectItem:mediaItemCollection];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPickerCancel)]) {
        [self.delegate mediaPickerCancel];
    }
}

#pragma mark - 通知
/**
 *  添加通知
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(playbackStateChange:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object:self.playerControl];
}

/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    //Todo
}

-(void)dealloc{
    [self.playerControl endGeneratingPlaybackNotifications];
}

@end
