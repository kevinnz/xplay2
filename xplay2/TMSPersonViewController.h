//
//  TMSPersonViewController.h
//  xplay2
//
//  Created by Kevin Alcock on 5/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "OAuthConsumer.h"

@interface TMSPersonViewController : UIViewController < ABPeoplePickerNavigationControllerDelegate >

{
    OAConsumer *consumer;
    OAToken *accessToken;
}

@property ( nonatomic) OAConsumer *consumer;
@property ( nonatomic) OAToken *accessToken;

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;


@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UILabel *OrgLabel;

- (IBAction)sendToXero:(id)sender;


@property ( nonatomic) ABRecordRef *myPerson;

@end
