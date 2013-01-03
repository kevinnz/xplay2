//
//  XeroAddress.h
//  xplay2
//
//  Created by Kevin Alcock on 17/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"

@interface XeroAddress : XeroObject {
    
    NSString *addressType;
    NSString *addressLine1;
    NSString *addressLine2;
    NSString *addressLine3;
    NSString *addressLine4;
    NSString *city;
    NSString *region;
    NSString *postalCode;
    NSString *country;
    NSString *attentionTo;
}


@property (nonatomic,strong) NSString *addressType;
@property (nonatomic,strong) NSString *addressLine1;
@property (nonatomic,strong) NSString *addressLine2;
@property (nonatomic,strong) NSString *addressLine3;
@property (nonatomic,strong) NSString *addressLine4;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *postalCode;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *attentionTo;


@end
