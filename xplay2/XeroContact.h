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
    
}


@property (nonatomic) NSString *contactID;
@property (strong, nonatomic) NSMutableArray *addresses;
@property (strong, nonatomic) NSMutableArray *phones;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;

@end
