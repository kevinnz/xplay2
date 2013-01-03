//
//  XeroResponse.m
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroResponse.h"

@implementation XeroResponse

@synthesize theId;
@synthesize status;
@synthesize providerName;
@synthesize dateTimeUTC;
@synthesize contactList;
@synthesize organisationList;

- (id) init {
    self = [super init];
    if (self) {
        contactList = [[NSMutableArray alloc] init];
        organisationList = [[NSMutableArray alloc] init];
    }
    
    return self;
    
}


@end
