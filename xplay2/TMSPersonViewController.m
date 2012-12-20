//
//  TMSPersonViewController.m
//  xplay2
//
//  Created by Kevin Alcock on 5/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "TMSPersonViewController.h"

@interface TMSPersonViewController ()

@end

@implementation TMSPersonViewController {
    NSMutableString *xml;
    NSString *name;
    NSString *lname;
    NSString *cname;
    NSString *phone;
}

@synthesize myPerson;
@synthesize phoneNumber;
@synthesize firstName;
@synthesize consumer;
@synthesize accessToken;
@synthesize sendButton;


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
    
    
    [self pickPerson];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pickPerson
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker
	[self presentViewController:picker animated:YES completion:nil];

}

- (void) showPerson: (ABRecordRef)person {
    name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);

    lname = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonLastNameProperty);
    
    cname = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                     kABPersonOrganizationProperty);
    
    NSLog(@"company=%@", cname);

    self.firstName.text = [[NSString alloc] initWithFormat:@"%@ %@", name, lname];
    self.OrgLabel.text = cname;
    
    phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.phoneNumber.text = phone;
    
    self.myPerson = &person;
}



#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    NSLog(@"person=%@", person);
    
    [self showPerson:person];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

    
    
    
	return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}



- (IBAction)sendToXero:(id)sender {
    
    [self doContact];

}

- (void) doOrg {
    
    NSLog(@"show org");
    
    if (!accessToken) {
        NSLog(@"accessToken is nil");
        return;
    }
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/api.xro/2.0/Organisation"];
    OAMutableURLRequest *orequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                           signatureProvider:nil];
    
      
    [orequest setParameters:@[]];
    
    [orequest setHTTPMethod:@"GET"];
    
    [orequest prepare];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:orequest
                         delegate:self
                didFinishSelector:@selector(apiContact:didFinishWithData:)
                  didFailSelector:@selector(apiContact:didFailWithError:)];
    
}
    
    
    
- (void) doContact {
    if (!accessToken) {
        NSLog(@"accessToken is nil");
        return;
    }
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/api.xro/2.0/Contacts"];
    OAMutableURLRequest *orequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                           signatureProvider:nil];
    
    
    [orequest setParameters:@[]];
    
    [orequest setHTTPMethod:@"POST"];
    [orequest prepare];
    
    //NSString *payload = @"<Contact><Name>ABC Limited</Name></Contact>";
    
    NSString *payload = [self createPayload];
    
    NSLog(@"out=%@", payload);
    //NSLog(@"190=%@", [payload substringFromIndex: 190]);
    NSData *rawPayload = [ NSData dataWithBytes: [ payload UTF8String ] length: [ payload length ] ];
    
    //[payload dataUsingEncoding: NSUTF8StringEncoding ];
    //NSLog(@"out=%@", [[NSString alloc] in[rawPayload );
    
    [orequest setHTTPBody: rawPayload];
    
    [orequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSError *anError = nil;
    
    NSURLResponse* response;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:orequest returningResponse:&response error:&anError];
    
    if (data == nil || anError != nil) {
        NSLog(@"Something went wrong: %@", anError);
    }
    
    NSLog(@"===============");
    NSLog(@"data=%@", data);
    
    
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseBody);
    
    self.sendButton.enabled = NO;
    
    /*
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:orequest
                         delegate:self
                didFinishSelector:@selector(apiContact:didFinishWithData:)
                  didFailSelector:@selector(apiContact:didFailWithError:)];
     
     */
    
}



- (void)apiContact:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"apiContact Sucess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseBody);
        
        self.sendButton.enabled = NO;
       
    }
}

- (void)apiContact:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (NSMutableString *) createPayload {
    NSMutableString *payload = [[NSMutableString alloc] init];
    
    [payload appendString:@"<Contact>"];
    
    if (cname) {
        [payload appendFormat:@"<Name>%@</Name>", cname];
    } else {
        [payload appendFormat:@"<Name>%@ %@</Name>", name ? name : @"", lname ? lname : @""];
    }
    
    if (name) {
        [payload appendFormat:@"<FirstName>%@</FirstName>", name];
    }
    
    if (lname) {
        [payload appendFormat:@"<LastName>%@</LastName>", lname];
    }
    
    
    if (![phone isEqual:@"[None]"]) {
         [payload appendFormat:@"<Phones><Phone><PhoneType>DEFAULT</PhoneType><PhoneNumber>%@</PhoneNumber></Phone></Phones>", phone];
      
    }
    
    [payload appendString:@"</Contact>"];

    return payload;

}

@end
