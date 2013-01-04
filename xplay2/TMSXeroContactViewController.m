//
//  TMSXeroContactViewController.m
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <AddressBook/AddressBook.h>
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
    
    ABAddressBookRef addressBook;
    bool wantToSaveChanges = YES;
    bool didSave;
    CFErrorRef error = NULL;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    /* ... Work with the address book. ... */
    
    
    ABRecordRef aRecord = ABPersonCreate();
    CFErrorRef anError = NULL;
    bool didSet;
    
    //CFStringRef fName, lName;
    
    if (contact.firstName) {
        //CFStringRef cstrref=(__bridge CFStringRef)str;

        
        didSet = ABRecordSetValue(aRecord, kABPersonFirstNameProperty, (__bridge CFStringRef)contact.firstName, &anError);
        if (!didSet) {/* Handle error here. */}
    }
    if (contact.firstName) {
        didSet = ABRecordSetValue(aRecord, kABPersonLastNameProperty, (__bridge CFStringRef)contact.lastName , &anError);
        if (!didSet) {/* Handle error here. */}
    }
    
    if (contact.name) {
        didSet = ABRecordSetValue(aRecord, kABPersonOrganizationProperty,
                (__bridge CFStringRef)contact.name , &anError);
        if (!didSet) {/* Handle error here. */}
    }
    
    NSString *defaultPhone = [contact getDefaultPhone];
    
    if (defaultPhone) {
        
        ABMutableMultiValueRef multi =
        ABMultiValueCreateMutable(kABMultiStringPropertyType);

        ABMultiValueIdentifier multivalueIdentifier;
        bool didAdd;
        
        // Here, multivalueIdentifier is just for illustration purposes; it isn't
        // used later in the listing.  Real-world code can use this identifier to
        // reference the newly-added value.
        didAdd = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(defaultPhone) ,
                                              kABPersonPhoneMainLabel, &multivalueIdentifier);
        if (!didAdd) {/* Handle error here. */}
        
        
        
        //didAdd = ABMultiValueAddValueAndLabel(multi, @"(555) 555-2345", kABPersonPhoneMainLabel, &multivalueIdentifier);
        //if (!didAdd) {/* Handle error here. */}

        
        didSet = ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &anError);
        if (!didSet) {/* Handle error here. */}
        CFRelease(multi);
    }
    /*
    CFStringRef fName, lName;
    fName = ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
    lName  = ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
    */
    /* ... Do something with firstName and lastName. ... */
    
    
    
    didSet = ABAddressBookAddRecord(addressBook, aRecord, &error);

    
    CFRelease(aRecord);
    //CFRelease(fName);
    //CFRelease(lName);
      
    
    
    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        if (wantToSaveChanges) {
            didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave) {/* Handle error here. */}
        } else {
            ABAddressBookRevert(addressBook);
        }
    }
    
    
    
    
    CFRelease(addressBook);
    
}
@end
