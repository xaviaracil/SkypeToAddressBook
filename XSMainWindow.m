//
//  XSMainWindow.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSMainWindow.h"
#import "AppDelegate.h"
#import "XSContact.h"

@interface XSMainWindow () 

@property (nonatomic, retain) NSDictionary *abDictionary;

-(XSContact *) contactWithSkypeName:(NSString *) skypeName;
-(void) deleteOldContacts:(NSArray *) currentContacts;
-(void) save;

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
	
	XSSkypeContact *xsSkypeContacts = [[XSSkypeContact alloc] init];
	self.skypeContacts = xsSkypeContacts;
	self.loading = YES;
    skypeContacts.delegate = self;
	[skypeContacts requestContacts];
	[xsSkypeContacts release];
}

- (void) dealloc
{
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

		NSString *uniqueId = [abDictionary valueForKey:@"skypeName"];
        
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
    
    // save context
    [self save];

    
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

-(void) save {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;
    NSError *error;
    if (![moc save:&error]) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }    
}
@end
