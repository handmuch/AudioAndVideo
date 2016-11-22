//
//  MPMediaPlay.h
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/18.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol MPMediaPlayOperationDelegate <NSObject>

@required
- (void)mediaPickerSelectItem:(MPMediaItemCollection *)itemCollection;
- (void)mediaPickerCancel;
@optional
- (void)mediaPlayerChangeState:(MPMusicPlaybackState)plyerState;

@end

@interface MPMediaPlay : NSObject<MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaPickerController *pickerControl;
@property (nonatomic, strong) MPMusicPlayerController *playerControl;

@property (nonatomic, weak) id <MPMediaPlayOperationDelegate> delegate;


@end
