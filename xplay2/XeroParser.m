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
        
    } else if ([elementName isEqualToString:@"Phones"]) {
        
    } else if ([elementName isEqualToString:@"Addresses"]) {
    
    }

    else {
        @try {
            [contact setValue: [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
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
