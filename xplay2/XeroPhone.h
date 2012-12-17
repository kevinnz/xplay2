//
//  XeroPhone.h
//  xplay2
//
//  Created by Kevin Alcock on 16/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "XeroObject.h"

@interface XeroPhone : XeroObject

{
    NSString *phoneType;
    NSString *phoneNumber;
    NSString *phoneAreaCode;
    NSString *phoneCountryCode;
    
}

@property (nonatomic) NSString *phoneType;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *phoneAreaCode;
@property (nonatomic) NSString *phoneCountryCode;





@end
