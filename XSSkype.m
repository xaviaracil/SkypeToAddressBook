//
//  XSSkype.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 07/11/09.
//  Copyright 2009 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSSkype.h"

@interface XSSkype ()

-(void) connect;

@end

@implementation XSSkype

@synthesize appName, delegate, connected;


- (void) connect {
	// load Skype
	if ([SkypeAPI isSkypeRunning] == NO) {
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"skype://"]];
	}
	
	// setting delegate
	[SkypeAPI setSkypeDelegate:self];
		
	// connecting
	[SkypeAPI connect];
}

- (id) initWithAppName:(NSString *) name
{
	self = [super init];
	if (self != nil) {
		connected = NO;
		appName = name;
		calls = [[NSMutableDictionary alloc] init];
		lastCallId = 0;
	}
	return self;
}

- (void) dealloc
{
	[calls release];
	[delegate release];
	[appName release];
	[super dealloc];
}

# pragma mark contacts
/*
- (void) fetchContacts {
	// connect to Skype
	if (connected == NO) {
		NSLog(@"Not connected to skype");
		return;
	}
	
	// load contacts from Skype
	// -> SEARCH FRIENDS
	// <- USERS tim, joe, mike

	// generate id
	
	// put id into call dictionary	
	// TODO: mirar
	XSSkypeFetchContactsResponder *action = [[XSSkypeFetchContactsResponder alloc] initWithDelegate:delegate];
	NSString *callId = [NSString stringWithFormat:@"#%d", lastCallId++];
	NSString *skypeCommand = [NSString stringWithFormat:@"%@ SEARCH FRIENDS", callId];
	[calls setObject:action forKey:callId];
	[SkypeAPI sendSkypeCommand: skypeCommand];	
}*/

-(void) sendCommand:(NSString *) command responder:(id<XSSkypeResponder>) responder {
	NSString *callId = [NSString stringWithFormat:@"#%d", lastCallId++];
	NSString *skypeCommand = [NSString stringWithFormat:@"%@ %@", callId, command];
	[calls setObject:responder forKey:callId];
	[SkypeAPI sendSkypeCommand: skypeCommand];	
}


# pragma mark Skype delegate methods
- (NSString*)clientApplicationName {
	return appName;
}

// This is the main delegate method Skype uses to send information to your application. 
// aNotificationString is a Skype API string as described in Skype API protocol documentation.
- (void)skypeNotificationReceived:(NSString*)aNotificationString {
	NSLog(@"Message from skype: %@", aNotificationString);
	// get identifier, if so
	if ([aNotificationString characterAtIndex:0] == '#') {
		NSScanner *theScanner = [NSScanner scannerWithString:aNotificationString];
		NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
		NSString *callId;
		NSString *response;
		if ([theScanner isAtEnd] == NO) {
			[theScanner scanUpToCharactersFromSet:characterSet intoString:&callId];
			response = [[theScanner string] substringFromIndex:[theScanner scanLocation]];
		}
		
		id responder = [calls objectForKey:callId];
		if ([responder conformsToProtocol:@protocol(XSSkypeResponder)]) {
			[responder response:response];
		}
	}	
}

// This method is called after Skype API client application has called connect. 
// aAttachResponseCode is 0 on failure and 1 on success.
- (void)skypeAttachResponse:(unsigned)aAttachResponseCode {
	if (aAttachResponseCode) {
		connected = YES;
		if ([delegate respondsToSelector:@selector(skypeDidConnect)]) {
			[delegate performSelector:@selector(skypeDidConnect)];
		}
	} else {
	}

}

// This method is called after Skype has been launched.
- (void)skypeBecameAvailable:(NSNotification*)aNotification {
	if (connected == NO) {
		[self connect];
	}
}

// This method is called after Skype has quit.
- (void)skypeBecameUnavailable:(NSNotification*)aNotification {
	NSLog(@"skypeBecameUnavailable");
}

@end
