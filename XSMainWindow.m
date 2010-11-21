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

@interface XSMainWindow () 

@property (nonatomic, retain) NSDictionary *abDictionary;

-(XSContact *) contactWithSkypeName:(NSString *) skypeName;
-(void) deleteOldContacts:(NSArray *) currentContacts;
-(void) recordChanged:(NSNotification*)notification;
@end

@implementation XSMainWindow

@synthesize contactsArrayController;
@synthesize loading;
@synthesize skypeContacts;
@synthesize peoplePickerView;
@synthesize peoplePicker;
@synthesize contentView;
@synthesize peoplePickerImageView;

// private ivars
@synthesize abDictionary;

- (void)windowDidLoad {
	// create a dictionary from 
	AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
	
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
    
    // people picker
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    // Set up a responder for one of the four available notifications,
    // in this case to tell us when the selection in the people picker
    // has changed.
    [center addObserver:self
               selector:@selector(recordChanged:)
                   name:ABPeoplePickerNameSelectionDidChangeNotification
                 object:peoplePicker];
    
}

- (void) showPeoplePicker:(XSContact *) contact {   
    [self.contactsArrayController setSelectedObjects:[NSArray arrayWithObject:contact]];
    self.peoplePickerView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.peoplePickerView];
}

- (void)setContact:(id)sender {
    NSArray *array = [peoplePicker selectedRecords];
    NSAssert([array count] == 1,
             @"Picker returned multiple selected records");
    ABPerson *person = [array objectAtIndex:0];

    XSContact *contact = [[contactsArrayController selectedObjects] objectAtIndex:0];
    contact.uniqueID = [person uniqueId];

    [self.peoplePickerView removeFromSuperview];
}

- (void)cancelContact:(id)sender {
    [self.peoplePickerView removeFromSuperview];
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
	// contacts contains an array of NSString's objects with skype names
	for (NSString *skypeName in contacts) {

		NSString *uniqueId = [abDictionary valueForKey:skypeName];
        
        // fetch contact in Core Data
        // If it doesn't exits, create it
        // update AB contact, if so
        XSContact *xsContact = [self contactWithSkypeName:skypeName];
        if (xsContact) {
            xsContact.uniqueID = uniqueId;
        } else {
            // create a XSContact with uniqueId data
            AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
            NSManagedObjectContext *moc = appDelegate.managedObjectContext;            
            xsContact = [XSContact xsContactWithSkypeName:skypeName addressBookUniqueId:uniqueId context:moc];
        }        
	}
    
    // fetch contacts with skype name different than contacts and delete them
    [self deleteOldContacts:contacts];
    
    
    self.loading = NO;
}

#pragma mark -
#pragma mark Private Methods
-(XSContact *) contactWithSkypeName:(NSString *)skypeName {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"skypeName", skypeName];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // Maybe try to determine cause of error and recover first.
    return (!array || [array count] == 0) ? nil : [array objectAtIndex:0];
    
    // TODO: deal with error
}

-(void) deleteOldContacts:(NSArray *)currentContacts {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    
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
    [peoplePickerImageView setImage:contactImage];
    [contactImage release];
}
@end
