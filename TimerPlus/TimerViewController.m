//
//  TimerViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"
#import <AVFoundation/AVFoundation.h>
#import "Exercise.h"


@interface TimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property int intSeconds;
@property int intStop;
@property int sets;

@property NSMutableArray *timerState;
@property int currentTimerState;
@property NSTimer *aTimer;
@property NSString *currentExercise;
@property int exercisePosition;
@property int currentTotal;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.timerState = [NSMutableArray new];
    self.currentTimerState = 0;
    self.currentTotal = 0;

    self.sets = (int)self.timer.sets;
    [self initDisplay];

    if (self.timer.warmup > 0) {
        [self.timerState addObject:@"warmup"];
    }

    for (int i=0;i<self.sets;i++) {
        for (int j=0;j<self.timer.exercises.count;j++) {
            Exercise *exercise = self.timer.exercises[j];

            [self.timerState addObject:[NSString stringWithFormat:@"exercise %i %@",j,exercise.name]];
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

#pragma mark - Timer methods
- (void)setupTimerIntervalEnd {

    NSString *currentState = self.timerState[self.currentTimerState];

    if ([currentState containsString:@"exercise"]) {
        self.exercisePosition = [[currentState componentsSeparatedByString:@" "][1] intValue];
        Exercise *currentExercise = self.timer.exercises[self.exercisePosition];

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

    self.exerciseLabel.text = [self getCurrentExerciseStateLabel];
    self.aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

- (void)initDisplay {
    self.intSeconds = 0;
    [self updateValueLabel];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%li",(long)self.timer.totalTime];
}

- (void)resetTimer {
    [self.aTimer invalidate];
    self.aTimer = nil;
    self.intSeconds = 0;
    self.intStop = 0;

    self.currentTimerState++;

    if (self.currentTimerState < self.timerState.count) {
        [self startTimerWithInterval];
    }
}

- (void)stopTimer {
    [self.aTimer invalidate];
    self.aTimer = nil;
    self.intSeconds = 0;
    self.intStop = 0;
    self.currentTotal = 0;
}

- (void)onTick {
    self.intSeconds++;
    self.currentTotal++;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateValueLabel];
    });

    if (self.intSeconds > self.intStop) {
        [self resetTimer];
    }
    if (self.currentTotal > self.timer.totalTime) {
        [self stopTimer];
    }
    
}

#pragma mark - Retrieve Exercise
- (NSString *)getCurrentExerciseStateLabel {

    NSString *currentState = self.timerState[self.currentTimerState];
    NSString *outputState;

    if ([currentState isEqualToString:@"warmup"]) {
        outputState = @"Warmup";
    }
    if ([currentState isEqualToString:@"cooldown"]) {
        outputState = @"Cooldown";
    }
    if ([currentState isEqualToString:@"interval_between_reps"] || [currentState isEqualToString:@"interval_between_sets"]) {
        outputState = @"Rest";
    }
    if ([currentState containsString:@"exercise"]) {
        Exercise *exercise = self.timer.exercises[self.exercisePosition];
        outputState = exercise.name;
    }

    return outputState;
}

#pragma mark - IBActions

- (IBAction)onCloseButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Updated UI
- (void)updateValueLabel {
    self.valueLabel.text = [NSString stringWithFormat:@"%i",self.intSeconds];

    self.currentTimeLabel.text = [NSString stringWithFormat:@"%i",self.currentTotal];
}

@end
