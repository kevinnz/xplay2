//
//  TMSViewController.h
//  xplay2
//
//  Created by Kevin Alcock on 4/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AuthorizeWebViewController.h"
#import "XeroParser.h"


@interface TMSViewController : UIViewController <AuthorizeWebViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate> {
    XeroParser *xeroParser;
}

@property (weak, nonatomic) IBOutlet UIButton *findPersonButton;

@property (weak, nonatomic) IBOutlet UIButton *orgButton;
@property (weak, nonatomic) IBOutlet UIButton *connectToXero;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (nonatomic, strong) XeroParser *xeroParser;

- (IBAction)showXeroContacts:(id)sender;

- (IBAction)findAPerson:(id)sender;

- (IBAction) showOrg:(id)sender;
- (IBAction) connectToXero:(id)sender;
@end
