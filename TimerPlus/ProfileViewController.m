//
//  ProfileViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 12/22/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyTimersViewController.h"
#import "FriendsViewController.h"
#import "InboxViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *profileBorderView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
//@property (nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property CGFloat headerHeight;
@property NSArray *pageTitles;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerHeight = 250.0;

    //self.delegate = [[UIApplication sharedApplication] delegate];

    //Setup page control content view below profile
    self.pageTitles = @[@"MyTimers", @"Friends", @"Inbox"];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileContentPageController"];
    self.pageViewController.dataSource = self;

    //Constrain height to header
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);

    [self addChildViewController:self.pageViewController];
    [self.contentView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    //Setup profile image
    self.profileBorderView.layer.cornerRadius = 5.0;
    self.profileBorderView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.clipsToBounds = YES;


    CGRect tvFrame = self.tableView.frame;
    CGFloat height = self.view.frame.size.height - self.tableView.sectionHeaderHeight - self.tableHeaderView.frame.size.height - self.tabBarController.tabBar.frame.size.height;

    NSLog(@"%f %f",tvFrame.size.height,self.tableHeaderView.frame.size.height);

    if (height > 0) { // MIN_HEIGHT is your minimum tableViewFooter height
        CGRect frame = self.contentView.frame;
        NSLog(@"%f",frame.size.height);

        self.contentView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    }

    [self.tableView reloadData];
}


#pragma mark - Page Control Delegate Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = ((MyTimersViewController *)viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;

    if (index >= [self.pageTitles count]) {
        return nil;
    }
    NSLog(@"After: %li",index);
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {

    if (([self.pageTitles count] == 0) || index >= [self.pageTitles count]) {
        return nil;
    }

    if (index == 0) {
        MyTimersViewController *MyTimersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTimersViewController"];
        MyTimersViewController.pageIndex = index;

        return MyTimersViewController;
    } else if (index == 1) {
        FriendsViewController *FriendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
        FriendsViewController.pageIndex = index;

        return FriendsViewController;
    } else if (index == 2) {
        InboxViewController *InboxViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InboxViewController"];
        InboxViewController.pageIndex = index;

        return InboxViewController;
    }

    return nil;


}

/*
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageTitles.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}
 */

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSUInteger index = ((MyTimersViewController *) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    NSLog(@"Before: %li",index);
    return [self viewControllerAtIndex:index];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    //Populate HUD after data is received
    MyTimersViewController *startingVC = (MyTimersViewController *)[self viewControllerAtIndex:0];
    NSArray *viewcontrollers = @[startingVC];
    [self.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"row";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"test";
}

@end
