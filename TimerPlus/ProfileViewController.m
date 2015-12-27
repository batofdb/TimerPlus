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
#import <FXBlurView.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *profileBorderView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property CGFloat offset_HeaderStop;
@property CGFloat offset_HeaderLabel;
@property CGFloat headerHeight;
@property NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property UIImageView *blurHeaderImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offset_HeaderStop = 40.0; // At this offset the background stops its transformation
    self.offset_HeaderLabel = 30.0; // Offset of top layout guide to top of header label

    self.items = @[@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8",@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8",@"Full body", @"Abs", @"Leg Day", @"Arms", @"test1",@"test2",@"test3",@"test4",@"test5",@"test6",@"test7",@"test8"];

    // Set table bg to clear so that you can see the header_bg view
    self.tableView.backgroundColor = [UIColor clearColor];

    // Set padding of table view to the height of the header_bg view
    self.tableView.contentInset = UIEdgeInsetsMake(self.backgroundView.frame.size.height, 0, 0, 0);

    // Add white border to profile view
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

    [self.backgroundView insertSubview:headerImageView belowSubview:self.headerLabel];

    //Create blur background
    self.blurHeaderImageView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];

    //Used fxblurview here
    self.blurHeaderImageView.image = [[UIImage imageNamed:@"header_bg"] blurredImageWithRadius:10 iterations:20 tintColor:[UIColor clearColor]];
    [self.blurHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.blurHeaderImageView.alpha = 0.0;
    [headerImageView insertSubview:self.blurHeaderImageView aboveSubview:self.headerLabel];

    //Set clips to bounds so that image is confined to superview if not image will overlay on tableview
    self.backgroundView.clipsToBounds = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //Add 20 due to the -20 top layout constraint
    // Offset is scroll content offset (margin), height of background, and 20
    CGFloat offset = scrollView.contentOffset.y + self.backgroundView.bounds.size.height + 20;

    CATransform3D profileTransform = CATransform3DIdentity;
    CATransform3D tableHeaderTransform = CATransform3DIdentity;


    //Handle Pull Down

    if (offset < 0) {
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

        //Background transform
        tableHeaderTransform = CATransform3DTranslate(tableHeaderTransform, 0, MAX(-self.offset_HeaderStop, -offset), 0);


        //Header Label
        self.headerLabel.hidden = NO;

        //Offset keeps track of current position add the following dimensions:
        //full name label origin (y), background height, and the header stop
        CGFloat alignToNameLabel = -offset + self.fullnameLabel.frame.origin.y + self.backgroundView.frame.size.height + self.offset_HeaderStop;

        CGRect newFrame = self.headerLabel.frame;

        //Update the header label origin maxing out at the offsets up top
        newFrame.origin = CGPointMake(self.headerLabel.frame.origin.x, MAX(alignToNameLabel,self.offset_HeaderLabel + self.offset_HeaderStop));
        self.headerLabel.frame = newFrame;

        //Blur
        //Visible when scrolled down
        //Calculate ratio of current distance over the offset head label distance
        self.blurHeaderImageView.alpha = MIN(1.0,(offset - alignToNameLabel)/self.offset_HeaderLabel);

        //Profile transform
        CGFloat avatarScaleFactor = (MIN(self.offset_HeaderStop, offset)) / self.profileBorderView.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((self.profileBorderView.bounds.size.height * (1.0 + avatarScaleFactor)) - self.profileBorderView.bounds.size.height) / 2.0;

        //x axis goes left on a negative value, y axis goes down on a positive
        profileTransform = CATransform3DTranslate(profileTransform, -avatarSizeVariation, avatarSizeVariation, 0);
        profileTransform = CATransform3DScale(profileTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        


        // Bring profile to front or back depending on scroll offset
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

    //Apply transforms
    self.backgroundView.layer.transform = tableHeaderTransform;
    self.profileBorderView.layer.transform = profileTransform;



    //Segment Transform
    CGFloat segmentViewOffset = self.tableHeaderView.frame.size.height - self.segmentView.frame.size.height - offset;

    CATransform3D segmentTransform = CATransform3DIdentity;

    segmentTransform = CATransform3DTranslate(segmentTransform, 0, MAX(segmentViewOffset, -self.offset_HeaderStop), 0);

    self.segmentView.layer.transform = segmentTransform;

    // Set scroll view insets just underneath the segment control
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.segmentView.frame), 0, 0, 0);

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
