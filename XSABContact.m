//
//  XSABContact.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 19/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSABContact.h"
#import <AddressBook/AddressBook.h>

@implementation XSABContact

@synthesize uniqueId;
@synthesize fullName;
@synthesize skypeName;

-(id) initWithPerson:(ABPerson *)person skypeProperty:(NSString *)skypeProperty {
	self = [super init];
	if (self != nil) {
		self.uniqueId = [person uniqueId];
		self.fullName = [NSString stringWithFormat:@"%@ %@", 
						 [person valueForProperty:kABFirstNameProperty], 
						 [person valueForProperty:kABLastNameProperty]];
		self.skypeName = [person valueForProperty:skypeProperty];
	}
	return self;
}	


@end
