//
//  XSMainWindow.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/ABPeoplePickerView.h>
#import "XSSkypeContact.h"
#import "XSContact.h"

@interface XSMainWindow : NSWindowController<XSSkypeContactDelegate> {
	NSArrayController *contactsArrayController;
	BOOL loading;
    NSView *peoplePickerView;
	XSSkypeContact *skypeContacts;
	NSDictionary *abDictionary;
    ABPeoplePickerView *peoplePicker;
    NSView *contentView;
    NSImageView *peoplePickerImageView;
}

@property (nonatomic, retain) IBOutlet NSArrayController *contactsArrayController;
@property (nonatomic, retain) XSSkypeContact *skypeContacts;
@property (nonatomic, assign) BOOL loading;
@property (retain) IBOutlet NSView *peoplePickerView;
@property (retain) IBOutlet ABPeoplePickerView *peoplePicker;
@property (retain) IBOutlet NSView *contentView;
@property (retain) IBOutlet NSImageView *peoplePickerImageView;


- (void) contactsAvailable:(NSArray *) contacts;
- (void) showPeoplePicker:(XSContact *) contact;
- (IBAction)setContact:(id)sender;
- (IBAction)cancelContact:(id)sender;

@end