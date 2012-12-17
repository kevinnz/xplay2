//
//  XeroParser.m
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroParser.h"



@implementation XeroParser

@synthesize contactList;

- (id) initParser: (id) delegate {
    self = [self init];
    
    if (self) {
        parserDelegate = delegate;
        contactList = [[NSMutableArray alloc] init];
    }
    
    return self;
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString: @"Contact"]) {
        contact = [[XeroContact alloc] init];
        currentObject = contact;
        
    } else if ([elementName isEqualToString: @"Phone"]) {
        phone = [[XeroPhone alloc] init];
        currentObject = phone;
        
    } else if ([elementName isEqualToString: @"Address"]) {
        address = [[XeroAddress alloc] init];
        currentObject = address;
        
    }
    
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if (!currentElementValue) {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        [currentElementValue appendString:string];
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"Contact"]) {
        [contactList addObject:contact];
        contact = nil;
        
    } else if ([elementName isEqualToString:@"Phone"]) {
        [contact.phones addObject:phone];
        phone = nil;
        currentObject = contact;
        
    } else if ([elementName isEqualToString:@"Address"]) {
        [contact.addresses addObject:address];
        address = nil;
        currentObject = contact;
    
    } else if ([elementName isEqualToString:@"Addresses"]) {
        // end of group tag
    } else if ([elementName isEqualToString:@"Phones"]) {
        // end of group tag
    } else if ([elementName isEqualToString:@"Contacts"]) {
        // end of group tag
    } else if ([elementName isEqualToString:@"Response"]) {
        // end of group tag
    }


    else {
        @try {
            
            
            [currentObject setValue: [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        }
        @catch (NSException *exception) {
            NSLog(@"no property for %@", elementName);
        }
        @finally {
            // do nothing for now
        }
        
        
    }
    currentElementValue = nil;
}



@end
