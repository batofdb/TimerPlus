//
//  AudioAlertManager.m
//  TimerPlus
//
//  Created by Francis Bato on 12/21/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "AudioAlertManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioAlertManager() <AVSpeechSynthesizerDelegate>

@property AVSpeechSynthesizer *talker;
@property int utteranceCounter;

@end

@implementation AudioAlertManager

- (void)playAlertWithString:(NSString *)str {

    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:str];

    if (!self.talker)
        self.talker = [[AVSpeechSynthesizer alloc] init];

    self.talker.delegate = self;
    [self.talker speakUtterance:utterance];
}

- (void)syncAudioManagerWithCurrentTime:(NSInteger)current andTimeLimit:(NSInteger)endTime {
    NSInteger deltaTime = endTime - current;

    [self playAlertWithString:[NSString stringWithFormat:@"%ld",(long)deltaTime]];
}

- (void)stopAlert {
    AVSpeechSynthesizer *talked = self.talker;

    if ([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}


@end
