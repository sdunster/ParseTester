//
//  GTMasterViewController.h
//  ParseTester
//
//  Created by Samuel J. Dunster on 8/5/14.
//  Copyright (c) 2014 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTDetailViewController;

@interface GTMasterViewController : UITableViewController

@property (strong, nonatomic) GTDetailViewController *detailViewController;

@end