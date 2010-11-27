//
//  XSMainWindow-animation.m
//  SkypeToAddressBook
//
//  Created by Xavi Aracil on 24/11/10.
//  Copyright 2010 xadSolutions All rights reserved.
//

#import "XSMainWindow-animation.h"


@implementation XSMainWindow (XSMainWindow_animation) 

#pragma mark -
#pragma mark Animation initialization (Show)

// zoom in contact image
-(NSAnimation *) zoomInContactImageAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    NSRect destRect, origFrame, destFrame;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:selectedContactImageView forKey:NSViewAnimationTargetKey];
    
    // calculate new frame
    float dX, dY, dW, dH;
    origFrame  = [selectedContactImageView frame];
    destFrame = [peoplePickerImageView frame];    
    destFrame = [contentView convertRect:destFrame fromView:peoplePickerImageView];
    dW = destFrame.size.width - origFrame.size.width;
    dH = destFrame.size.height - origFrame.size.height;
    dX = dW/2;
    dY = dH/2;
    destRect = NSMakeRect(origFrame.origin.x - dX, 
                          origFrame.origin.y -dY, 
                          origFrame.size.width + dW, 
                          origFrame.size.height + dH);
    [animPropertiesDict setObject:[NSValue valueWithRect:destRect] 
                           forKey:NSViewAnimationEndFrameKey];
        
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:1.0];    // One second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    return theAnim;    
}

// hide scroll View
-(NSAnimation *) hideScrollViewAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:scrollView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:NSViewAnimationFadeOutEffect
                           forKey:NSViewAnimationEffectKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    return theAnim;
}

// move contact image to desired location
-(NSAnimation *) moveContactAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    NSRect destFrame, frame;

    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:selectedContactImageView forKey:NSViewAnimationTargetKey];

    frame = [peoplePickerImageView frame];
    destFrame = [contentView convertRect:frame fromView:peoplePickerView];
    
    [animPropertiesDict setObject:[NSValue valueWithRect:destFrame] 
                           forKey:NSViewAnimationEndFrameKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
        
    return theAnim;
}

-(NSAnimation *) showPeoplePickerAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:peoplePickerView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:NSViewAnimationFadeInEffect
                           forKey:NSViewAnimationEffectKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // One second
    [theAnim setAnimationCurve:NSAnimationEaseInOut];
    
    return theAnim;
}

#pragma mark -
#pragma mark Animation initialization (Hide)

// fade out peoplePickerView
-(NSAnimation *) hidePeoplePickerViewAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:peoplePickerView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:NSViewAnimationFadeOutEffect
                           forKey:NSViewAnimationEffectKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    return theAnim;
}

// zoom in contact image
-(NSAnimation *) zoomInSelectedContactImageAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    NSRect destRec, origRect;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:selectedContactImageView forKey:NSViewAnimationTargetKey];
    origRect = [selectedContactImageView frame];
    destRec = NSMakeRect(origRect.origin.x + 20.0, 
                         origRect.origin.y + 20.0, 
                         origRect.size.width + 40.0, 
                         origRect.size.height + 40.0);
    [animPropertiesDict setObject:[NSValue valueWithRect:destRec] 
                           forKey:NSViewAnimationEndFrameKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:1.0];    // One second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
        
    return theAnim;
}

// move contact image to desired location (currentContactFrame)
-(NSAnimation *) moveSelectedContactImageAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:selectedContactImageView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:[NSValue valueWithRect:currentContactFrame] 
                           forKey:NSViewAnimationEndFrameKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    return theAnim;
}

// show scroll View
-(NSAnimation *) showScrollViewAnimation {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:scrollView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:NSViewAnimationFadeInEffect
                           forKey:NSViewAnimationEffectKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    return theAnim;
}

// hide contactImage
-(NSAnimation *) hideContactImage {
    NSViewAnimation *theAnim;
    NSMutableDictionary *animPropertiesDict;
    
    // Create the attributes dictionary for the first view.
    animPropertiesDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Specify which view to modify.
    [animPropertiesDict setObject:selectedContactImageView forKey:NSViewAnimationTargetKey];
    
    [animPropertiesDict setObject:NSViewAnimationFadeOutEffect
                           forKey:NSViewAnimationEffectKey];
    
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animPropertiesDict, nil]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];    // Half second
    [theAnim setAnimationCurve:NSAnimationEaseOut];
    
    return theAnim;
}

-(void) duplicateContactImageInFrame:(NSRect)frame copyImage:(BOOL) copyImage {
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:frame];
    [imageView setImageScaling:NSImageScaleAxesIndependently];
    if (copyImage) {
        [imageView setImage:[peoplePickerImageView image]];
    } else {
        [imageView setImage:[[XSContact class] defaultPhotoForUsersNotInAddressBook]];
    }
    [contentView addSubview:imageView];
    self.selectedContactImageView = imageView;
    [imageView release];    
}

#pragma mark -
#pragma mark Animation start / stop
-(void) startAnimations {
    NSAnimation *initialAnimation = [animationArray objectAtIndex:0];
    [initialAnimation setDelegate:self];    
    [initialAnimation startAnimation];
}

-(void) animateShowPeoplePicker:(NSRect) contactFrame {
    currentContactFrame = contactFrame;

    // modify contact image in PeoplePicker to be as big as contactFrame    
    // first of all, duplicate peoplePickerImageView and put at the upmost child of window
    [self duplicateContactImageInFrame: contactFrame copyImage:NO];

    // zoom in contact image
    NSAnimation *anim1 = [self zoomInContactImageAnimation];
    
    // hide scrollView
    NSAnimation *anim2 = [self hideScrollViewAnimation];

    // move contact image to desired location, fading in the rest of PeoplePicker View
    NSAnimation *anim3 = [self moveContactAnimation];

    // fade in PeoplePickerView
    NSAnimation *anim4 = [self showPeoplePickerAnimation];
    
    // hide contactImage
    NSAnimation *anim5 = [self hideContactImage];

    // set animations
    NSArray *array = [[NSArray alloc] initWithObjects:anim1, anim2, anim3, anim4, anim5, nil];
    self.animationArray = array;
    [array release];

    // play
    [self startAnimations];
}

-(void) animateHidePeoplePicker {
    // first of all, duplicate peoplePickerImageView and put at the upmost child of window
    NSRect frame = [peoplePickerImageView frame];
    NSRect destFrame = [contentView convertRect:frame fromView:peoplePickerView];
    [self duplicateContactImageInFrame:destFrame copyImage:YES];
    
    // fade out peoplePickerView, must not be hidden
    NSAnimation *anim1 = [self hidePeoplePickerViewAnimation];
    
    // zoom in contact image
    NSAnimation *anim2 = [self zoomInSelectedContactImageAnimation];
    
    // move contact image to desired location (currentContactFrame)
    NSAnimation *anim3 = [self moveSelectedContactImageAnimation];
    
    // show scroll view
    NSAnimation *anim4 = [self showScrollViewAnimation];
    
    // hide contactImage
    NSAnimation *anim5 = [self hideContactImage];

    // set animations
    NSArray *array = [[NSArray alloc] initWithObjects:anim1, anim2, anim3, anim4, anim5, nil];
    self.animationArray = array;
    [array release];

    // play
    [self startAnimations];
}

#pragma mark -
#pragma mark NSAnimationDelegate methods
- (void)animationDidEnd:(NSAnimation *)animation {
    NSUInteger index = [animationArray indexOfObject:animation];    
    if(index != NSNotFound && index < ([animationArray count] -1)) {
        NSAnimation *nextAnimation = [animationArray objectAtIndex:index + 1];
        [nextAnimation setDelegate:self];
        [nextAnimation startAnimation];
    } else {        
        
        if(selectedContactImageView) {
            [selectedContactImageView removeFromSuperview];
            [selectedContactImageView release];
        }
        // release all array
        self.animationArray = nil;
    }
}
@end
