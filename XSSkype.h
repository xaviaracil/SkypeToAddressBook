//
//  XSSkype.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 07/11/09.
//  Copyright 2009 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Skype/Skype.h>

@protocol XSSkypeDelegate <NSObject>

-(void) skypeDidConnect;
-(void) contactsAvailable:(NSArray *) contacts; 

@end

@protocol XSSkypeResponder <NSObject>

-(void) response:(NSString *) response;

@end

@interface XSSkype : NSObject<SkypeAPIDelegate> {
	BOOL connected;
	NSString *appName;

	id<XSSkypeDelegate> delegate;	
	NSMutableDictionary *calls;
	NSInteger lastCallId;
}

@property(readonly) BOOL connected;
@property(copy) NSString *appName;
@property(retain) id<XSSkypeDelegate> delegate;

-(id) initWithAppName:(NSString *) name;
-(void) sendCommand:(NSString *) command responder:(id<XSSkypeResponder>) responder;

@end
