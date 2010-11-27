//
//  XSMainWindow-animation.h
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 24/11/10.
//  Copyright 2010 Tecsidel, S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSMainWindow.h"

@interface XSMainWindow (XSMainWindow_animation)

-(void) animateShowPeoplePicker:(NSRect)contactFrame;
-(void) animateHidePeoplePicker;

@end
