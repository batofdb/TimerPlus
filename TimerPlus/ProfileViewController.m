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

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *profileBorderView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) UIPageViewController *pageViewController;
//@property (nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property CGFloat offset_HeaderStop;
@property CGFloat headerHeight;
@property NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offset_HeaderStop = 40.0; // At this offset the background stops its transformation




    self.items = @[@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8",@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8",@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8"];
    //Set height of header

    self.tableView.backgroundColor = [UIColor clearColor];

    NSLog(@"table view header height:%f",self.backgroundView.frame.size.height);


    self.tableView.contentInset = UIEdgeInsetsMake(self.backgroundView.frame.size.height, 0, 0, 0);

    //[self updateHeaderView];

    self.profileBorderView.layer.cornerRadius = 5.0;
    self.profileBorderView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.clipsToBounds = YES;

    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    //Moved the following code from view did load, apparently screen size does not get processed down from 600 to its actual device screen size until view did appear.
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
    headerImageView.image = [UIImage imageNamed:@"header_bg"];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;

    NSLog(@"background view height:%f",self.backgroundView.bounds.size.height);

    [self.backgroundView insertSubview:headerImageView belowSubview:self.headerLabel];

    self.backgroundView.clipsToBounds = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //Add 20 due to the -20 top layout constraint
    CGFloat offset = scrollView.contentOffset.y + self.backgroundView.bounds.size.height + 20;

    NSLog(@"offset: %f scroll offset:%f background:%f",offset, scrollView.contentOffset.y, self.backgroundView.bounds.size.height);

    CATransform3D profileTransform = CATransform3DIdentity;
    CATransform3D tableHeaderTransform = CATransform3DIdentity;


    if (offset < 0) {

        //Handle Pull Down
#pragma mark - Pull Down
        //Create a scale factor that is proportional to the amount of scroll offset
        CGFloat tableHeaderScaleFactor = -(offset)/self.backgroundView.bounds.size.height;

        //Calculate the amount of distance the image has shifted from the top after scaling
        CGFloat tableHeaderSizeVariation = ((self.backgroundView.bounds.size.height * (1.0 + tableHeaderScaleFactor)) - self.backgroundView.bounds.size.height)/2;

        //Translate the view to the top fo the superview
        tableHeaderTransform = CATransform3DTranslate(tableHeaderTransform, 0, tableHeaderSizeVariation, 0);

        //Scale the image according to distance the user has pulled down on the header
        tableHeaderTransform = CATransform3DScale(tableHeaderTransform, 1.0 + tableHeaderScaleFactor, 1.0 + tableHeaderScaleFactor, 0);

        self.backgroundView.layer.zPosition = 0;
        self.headerLabel.hidden = YES;

    } else {

        //Handle scroll up and down
#pragma mark - Scroll Up/Down

        tableHeaderTransform = CATransform3DTranslate(tableHeaderTransform, 0, MAX(-self.offset_HeaderStop, -offset), 0);


        self.headerLabel.hidden = NO;


        CGFloat avatarScaleFactor = (MIN(self.offset_HeaderStop, offset)) / self.profileBorderView.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((self.profileBorderView.bounds.size.height * (1.0 + avatarScaleFactor)) - self.profileBorderView.bounds.size.height) / 2.0;
        profileTransform = CATransform3DTranslate(profileTransform, 0, avatarSizeVariation, 0);
        profileTransform = CATransform3DScale(profileTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);



        if (offset <= self.offset_HeaderStop) {

            if (self.profileBorderView.layer.zPosition < self.backgroundView.layer.zPosition) {
                self.backgroundView.layer.zPosition = 0;
            }

        } else {
            if (self.profileBorderView.layer.zPosition >= self.backgroundView.layer.zPosition) {
                self.backgroundView.layer.zPosition = 2;
            }
        }
    }

    self.backgroundView.layer.transform = tableHeaderTransform;
    self.profileBorderView.layer.transform = profileTransform;




    CGFloat segmentViewOffset = self.tableHeaderView.frame.size.height - self.segmentView.frame.size.height - offset;

        NSLog(@"segment: %f",segmentViewOffset);

    CATransform3D segmentTransform = CATransform3DIdentity;

    segmentTransform = CATransform3DTranslate(segmentTransform, 0, MAX(segmentViewOffset, -self.offset_HeaderStop), 0);

    self.segmentView.layer.transform = segmentTransform;


    // Set scroll view insets just underneath the segment control
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.segmentView.frame), 0, 0, 0);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    //[self updateHeaderView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

@end
