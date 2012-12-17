//
//  XeroPhone.m
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroPhone.h"

@implementation XeroPhone

@synthesize phoneType, phoneNumber, phoneAreaCode, phoneCountryCode;

-(NSString *) createXML {
    NSMutableString *xml = [[NSMutableString alloc] initWithString: @"<Phone>"] ;
    
    if (self.phoneType) {
        [xml appendFormat:@"<PhoneType>%@</PhoneType>", phoneType];
    }
    
    if (self.phoneNumber) {
        [xml appendFormat:@"<PhoneNumber>%@</PhoneNumber>", phoneNumber];
    }
    
    if (self.phoneAreaCode) {
        [xml appendFormat:@"<PhoneAreaCode>%@</PhoneAreaCode>", phoneAreaCode];
    }
    
    if (self.phoneCountryCode) {
        [xml appendFormat:@"<PhoneCountryCode>%@</PhoneCountryCode>", phoneCountryCode];
    }
    
    [xml appendString:@"</Phone>"];
    return [xml copy];
}

@end
