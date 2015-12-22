//
//  AudioAlertManager.h
//  TimerPlus
//
//  Created by Francis Bato on 12/21/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AudioAlertManager : NSObject

- (void)playAlertWithString:(NSString *)str;
- (void)syncAudioManagerWithCurrentTime:(NSInteger)current andTimeLimit:(NSInteger)endTime;
- (void)stopAlert;
@end
