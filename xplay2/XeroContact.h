//
//  XeroContact.h
//  xplay2
//
//  Created by Kevin Alcock on 15/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XeroContact : NSObject
{
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;

@end
