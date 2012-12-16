//
//  XeroPhone.m
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroPhone.h"

@implementation XeroPhone

@synthesize type, number, areaCode, countryCode;

-(NSString *) createXML {
    NSMutableString *xml = [[NSMutableString alloc] initWithString: @"<Phone>"] ;
    
    if (self.type) {
        [xml appendFormat:@"<PhoneType>%@</PhoneType>", type];
    }
    
    if (self.number) {
        [xml appendFormat:@"<PhoneNumber>%@</PhoneNumber>", number];
    }
    
    if (self.areaCode) {
        [xml appendFormat:@"<PhoneAreaCode>%@</PhoneAreaCode>", areaCode];
    }
    
    if (self.countryCode) {
        [xml appendFormat:@"<PhoneCountryCode>%@</PhoneCountryCode>", countryCode];
    }
    
    [xml appendString:@"</Phone>"];
    return [xml copy];
}

@end
