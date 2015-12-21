//
//  HomeViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 12/9/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "HomeViewController.h"
#import "Exercise.h"
#import "Timer.h"
#import "TimerSetupViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *workouts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workouts = [NSMutableArray new];

    Timer *timer1 = [Timer new];
    timer1.name = @"abs";
    timer1.sets = 3;
    timer1.cooldown = 10;
    timer1.warmup = 10;
    timer1.interval_between_reps = 30;
    timer1.interval_between_sets = 45;

    Exercise *exercise1 = [Exercise new];
    exercise1.name = @"pushups";
    exercise1.seconds = 30;

    Exercise *exercise2 = [Exercise new];
    exercise2.name = @"pushups";
    exercise2.seconds = 30;

    Exercise *exercise3 = [Exercise new];
    exercise3.name = @"pushups";
    exercise3.seconds = 30;

    timer1.exercises = [NSMutableArray arrayWithObjects:exercise1, exercise2, exercise3, nil];

    [self.workouts addObject:timer1];

    Timer *timer2 = [Timer new];
    timer2.name = @"allout!";
    timer2.sets = 4;
    timer2.cooldown = 6;
    timer2.warmup = 7;
    timer2.interval_between_reps = 15;
    timer2.interval_between_sets = 15;

    Exercise *exercise4 = [Exercise new];
    exercise4.name = @"pullups";
    exercise4.seconds = 30;

    Exercise *exercise5 = [Exercise new];
    exercise5.name = @"situps";
    exercise5.seconds = 30;

    Exercise *exercise6 = [Exercise new];
    exercise6.name = @"mountain pushups";
    exercise6.seconds = 30;

    timer2.exercises = [NSMutableArray arrayWithObjects:exercise4, exercise5, exercise6, nil];

    [self.workouts addObject:timer2];

    Timer *timer3 = [Timer new];
    timer3.name = @"woday";
    timer3.sets = 5;
    timer3.cooldown = 20;
    timer3.warmup = 20;
    timer3.interval_between_reps = 50;
    timer3.interval_between_sets = 50;

    Exercise *exercise7 = [Exercise new];
    exercise7.name = @"tricep pushdown";
    exercise7.seconds = 45;

    Exercise *exercise8 = [Exercise new];
    exercise8.name = @"v-ups";
    exercise8.seconds = 23;

    Exercise *exercise9 = [Exercise new];
    exercise9.name = @"jump squats";
    exercise9.seconds = 67;

    timer3.exercises = [NSMutableArray arrayWithObjects:exercise7, exercise8, exercise9, nil];

    [self.workouts addObject:timer3];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];


    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [self.workouts[indexPath.row] name];

    return cell;
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString: @"ExistingWorkoutSegue"]) {
        TimerSetupViewController *vc = segue.destinationViewController;
        Timer *currentTimer = self.workouts[indexPath.row];

        vc.timer = currentTimer;
    }

}
@end
