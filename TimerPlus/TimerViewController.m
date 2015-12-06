//
//  TimerViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"
#import "Exercise.h"

@interface TimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property int intSeconds;
@property int intStop;
@property int sets;

@property NSMutableArray *timerState;
@property int currentTimerState;
@property NSTimer *aTimer;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Setup timer state
    // 0 = warmup
    // 1 = exercise
    // 2 = cooldown
    self.timerState = [NSMutableArray new];
    self.currentTimerState = 0;

    self.sets = (int)self.timer.sets;
    [self resetTimer];

    if (self.timer.warmup > 0) {
        [self.timerState addObject:@"warmup"];
    }

    for (int i=0;i<self.sets;i++) {
        for (int j=0;j<self.timer.exercises.count;j++) {
            [self.timerState addObject:[NSString stringWithFormat:@"exercise %i",j]];
            if (self.timer.interval_between_reps > 0 && j != self.timer.exercises.count-1) {
                [self.timerState addObject:@"interval_between_reps"];
            }
        }

        if (self.timer.interval_between_sets > 0) {
            [self.timerState addObject:@"interval_between_sets"];
        }
    }

    if (self.timer.cooldown > 0) {
        [self.timerState addObject:@"cooldown"];
    }

    NSLog(@"created timer states");

    [self startTimerWithInterval];
}

- (void)setupTimerIntervalEnd {

    NSString *currentState = self.timerState[self.currentTimerState];

    if ([currentState containsString:@"exercise"]) {
        int exercisePos = [[currentState componentsSeparatedByString:@" "][1] intValue];
        Exercise *currentExercise = self.timer.exercises[exercisePos];

        self.intStop = (int)currentExercise.seconds;
    }

    if ([currentState isEqualToString:@"warmup"]) {
        self.intStop = (int)self.timer.warmup;
    }

    if ([currentState isEqualToString:@"cooldown"]) {
        self.intStop = (int)self.timer.cooldown;
    }

    if ([currentState isEqualToString:@"interval_between_reps"]) {
        self.intStop = (int)self.timer.interval_between_reps;
    }

    if ([currentState isEqualToString:@"interval_between_sets"]) {
        self.intStop = (int)self.timer.interval_between_sets;
    }
}

- (void)startTimerWithInterval{
    [self setupTimerIntervalEnd];
    self.exerciseLabel.text = self.timerState[self.currentTimerState];
    self.aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

- (void)resetTimer {
    self.intSeconds = 0;
    [self updateValueLabel];
}

- (void)stopTimer {
    [self.aTimer invalidate];
    self.aTimer = nil;
    self.intSeconds = 0;
    self.intStop = 0;

    self.currentTimerState++;

    if (self.currentTimerState < self.timerState.count) {
        [self startTimerWithInterval];
    }
}

- (void)updateValueLabel {
    self.valueLabel.text = [NSString stringWithFormat:@"%i",self.intSeconds];
}

- (void)onTick {
    self.intSeconds++;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateValueLabel];
    });



    if (self.intSeconds > self.intStop) {
        [self stopTimer];
    }

}
- (IBAction)onCloseButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
