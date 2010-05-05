//
//  CogaenTestAppDelegate.m
//  CogaenTest
//
//  Created by Roman Divotkey on 04.05.10.
//  Copyright FH OÖ Studienbetriebs GmbH 2010. All rights reserved.
//

#import "CogaenTestAppDelegate.h"

@implementation CogaenTestAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
