//
//  XeroParser.h
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"
#import "XeroResponse.h"
#import "XeroContact.h"
#import "XeroPhone.h"
#import "XeroAddress.h"


  
@interface XeroParser : XeroObject <NSXMLParserDelegate>

{
    id parserDelegate;
    NSMutableArray *contactList;
    NSMutableString *currentElementValue;
    XeroContact *contact;
    XeroPhone *phone;
    XeroAddress *address;
    XeroResponse *repsonse;
    
    XeroObject *currentObject;
    
}

@property (nonatomic) XeroResponse *response;

- (id) initParser: (id) delegate;

@end
