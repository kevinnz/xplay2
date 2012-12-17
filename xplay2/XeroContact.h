//
//  XeroContact.h
//  xplay2
//
//  Created by Kevin Alcock on 15/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"
#import "XeroPhone.h"

@interface XeroContact : XeroObject
{
    NSString *contactID;
    NSMutableArray *addresses;
    NSMutableArray *phones;
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    
    NSString *isSupplier;
    NSString *isCustomer;
    NSString *updatedDateUTC;
    NSString *contactStatus;
    NSString *defaultCurrency;
    NSString *bankAccountDetails;
    NSString *taxNumber;
    NSString *emailAddress;
    NSString *skypeUserName;
    NSString *accountsReceivableTaxType;
    NSString *accountsPayableTaxType;
}


@property (nonatomic, strong) NSString *contactID;
@property (strong, nonatomic) NSMutableArray *addresses;
@property (strong, nonatomic) NSMutableArray *phones;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *isSupplier;
@property (nonatomic, strong) NSString *isCustomer;
@property (nonatomic, strong) NSString *updatedDateUTC;
@property (nonatomic, strong) NSString *contactStatus;
@property (nonatomic, strong) NSString *defaultCurrency;
@property (nonatomic, strong) NSString *bankAccountDetails;
@property (nonatomic, strong) NSString *taxNumber;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *skypeUserName;
@property (nonatomic, strong) NSString *accountsReceivableTaxType;
@property (nonatomic, strong) NSString *accountsPayableTaxType;


@end
