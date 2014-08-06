//
//  GTCreateViewController.m
//  ParseTester
//
//  Created by Samuel J. Dunster on 8/5/14.
//  Copyright (c) 2014 Parse. All rights reserved.
//

#import "GTCreateViewController.h"
#import <Parse/Parse.h>

@interface GTCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@end

@implementation GTCreateViewController

- (IBAction)make:(id)sender {
    
    PFObject *object = [PFObject objectWithClassName:@"Message"];
    object[@"message"] = self.messageField.text;
    object[@"public"] = @(self.publicSwitch.on);
    
    if(!self.publicSwitch.on) {
        object.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    }
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            NSLog(@"Object inserted!");
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
