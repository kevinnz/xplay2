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



- (NSString *) getFullNumber {
    NSMutableString *fullNumber = [[NSMutableString alloc] init];
    
    if (phoneCountryCode) {
        [fullNumber appendString:phoneCountryCode];
        
    }
    
    if (phoneAreaCode) {

        if (fullNumber.length > 0) {
            [fullNumber appendString:@" "];
            
        }
        [fullNumber appendString:phoneAreaCode ];
    }
    
    if (phoneNumber) {
        
        if (fullNumber.length > 0) {
            [fullNumber appendString:@" "];
            
        }
        [fullNumber appendString:phoneNumber ];
    }
    
    return [fullNumber copy];
}

@end
