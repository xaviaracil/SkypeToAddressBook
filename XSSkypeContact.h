//
//  XSSkypeContact.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 18/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSSkype.h"

#define kSkypeUsers @"USERS" 

@protocol XSSkypeContactDelegate <NSObject>

-(void) contactsAvailable:(NSArray *) contacts; 

@end

@interface XSSkypeContact : NSObject<XSSkypeResponder, XSSkypeDelegate> {
    XSSkype *skype;
	id<XSSkypeContactDelegate> delegate;	
}

@property(nonatomic, retain) XSSkype *skype;
@property(nonatomic, retain) id<XSSkypeContactDelegate> delegate;

-(void) requestContacts;
-(void) response:(NSString *) response;

@end
