//
//  InboxViewController.m
//  TimerPlus
//
//  Created by Francis Bato on 12/22/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *items;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = @[@"Woday", @"Crazy Chest", @"Back for days"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Inbox";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = (scrollView.contentOffset.y > 10);
}

@end
