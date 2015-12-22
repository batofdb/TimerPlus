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
#import "AppDelegate.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *workouts;
@property NSSet *hashTableTimerNames;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hashTableTimerNames = [NSSet new];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.workouts = [NSMutableArray new];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self loadTimers];
    [self.tableView reloadData];
}

- (void)loadTimers {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Timer"];
    NSError *error;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];

    NSArray *results = [[self.moc executeFetchRequest:request error:&error] mutableCopy];

    [self fetchAllTimers];

    for (int i=0;i<results.count;i++) {

        NSManagedObject *object = results[i];

        Timer *timer = [Timer new];
        timer.name = [object valueForKey:@"name"];
        timer.sets = [[object valueForKey:@"sets"] intValue];
        timer.interval_between_reps = [[object valueForKey:@"interval_between_reps"] intValue];
        timer.interval_between_sets = [[object valueForKey:@"interval_between_sets"] intValue];
        timer.warmup = [[object valueForKey:@"warmup"] intValue];
        timer.cooldown = [[object valueForKey:@"cooldown"] intValue];
        timer.totalTime = [[object valueForKey:@"totalTime"] intValue];

        NSString *strExercises = [object valueForKey:@"exercises"];
        NSLog(@"%@",strExercises);

        if (![strExercises isEqualToString:@""])
            timer.exercises = [[Timer convertStringToExercises:strExercises] mutableCopy];

        if (![self.hashTableTimerNames containsObject:timer.name]) {
            [self.workouts addObject:timer];
        } else {
            for (int j=0;j<self.workouts.count;j++) {
                if ([timer.name isEqualToString:[self.workouts[j] name]])
                    [self.workouts replaceObjectAtIndex:j withObject:timer];
            }

        }
    }

    if (error) {
        //Error handling
    }
}

- (void)fetchAllTimers {
    self.hashTableTimerNames = [NSSet setWithArray:[self.workouts valueForKeyPath:@"name"]];

    NSLog(@"here");
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        Timer *timer = self.workouts[indexPath.row];

        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Timer"];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",timer.name];
        [request setPredicate:predicate];

        NSError *error = nil;
        NSArray *results = [self.moc executeFetchRequest:request error:&error];

        if (results.count > 0) {
            NSManagedObject *objectToDelete = results.firstObject;
            [self.moc deleteObject:objectToDelete];
            [self.moc save:&error];

            if (error) {
                //Error handling
            } else {
                [self.workouts removeObjectAtIndex:indexPath.row];

                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];

                
                [self.tableView reloadData];
            }
        }




    }
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

#pragma mark - Core Data

@end
