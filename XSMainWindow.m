//
//  XSMainWindow.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSMainWindow.h"
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import "XSContact.h"
#import "XSMainWindow-animation.h"

@interface XSMainWindow () 

@property (nonatomic, retain) NSDictionary *abDictionary;

-(XSContact *) contactWithSkypeName:(NSString *) skypeName;
-(void) deleteOldContacts:(NSArray *) currentContacts;
-(void) recordChanged:(NSNotification*)notification;
-(void) setContactAnimationDidEnd;

@end

@implementation XSMainWindow

@synthesize contactsArrayController;
@synthesize loading;
@synthesize skypeContacts;
@synthesize peoplePickerView;
@synthesize peoplePicker;
@synthesize contentView;
@synthesize peoplePickerImageView;
@synthesize scrollView;
@synthesize sortDescriptors;

// private ivars
@synthesize abDictionary;
@synthesize animationArray;
@synthesize selectedContactImageView;

- (void)windowDidLoad {
	// create a dictionary from 
	AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
	
	NSArray *keys = [appDelegate.abContactsArray valueForKey:@"skypeName"];
	NSArray *values = [appDelegate.abContactsArray valueForKey:@"uniqueId"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	self.abDictionary = dictionary;
    NSLog(@"AbDictionary: %@", self.abDictionary);
	
	XSSkypeContact *xsSkypeContacts = [[XSSkypeContact alloc] init];
	self.skypeContacts = xsSkypeContacts;
	self.loading = YES;
    skypeContacts.delegate = self;
	[skypeContacts requestContacts];
	[xsSkypeContacts release];
        
    // sort descriptors
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortArray = [NSArray arrayWithObject:sort];
    self.sortDescriptors = sortArray;
}

- (void) showPeoplePicker:(XSContact *) contact fromView:(NSView *) view {
    // people picker
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    // Set up a responder for one of the four available notifications,
    // in this case to tell us when the selection in the people picker
    // has changed.
    [center addObserver:self
               selector:@selector(recordChanged:)
                   name:ABPeoplePickerNameSelectionDidChangeNotification
                 object:peoplePicker];

    
    [self.contactsArrayController setSelectedObjects:[NSArray arrayWithObject:contact]];    
    NSRect viewFrame = [view frame];    
    NSRect frame = [contentView convertRect:viewFrame fromView:[view superview]];    
    animationDidEndSelector = NULL;
    [self animateShowPeoplePicker:frame];
    [peoplePickerImageView setImage:[NSImage imageNamed:@"PersonSquare"]];
}

- (void)setContact:(id)sender {
    // remove notification
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ABPeoplePickerNameSelectionDidChangeNotification object:peoplePicker];
    
    animationDidEndSelector = @selector(setContactAnimationDidEnd);
    [self animateHidePeoplePicker];
}

- (void)cancelContact:(id)sender {
    [scrollView setHidden:NO];
    [peoplePickerView setHidden:YES];
}

- (void) dealloc
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    [peoplePickerView release];    
    [peoplePicker release];
    [contentView release];
	[skypeContacts release];
	[contactsArrayController release];
    [abDictionary release];
	[super dealloc];
}

#pragma mark -
#pragma mark XSSkypeContactDelegate Methods
-(void) contactsAvailable:(NSArray *) contacts { 
    NSLog(@"contactsAvailable: Start");
    
	// contacts contains an array of NSString's objects with skype names
	for (NSString *skypeName in contacts) {

        NSLog(@"Processing skypeName %@: Start", skypeName);
		NSString *uniqueId = [abDictionary valueForKey:skypeName];
        
        // fetch contact in Core Data
        // If it doesn't exits, create it
        // update AB contact, if so
        NSLog(@"Looking for contact with skypeName %@: Start", skypeName);
        XSContact *xsContact = [self contactWithSkypeName:skypeName];
        NSLog(@"Looking for contact with skypeName %@: End", skypeName);
        if (xsContact) {
            xsContact.uniqueID = uniqueId;
        } else {
            // create a XSContact with uniqueId data
            NSLog(@"Creating a contact with skypeName %@: Start", skypeName);
            AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
            NSManagedObjectContext *moc = appDelegate.managedObjectContext;            
            [XSContact xsContactWithSkypeName:skypeName addressBookUniqueId:uniqueId context:moc];
            NSLog(@"Creating a contact with skypeName %@: End", skypeName);
        }        
        NSLog(@"Processing skypeName %@: End", skypeName);
	}
        
    // fetch contacts with skype name different than contacts and delete them
    // TODO optimize
    [self deleteOldContacts:contacts];    
    
    // release delegate method
    self.skypeContacts.delegate = nil;        
    self.loading = NO;
    //    [skypeNamesDictionary release];
    NSLog(@"contactsAvailable: End");
}

#pragma mark -
#pragma mark Private Methods
-(XSContact *) contactWithSkypeName:(NSString *)skypeName {
    /*
    if (!skypeNamesDictionary) {        
        NSLog(@"Creating skypeNamesDictionary: Begin");
        NSArray *objects = [self.contactsArrayController arrangedObjects];
        NSArray *keys = [objects valueForKey:@"skypeName"];
        skypeNamesDictionary = [[NSDictionary dictionaryWithObjects:objects forKeys:keys] retain];
        NSLog(@"skypeNamesDictionary: %@", skypeNamesDictionary);
        NSLog(@"Creating skypeNamesDictionary: End");
    }

    return [skypeNamesDictionary valueForKey:skypeName];
     */

    // TODO fetch all contacts in a NSDictionary and look at that dictionary
    // This should improve fetch time down to #contacts
    NSArray *contacts = [self.contactsArrayController arrangedObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.skypeName == %@", skypeName];
    NSArray *filteredArray = [contacts filteredArrayUsingPredicate:predicate];
    return ([filteredArray count] == 0) ? nil : [filteredArray objectAtIndex:0];
}

-(void) deleteOldContacts:(NSArray *)currentContacts {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;

    // fetch contacts with skype name different than contacts
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL (id evaluatedObject, NSDictionary *bindings){
        return [currentContacts containsObject:[evaluatedObject valueForKey:@"skypeName"]] == NO;
    }];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // TODO: deal with error

    // delete them
    [array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        [moc deleteObject:object]; 
    }];
}


-(void) recordChanged:(NSNotification*)notification {
    NSArray *array = [peoplePicker selectedRecords];
    NSAssert([array count] == 1,
             @"Picker returned multiple selected records");
    ABPerson *person = [array objectAtIndex:0];
    
    NSImage *contactImage = [[NSImage alloc] initWithData: [person imageData]];
    if (!contactImage)
        contactImage = [[NSImage imageNamed:NSImageNameUser] retain];
    [peoplePickerImageView setImage:contactImage];
    [contactImage release];
}

-(void) setContactAnimationDidEnd {
    NSArray *array = [peoplePicker selectedRecords];
    NSAssert([array count] == 1,
             @"Picker returned multiple selected records");
    ABPerson *person = [array objectAtIndex:0];
    
    XSContact *contact = [[contactsArrayController selectedObjects] objectAtIndex:0];
    contact.uniqueID = [person uniqueId];
}
@end
