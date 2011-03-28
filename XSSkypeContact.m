//
//  XSSkypeContact.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 18/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSSkypeContact.h"
#import <AddressBook/AddressBook.h>

@implementation XSSkypeContact

@synthesize skype, delegate;

-(void) requestContacts {
	// load contacts from Skype
	// -> SEARCH FRIENDS
	// <- USERS tim, joe, mike
    XSSkype *skypeProxy = [[XSSkype alloc] initWithAppName:@"SkypeToAddressBook"];	
    skypeProxy.delegate = self;
    self.skype = skypeProxy;
    [skype connect];
    [skypeProxy release];
}

- (void)dealloc {
    [skype release];
    [delegate release];
    [super dealloc];
}
#pragma mark -
#pragma mark XSSkypeDelegate methods
-(void) skypeDidConnect {
	[skype sendCommand:@"SEARCH FRIENDS" responder:self];	    
}

-(void) skypeDidFailConnect {
    if ([delegate respondsToSelector:@selector(skypeFailToFetchContacts)]) {
        [delegate performSelector:@selector(skypeFailToFetchContacts)];
    }
}

-(void) skypeIsNotInstalled {
    if ([delegate respondsToSelector:@selector(skypeIsNotInstalled)]) {
        [delegate performSelector:@selector(skypeIsNotInstalled)];
    }    
}

#pragma mark -
#pragma mark XSSkypeResponder methods
-(void) response:(NSString *) response {
	NSMutableArray *result = [NSMutableArray array];
	
	
	NSScanner *theScanner = [NSScanner scannerWithString:response];
	NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
	
	if ([theScanner isAtEnd] == NO) {
		[theScanner scanString:kSkypeUsers intoString:NULL];
		
		NSString *skypeContact;
		while ([theScanner isAtEnd] == NO) {
			[theScanner scanUpToCharactersFromSet:characterSet intoString:&skypeContact];
			            
			// remove last ","
			if ([skypeContact hasSuffix:@","]) {
				NSMutableString *mutableString = [NSMutableString stringWithString:skypeContact];
				[mutableString deleteCharactersInRange:NSMakeRange([mutableString length] -1, 1)];
                [result addObject:mutableString];
			} else {
                [result addObject:skypeContact];
            }

		}
		
	}
	
	if ([delegate respondsToSelector:@selector(contactsAvailable:)]) {
		[delegate performSelector:@selector(contactsAvailable:) withObject:result];
	}	
}

@end
