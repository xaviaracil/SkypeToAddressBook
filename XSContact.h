//
//  XSContact.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 16/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XSABContact;

@interface XSContact : NSManagedObject {
	// attributes
	NSString *skypeName;
	NSString *uniqueID;
	
	// non-modeled attributes
	NSImage *photo;
	NSString *name;
}

// attributes
@property (nonatomic, retain) NSString *skypeName;
@property (nonatomic, retain) NSString *uniqueID;

// non-modeled attributes
@property (nonatomic, readonly) BOOL isInAddressBook;
@property (nonatomic, retain) NSImage *photo;
@property (nonatomic, retain) NSString *name;

-(void) fillFromABContact:(XSABContact *) contact;
-(void) removeABContact;
@end
