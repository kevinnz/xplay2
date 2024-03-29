//
//  XeroContact.m
//  xplay2
//
//  Created by Kevin Alcock on 15/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroContact.h"

@implementation XeroContact

@synthesize name, firstName, lastName;
@synthesize contactID;
@synthesize addresses;
@synthesize phones;

@synthesize isCustomer;
@synthesize isSupplier;
@synthesize updatedDateUTC;
@synthesize contactStatus;
@synthesize defaultCurrency;
@synthesize bankAccountDetails;
@synthesize taxNumber;
@synthesize emailAddress;
@synthesize skypeUserName;
@synthesize accountsReceivableTaxType;
@synthesize accountsPayableTaxType;

- (id) init {
    self = [super init];
    if (self) {
        addresses = [[NSMutableArray alloc] init];
        phones = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSString *) createXML {
    
    NSMutableString *xml = [[NSMutableString alloc] initWithString: @"<Contact>"] ;
    
    if (self.contactID) {
        [xml appendFormat:@"<ContactID>%@</ContactID>", contactID];
    }
    
    if (self.name) {
        [xml appendFormat:@"<Name>%@</Name>", name];
    }
    
    if (self.firstName) {
        [xml appendFormat:@"<FirstName>%@</FirstName>", firstName];
    }
    
    if (self.lastName) {
        [xml appendFormat:@"<LastName>%@</LastName>", lastName];
    }
    
    if (self.phones && self.phones.count > 0) {
        [xml appendString:@"<Phones>"];
        for (XeroPhone* phone in self.phones) {
            [xml appendString: [phone createXML]];
        }
    }
    
    if (self.isCustomer) {
        [xml appendFormat:@"<IsCustomer>%@</IsCustomer>", isCustomer];
    }
    
    if (self.isSupplier) {
        [xml appendFormat:@"<IsSupplier>%@</IsSupplier>", isSupplier];
    }
    
    
    [xml appendString:@"</Contact>"];
    return [xml copy];
    
    
}

- (NSString *) getDefaultPhone {
    
    for (XeroPhone* phone in phones) {
        if ([phone.phoneType isEqualToString:@"DEFAULT"]) {
            return [phone getFullNumber];
        }
    }
    
    return nil;
}

@end
