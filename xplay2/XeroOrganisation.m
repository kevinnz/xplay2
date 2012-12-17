//
//  XeroOrganisation.m
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroOrganisation.h"

@implementation XeroOrganisation

@synthesize name;

- (NSString *) createXML {
    
    NSMutableString *xml = [[NSMutableString alloc] initWithString: @"<Organisation>"] ;
    
    
    if (self.name) {
        [xml appendFormat:@"<Name>%@</Name>", name];
    }
    
    [xml appendString:@"</Organisation>"];
    return [xml copy];
    
    
}

@end
