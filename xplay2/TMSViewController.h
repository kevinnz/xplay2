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

@interface TMSViewController : UIViewController <AuthorizeWebViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *findPersonButton;

@property (weak, nonatomic) IBOutlet UIButton *orgButton;
@property (weak, nonatomic) IBOutlet UIButton *connectToXero;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

- (IBAction)findAPerson:(id)sender;

- (IBAction) showOrg:(id)sender;
- (IBAction) connectToXero:(id)sender;
@end
