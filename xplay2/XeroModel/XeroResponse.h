//
//  XeroResponse.h
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"

@interface XeroResponse : XeroObject {
    NSString *theId;
    NSString *status;
    NSString *providerName;
    NSString *dateTimeUTC;
    
    NSMutableArray *contactList;
    NSMutableArray *organisationList;
        
}
    
@property (nonatomic,strong) NSString *theId;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *providerName;
@property (nonatomic,strong) NSString *dateTimeUTC;
@property (nonatomic,strong) NSMutableArray *contactList;
@property (nonatomic,strong) NSMutableArray *organisationList;


@end
