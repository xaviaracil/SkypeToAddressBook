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
-(void) setTransientProperties;
-(void) configureWithSkypeName:(NSString *) skypeName addressBookContact:(NSString *) uniqueId;
@end

@interface XSContact (PrimitiveAccessors)
- (void)setPrimitiveUniqueID:(NSString *)newUniqueID;
@end

#pragma mark -
#pragma mark Public implementation

@implementation XSContact

@dynamic skypeName, uniqueID;

@synthesize photo;
@synthesize name;

- (void) dealloc {
	[photo release];
	[name release];
	[super dealloc];
}

- (void) setUniqueID:(NSString *)newUniqueID {
    [self willChangeValueForKey:@"uniqueID"];    
    
    // update address book record
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    if(self.uniqueID) {
        ABPerson *record = (ABPerson *) [addressBook recordForUniqueId:self.uniqueID];    
        [record removeValueForProperty:kXSSkypeProperty];
    }

    [self setPrimitiveUniqueID:newUniqueID];
    
    if(newUniqueID) {
        ABPerson *record = (ABPerson *) [addressBook recordForUniqueId:self.uniqueID];
        [record setValue:self.skypeName forProperty:kXSSkypeProperty];
    }
    
    
    [self didChangeValueForKey:@"uniqueID"];
    [self setTransientProperties];
}

+(NSImage *) defaultPhotoForUsersNotInAddressBook {
	return [NSImage imageNamed:@"PersonSquare"];
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
        contactImage = [[self class] defaultPhotoForUsersNotInAddressBook];
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
@end
