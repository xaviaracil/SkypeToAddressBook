//
//  SkypeToAddressBook_AppDelegate.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright xaracSoft (Xavi Aracil Diaz) 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSContact.h"

#define kXSMainWebsiteURL @"http://www.xadsolutions.com/skypetoaddressbook/"
#define kXSABPluginWebsiteURL @"http://www.xadsolutions.com/skypetoaddressbook/skypetoaddressbook-addressbook-plugin/"
#define kXSABPluginsDirectory @"Address Book Plug-Ins"
#define kXSABPluginName @"XSSkypePlugin.bundle"

@class XSMainWindow;

@interface AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	XSMainWindow *mainWindowController;
	
	// AddressBook Contacts array
	NSArray *abContactsArray;
	
	BOOL pluginInstalled;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) XSMainWindow *mainWindowController;

// AddressBook Contacts array
@property (nonatomic, retain) NSArray *abContactsArray;
@property (nonatomic, assign) BOOL pluginInstalled;

- (IBAction)saveAction:sender;
- (void)showPeoplePicker:(XSContact *)contact fromView:(NSView *) view;
- (IBAction)openWebsite:(id)sender;
- (IBAction)openPluginWebsite:(id)sender;
@end
