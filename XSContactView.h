//
//  XSContactView.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 17/08/10.
//  Copyright 2010 xaracSoft (Xavi Aracil Diaz). All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface XSContactView : NSCollectionViewItem {
	BOOL editing;
}

@property (nonatomic, assign) BOOL editing;

-(IBAction) removeContact:(id) sender;
-(IBAction) confirmContact:(id) sender;

@end
