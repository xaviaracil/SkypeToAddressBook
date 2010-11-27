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
        //NSRect frame = [[self view] frame];
        //NSRect baseFrame = [[self view] convertRectToBase:frame];
        [appDelegate showPeoplePicker:self.representedObject fromView:sender];
        //[appDelegate showPeoplePicker:self.representedObject initialFrame:baseFrame];
	}
}

#pragma mark -
#pragma mark Private Methods
-(void) displayAlert:(XSContact *) contact {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:[NSString stringWithFormat:@"Disconnect contact %@ from skype user %@?", contact.name, contact.skypeName]];
    [alert setInformativeText:@"Disconnected contacts cannot be restored."];
    [alert setAlertStyle:NSWarningAlertStyle];

    [alert beginSheetModalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        XSContact *contact = self.representedObject;
        contact.uniqueID = NULL;    
    }
}

@end
