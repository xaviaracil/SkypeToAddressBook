//
//  XSMainWindow.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSMainWindow.h"
#import "AppDelegate.h"

@interface XSMainWindow () 

@property (nonatomic, retain) NSDictionary *abDictionary;

@end

@implementation XSMainWindow

@synthesize contactsArrayController;
@synthesize loading;
@synthesize skypeContacts;
// private ivars
@synthesize abDictionary;

- (void)windowDidLoad {
	// create a dictionary from 
	AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
	
	NSArray *keys = [appDelegate.abContactsArray valueForKey:@"skypeName"];
	NSArray *values = [appDelegate.abContactsArray valueForKey:@"uniqueId"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	self.abDictionary = dictionary;
	[keys release]; // TODO: necessary??
	[values release]; // TODO: necessary??
	
	XSSkypeContact *xsSkypeContacts = [[XSSkypeContact alloc] init];
	self.skypeContacts = xsSkypeContacts;
	self.loading = YES;		
	[skypeContacts requestContacts];
	[xsSkypeContacts release];
}


- (void) dealloc
{
	[skypeContacts release];
	[contactsArrayController release];
	[super dealloc];
}

#pragma mark -
#pragma mark XSSkypeContactDelegate Methods
-(void) contactsAvailable:(NSArray *) contacts {
	// contacts contains an array of NSString's objects with skype names
	for (NSString *skypeName in contacts) {
		// TODO: chicha
		NSString *uniqueId = [abDictionary valueForKey:@"skypeName"];
	}
}

@end
