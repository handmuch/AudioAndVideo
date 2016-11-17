//
//  soundEffectPlay.h
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/16.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface soundEffectPlay : NSObject

+ (instancetype)shareInstance;

- (void)playSoundEffect:(NSString *)name AndCompletion:(void(^)())completionBlock;

@end
