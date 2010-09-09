//
//  XSMainWindow.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSSkypeContact.h"

@interface XSMainWindow : NSWindowController<XSSkypeContactDelegate> {
	NSArrayController *contactsArrayController;
	BOOL loading;
	XSSkypeContact *skypeContacts;
	NSDictionary *abDictionary;
}

@property (nonatomic, retain) IBOutlet NSArrayController *contactsArrayController;
@property (nonatomic, retain) XSSkypeContact *skypeContacts;
@property (nonatomic, assign) BOOL loading;

-(void) contactsAvailable:(NSArray *) contacts;

@end