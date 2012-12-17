//
//  TMSXeroContactViewController.m
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "TMSXeroContactViewController.h"

@interface TMSXeroContactViewController ()

@end

@implementation TMSXeroContactViewController

@synthesize contact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    name.text = contact.name;
    firstName.text = contact.firstName;
    lastName.text = contact.lastName;
    phoneNumber.text = [contact getDefaultPhone];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveToDevice:(id)sender {
}
@end
