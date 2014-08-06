//
//  GTMasterViewController.m
//  ParseTester
//
//  Created by Samuel J. Dunster on 8/5/14.
//  Copyright (c) 2014 Parse. All rights reserved.
//

#import "GTMasterViewController.h"

#import "GTDetailViewController.h"

#import <Parse/Parse.h>

@interface GTMasterViewController ()
@property (strong) NSMutableArray *objects;
@end

@implementation GTMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)loadObjects
{
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu things.", (unsigned long)objects.count);
            self.objects = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadObjects];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (GTDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(loadObjects) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    [refresh beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PFObject *object = self.objects[indexPath.row];
    cell.textLabel.text = object[@"message"];
    if([object[@"public"] boolValue])
        cell.imageView.image = [UIImage imageNamed:@"public"];
    else
        cell.imageView.image = [UIImage imageNamed:@"private"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects[indexPath.row] deleteInBackground];
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
