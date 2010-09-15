//
//  XSABContact.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 19/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kXSSkypeProperty @"com.xaracSoft.SkypeToAddressBook.skypeName"

@class ABPerson;

@interface XSABContact : NSObject {
	NSString *uniqueId;
	NSString *fullName;
	NSString *skypeName;
}

@property (nonatomic, copy) NSString *uniqueId;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *skypeName;

-(id) initWithPerson:(ABPerson *)person skypeProperty:(NSString *)skypeProperty;
+(NSString *) fullNameForPerson:(ABPerson *) person;

@end
