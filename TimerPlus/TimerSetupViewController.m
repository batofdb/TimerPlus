//
//  TimerSetupViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "TimerSetupViewController.h"
#import "TimerViewController.h"
#import "Timer.h"
#import "Exercise.h"
#import "AppDelegate.h"
#import "RightTextFieldTableViewCell.h"
#import "BothTextFieldTableViewCell.h"

#define SECONDSFIELD 0;
#define NAMEFIELD 1;

@interface TimerSetupViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic) NSMutableArray *inputExercises;
@property NSManagedObjectContext *moc;

@end

@implementation TimerSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    if (!self.timer) {
        self.timer = [[Timer alloc]init];

        if (!self.timer.exercises)
            self.timer.exercises = [NSMutableArray new];
    }

    if (!self.timer.exercises)
        self.inputExercises = [NSMutableArray new];
    else
        self.inputExercises = self.timer.exercises;


    [self.tableView reloadData];
}

#pragma mark - Tableview Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4 && indexPath.row == 0) {

        [self saveTimer];
        NSLog(@"save");
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            RightTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Right"];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (indexPath.row == 0) {
                cell.leftTextLabel.text = @"Name";
                cell.rightTextField.text = self.timer.name;
            } else if (indexPath.row == 1) {
                cell.leftTextLabel.text = @"Number of sets";
                cell.rightTextField.text = [NSString stringWithFormat:@"%li",(long)self.timer.sets];
            }

            return cell;
            break;
        }
        case 1:
        {
            BothTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Both"];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            if (self.timer.exercises.count == 0) {
                cell.leftTextField.enabled = NO;
                cell.rightTextField.enabled = NO;
                cell.leftTextField.text = @"No exercises";
                cell.rightTextField.text = @"";
            } else {
                //Add exercises
                cell.leftTextField.enabled = YES;
                cell.rightTextField.enabled = YES;
                cell.leftTextField.text = @"";
                Exercise *exercise = self.timer.exercises[indexPath.row];

                cell.leftTextField.text = exercise.name;
                cell.rightTextField.text = [NSString stringWithFormat:@"%li", (long)exercise.seconds];
            }

            return cell;
            break;
        }
        case 2:
        {
            RightTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Right"];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (indexPath.row == 0) {
                cell.leftTextLabel.text = @"Rest between reps";
                cell.rightTextField.text = [NSString stringWithFormat:@"%li", (long)self.timer.interval_between_reps];
            } else if (indexPath.row == 1) {
                cell.leftTextLabel.text = @"Rest between sets";
                cell.rightTextField.text = [NSString stringWithFormat:@"%li",(long)self.timer.interval_between_sets];
            }
            return cell;
            break;
        }
        case 3:
        {
            RightTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Right"];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            if (indexPath.row == 0) {
                cell.leftTextLabel.text = @"Warmup";
                cell.rightTextField.text = [NSString stringWithFormat:@"%li",(long)self.timer.warmup];
            } else if (indexPath.row == 1) {
                cell.leftTextLabel.text = @"Cooldown";
                cell.rightTextField.text = [NSString stringWithFormat:@"%li",(long)self.timer.cooldown];
            }

            return cell;
            break;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Save";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.textLabel.text = @"test";

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows;
    switch (section)
    {
        case 0:
            rows = 2;
            break;
        case 1:
            if (self.timer.exercises.count > 0)
                rows = self.timer.exercises.count;
            else
                rows = 1;

            break;
        case 2:
            rows = 2;
            break;
        case 3:
            rows = 2;
            break;
        case 4:
            rows = 1;
            break;
        default:
            rows = 0;
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 40.0;
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 30.0)];
    [customView setBackgroundColor:UIColorFromRGB(0xFAFAFA)];


    // create the button object if seccion == 1
    if (section == 1) {
        UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        headerBtn.backgroundColor = [UIColor clearColor];
        headerBtn.opaque = NO;

        double widthButton = 100.0;

        headerBtn.frame = CGRectMake( self.view.frame.size.width-widthButton-12, 0.0, widthButton, 30.0);
        [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headerBtn setTitle:@"+" forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(onAddExerciseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:headerBtn];
    }

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];

    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Bold" size: 14.0f]];

    switch (section)
    {
        case 0:
            [headerLabel setText:@"INFO"];
            break;
        case 1:
            [headerLabel setText:@"EXERCISES"];
            break;
        case 2:
            [headerLabel setText:@"REST"];
            break;
        case 3:
            [headerLabel setText:@"PRE/POST"];
            break;
        default:
            [headerLabel setText:@""];
            break;
    }

    [customView addSubview:headerLabel];

    
    return customView;

}

#pragma mark - Exercise Actions

- (void)onAddExerciseButtonTapped {
    NSLog(@"Button Pressed");
    Exercise *newExercise = [Exercise new];
    newExercise.name = [NSString stringWithFormat:@"Exercise %lu",self.timer.exercises.count+1];
    newExercise.seconds = 0;

    NSMutableArray *tempExercises = [NSMutableArray arrayWithArray:self.inputExercises];
    [tempExercises addObject:newExercise];

    self.inputExercises = tempExercises;
}


- (void)setInputExercises:(NSMutableArray *)inputExercises {

    _inputExercises = inputExercises;
    self.timer.exercises = inputExercises;
    [self.tableView reloadData];
}

- (NSInteger)calculateTotalTime {
    NSInteger total = 0;
    total += self.timer.cooldown;
    total += self.timer.warmup;

    for (int i=0; i<self.timer.sets; i++) {
        for (int j=0; j< self.timer.exercises.count;j++) {
            Exercise *exercise = self.timer.exercises[j];
            total += exercise.seconds;
            if (j != self.timer.exercises.count-1) {
                total += self.timer.interval_between_reps;
            }
        }

        total += self.timer.interval_between_sets;
    }

    //Add 1s buffer to reset to 0
    //1s for each exercise component
    if (self.timer.cooldown > 0) {
        total += 1;
    }
    if (self.timer.warmup > 0) {
        total += 1;
    }

    //Remove 1s from beginning
    total -= 1;

    total += self.timer.sets;

    if (self.timer.exercises.count > 0)
        total += ((self.timer.exercises.count -1)+(self.timer.exercises.count))*self.timer.sets;

    return total;
}

#pragma mark - Helper Methods

- (NSIndexPath *)getIndexPathFromTextField:(UITextField *)textField {

    //Find IndexPath
    UIView *cell = textField;
    while (cell && ![cell isKindOfClass:[UITableViewCell class]])
        cell = cell.superview;

    //use the UITableViewcell superview to get the NSIndexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    NSLog(@"%li %li",(long)indexPath.section, (long)indexPath.row);

    return indexPath;
}

#pragma mark - UITextfield Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    NSString *proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];

    //New input string
    NSLog(@"%@",proposedNewString);



    NSIndexPath *indexPath = [self getIndexPathFromTextField:textField];

    switch (indexPath.section)
    {
        case 0:
            if(indexPath.row == 0)
                self.timer.name = proposedNewString;

            if(indexPath.row == 1)
                self.timer.sets = [proposedNewString integerValue];
            break;
        case 1:
            self.timer.exercises = self.inputExercises;
            break;
        case 2:
            if (indexPath.row == 0)
                self.timer.interval_between_reps = [proposedNewString integerValue];

            if (indexPath.row == 1)
                self.timer.interval_between_sets = [proposedNewString integerValue];

            break;
        case 3:
            if (indexPath.row == 0)
                self.timer.warmup = [proposedNewString integerValue];

            if (indexPath.row == 1)
                self.timer.cooldown = [proposedNewString integerValue];

            break;
        default:
            break;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    NSIndexPath *indexPath = [self getIndexPathFromTextField:textField];

    if (indexPath.section == 1) {
        Exercise *exercise = self.timer.exercises[indexPath.row];

        //Seconds field
        if (textField.tag == 0) {
            exercise.seconds = [textField.text intValue];
        }

        //Name field
        if (textField.tag == 1) {
            exercise.name = textField.text;
        }
    }

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    TimerViewController *vc = [segue destinationViewController];
    self.timer.totalTime = [self calculateTotalTime];
    vc.timer = self.timer;
    
}


#pragma mark - Save Data

- (void)saveTimer{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Timer"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.timer.name];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *results = [self.moc executeFetchRequest:request error:&error];

    if (results.count>0) {
        NSManagedObject *objectToDelete = results.firstObject;

        NSLog(@"found object");

        [self.moc deleteObject:objectToDelete];
        [self.moc save:nil];
    }

    NSManagedObject *coreTimer = [NSEntityDescription insertNewObjectForEntityForName:@"Timer" inManagedObjectContext:self.moc];

    [coreTimer setValue:self.timer.name forKey:@"name"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.sets] forKey:@"sets"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.interval_between_reps] forKey:@"interval_between_reps"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.interval_between_sets] forKey:@"interval_between_sets"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.warmup] forKey:@"warmup"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.cooldown] forKey:@"cooldown"];
    [coreTimer setValue:[NSNumber numberWithInt:(int)self.timer.totalTime] forKey:@"totalTime"];

    if (self.timer.exercises.count > 0)
        [coreTimer setValue:[self.timer convertExercisesToString:self.timer.exercises] forKey:@"exercises"];
    else
        [coreTimer setValue:@"" forKey:@"exercises"];


    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)self.timer.sets]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[self.timer convertExercisesToString:self.timer.exercises]]);

    [self.moc save:&error];
    if (error) {
        //Error handling
    }

}

@end
