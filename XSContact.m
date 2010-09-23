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
-(void) setTransientProperties;
-(void) configureWithSkypeName:(NSString *) skypeName addressBookContact:(NSString *) uniqueId;
@end

#pragma mark -
#pragma mark Public implementation

@implementation XSContact

@dynamic skypeName;
@dynamic uniqueID;
@dynamic editing;

@synthesize photo;
@synthesize name;

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

+ (id) xsContactWithSkypeName:(NSString *) skypeName addressBookUniqueId:(NSString *) uniqueId context:(NSManagedObjectContext *) context {
    XSContact *newItem;
    newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    
    // configure
    [newItem configureWithSkypeName:skypeName addressBookContact:uniqueId];

    return newItem;
}

-(void) configureFromAddressBookContact:(NSString *) uniqueId {
	self.uniqueID = uniqueId;	
    [self setTransientProperties];
}

-(void) removeABContact {
	self.uniqueID = NULL;
	self.photo = [[self class] defaultPhotoForUsersNotInAddressBook];
	self.name = self.skypeName;
}

#pragma mark -
#pragma mark Private Methods
-(void) awakeFromFetch {
    [super awakeFromFetch];    
    [self setTransientProperties];
}

-(void) setTransientProperties {
    NSImage *contactImage = NULL;
    NSString *fullName = NULL;

	if (self.uniqueID) {
        ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
        ABPerson *record = (ABPerson *) [addressBook recordForUniqueId:self.uniqueID];    
        contactImage = [[[NSImage alloc] initWithData: [record imageData]] autorelease];
        fullName = [XSABContact fullNameForPerson:record];
    } else {
        contactImage = [[self class] defaultPhoto];
        fullName = @" ";
    }

	// image
    [self willChangeValueForKey:@"photo"];
    self.photo = contactImage ? contactImage : [[self class] defaultPhoto];
    [self didChangeValueForKey:@"photo"];
	
	// name
    [self willChangeValueForKey:@"name"];
    self.name = [fullName isEqualToString:@" "] ? self.skypeName : fullName;
    [self didChangeValueForKey:@"name"];
}

-(void) configureWithSkypeName:(NSString *) aSkypeName addressBookContact:(NSString *) uniqueId {
    self.skypeName = aSkypeName;
    self.uniqueID = uniqueId;
    [self setTransientProperties];
}

+(NSImage *) defaultPhoto {
	return [NSImage imageNamed:NSImageNameUser];
}

+(NSImage *) defaultPhotoForUsersNotInAddressBook {
	return [NSImage imageNamed:@"PersonSquare"];
}
@end
