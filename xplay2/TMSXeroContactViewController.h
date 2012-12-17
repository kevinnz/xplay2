//
//  TMSXeroContactViewController.h
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XeroContact.h"

@interface TMSXeroContactViewController : UIViewController {
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *firstName;
    IBOutlet UILabel *lastName;
    IBOutlet UILabel *phoneNumber;
    
    
}
- (IBAction)saveToDevice:(id)sender;

@property (nonatomic, strong) XeroContact *contact;

@end
