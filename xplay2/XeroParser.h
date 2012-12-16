//
//  XeroParser.h
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"
#import "XeroContact.h"


  
@interface XeroParser : XeroObject <NSXMLParserDelegate>

{
    id parserDelegate;
    NSMutableArray *contactList;
    NSMutableString *currentElementValue;
    XeroContact *contact;
    
}

@property (nonatomic) NSMutableArray *contactList;

- (id) initParser: (id) delegate;

@end
