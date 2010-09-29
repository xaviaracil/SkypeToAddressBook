//
//  XSContactView.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 17/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import "XSContactView.h"
#import "XSContact.h"

@implementation XSContactView
@synthesize editing;

-(void) removeContact:(id) sender{
	XSContact *contact = self.representedObject;
	
	if (contact.isInAddressBook) {
        contact.uniqueID = NULL;
	} else {
		self.editing = YES;
	}
}

-(void) confirmContact:(id) sender {
    // TODO chicha
}

@end
