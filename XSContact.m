//
//  XSContact.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSContact.h"
#import "XSABContact.h"
#import <AddressBook/AddressBook.h>

#pragma mark Private Methods

@interface XSContact () 

+(NSImage *) defaultPhoto;
+(NSImage *) defaultPhotoForUsersNotInAddressBook;

@end

#pragma mark -
#pragma mark Public implementation

@implementation XSContact

@dynamic skypeName;
@dynamic uniqueID;

@synthesize photo;
@synthesize name;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.photo = [[self class] defaultPhotoForUsersNotInAddressBook];
	}
	return self;
}

- (void) dealloc {
	[photo release];
	[name release];
	[super dealloc];
}

#pragma mark -
#pragma mark Non-modeled attributes

-(BOOL) isInAddressBook {
	return self.uniqueID != NULL;
}

+ (id) xsContactWithAddressBookUniqueId:(NSString *) uniqueId context:(NSManagedObjectContext *) context {
    XSContact *newItem;
    newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    
    // configure
    if (uniqueId) {
        [newItem configureFromAddressBookContact:uniqueId];
    }
    return newItem;
}

-(void) configureFromAddressBookContact:(NSString *) uniqueId {
	self.uniqueID = uniqueId;
	
	// image
	ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
	ABPerson *record = (ABPerson *) [addressBook recordForUniqueId:self.uniqueID];
	NSImage *contactImage = [[NSImage alloc] initWithData: [record imageData]];
	self.photo = contactImage ? contactImage : [[self class] defaultPhoto];
	[contactImage release];
	
	// name
	//self.name = [contact.fullName isEqualToString:@" "] ? self.skypeName : contact.fullName;
    NSString *fullName = [XSABContact fullNameForPerson:record];
    self.name = [fullName isEqualToString:@" "] ? self.skypeName : fullName;
}

-(void) removeABContact {
	self.uniqueID = NULL;
	self.photo = [[self class] defaultPhotoForUsersNotInAddressBook];
	self.name = self.skypeName;
}

#pragma mark -
#pragma mark Private Methods
+(NSImage *) defaultPhoto {
	return [NSImage imageNamed:NSImageNameUser];
}

+(NSImage *) defaultPhotoForUsersNotInAddressBook {
	return [NSImage imageNamed:@"PersonSquare"];
}
@end
