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
    NSString *type;
    NSString *number;
    NSString *areaCode;
    NSString *countryCode;
    
}

@property (nonatomic) NSString *type;
@property (nonatomic) NSString *number;
@property (nonatomic) NSString *areaCode;
@property (nonatomic) NSString *countryCode;





@end
