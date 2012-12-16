//
//  TMSXeroContactTableViewController.h
//  xplay2
//
//  Created by Kevin Alcock on 15/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "XeroParser.h"
#import "XeroContact.h"

@interface TMSXeroContactTableViewController : UITableViewController

{
    NSMutableArray *contactList;
    OAConsumer *consumer;
    OAToken *accessToken;
    XeroParser *xeroParser;
    XeroContact *contact;
}
    
@property ( nonatomic) OAConsumer *consumer;
@property ( nonatomic) OAToken *accessToken;

@property (nonatomic, strong) NSMutableArray *contactList;
@property (nonatomic, strong) XeroParser *xeroParser;
@property (nonatomic, strong) XeroContact *contact;


@end
