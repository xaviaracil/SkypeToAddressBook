//
//  XSContactView.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 17/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSContactView.h"
#import "XSContact.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>

@interface XSContactView()
-(void) displayAlert:(XSContact *) contact;
-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
       contextInfo:(void *)contextInfo;
@end

@implementation XSContactView
@synthesize editing;

-(void) removeContact:(id) sender{
	XSContact *contact = self.representedObject;
	
	if (contact.isInAddressBook) {
        // display a confirmation alert
        [self displayAlert:contact];
	} else {
		self.editing = YES;
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];        
        [appDelegate showPeoplePicker:self.representedObject fromView:sender];
	}
}

#pragma mark -
#pragma mark Private Methods
-(void) displayAlert:(XSContact *) contact {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];    
    [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    [alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"delete message", @"Delete message with two params"), contact.name, contact.skypeName]];
    [alert setInformativeText:NSLocalizedString(@"Disconnected contacts cannot be restored.", @"Disconnected contacts cannot be restored.")];
    [alert setAlertStyle:NSWarningAlertStyle];

    [alert beginSheetModalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        XSContact *contact = self.representedObject;
        contact.uniqueID = NULL;   

        // save AddressBook changes
        [[ABAddressBook sharedAddressBook] save];
    }
}

@end
