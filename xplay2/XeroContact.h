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
    
}


@property (nonatomic, strong) NSString *contactID;
@property (strong, nonatomic) NSMutableArray *addresses;
@property (strong, nonatomic) NSMutableArray *phones;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *isSupplier;
@property (nonatomic, strong) NSString *isCustomer;

@end
