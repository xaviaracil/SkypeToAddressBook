//
//  XSSkypeContact.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 18/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSSkypeContact.h"
#import <AddressBook/AddressBook.h>

@interface XSSkypeContact ()

//-(ABPerson *) findContactWithSkypeName:(NSString *) skypeContact;

@end

@implementation XSSkypeContact

@synthesize delegate;

-(void) requestContacts {
	// load contacts from Skype
	// -> SEARCH FRIENDS
	// <- USERS tim, joe, mike

	XSSkype *skype = [[XSSkype alloc] initWithAppName:@""];	
	[skype sendCommand:@"SEARCH FRIENDS" responder:self];	
}


#pragma mark -
#pragma mark Private Methods
/*
-(ABPerson *) findContactWithSkypeName:(NSString *) skypeContact {
	ABAddressBook *AB = [ABAddressBook sharedAddressBook];
	
	ABSearchElement *skypeContactAsGiven =
    [ABPerson searchElementForProperty:kXSSkypeProperty
                                 label:nil
                                   key:nil
                                 value:skypeContact
                            comparison:kABEqual];
	
	NSArray *peopleFound = [AB recordsMatchingSearchElement:skypeContactAsGiven];	
	if ([peopleFound count] > 0) {
		return [peopleFound objectAtIndex:0];
	}
	return NULL;
}*/

#pragma mark -
#pragma mark XSSkypeDelegate methods
-(void) response:(NSString *) response {
	NSMutableArray *result = [NSMutableArray array];
	
	
	NSScanner *theScanner = [NSScanner scannerWithString:response];
	NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
	
	if ([theScanner isAtEnd] == NO) {
		[theScanner scanString:kSkypeUsers intoString:NULL];
		
		NSMutableString *skypeContact;
		while ([theScanner isAtEnd] == NO) {
			[theScanner scanUpToCharactersFromSet:characterSet intoString:&skypeContact];
			
			// remove last ","
			if ([skypeContact hasSuffix:@","]) {				
				[skypeContact deleteCharactersInRange:NSMakeRange([skypeContact length] -1, 1)];
			}
			[result addObject:skypeContact];

		}
		[skypeContact release]; // TODO: necessary???
		
	}
	
	if ([delegate respondsToSelector:@selector(contactsAvailable:)]) {
		[delegate performSelector:@selector(contactsAvailable:) withObject:result];
	}	
}

@end
