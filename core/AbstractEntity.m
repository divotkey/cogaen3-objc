/*
 ---------------------------------------------------------------------------
 Cogaen - Component-based Game Engine (v3)
 ---------------------------------------------------------------------------
 This software is developed by the Cogaen Development Team. Please have a 
 look at our project page (www.cogaen.org) for further details.
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright (c) 2010 Roman Divotkey. All rights reserved.
 
 This file is part of Cogaen.
 
 Cogaen is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 
 (at your option) any later version.
 
 Cogaen is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with Cogaen.  If not, see <http://www.gnu.org/licenses/>.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 */

#import "AbstractEntity.h"

@implementation AbstractEntity

@synthesize name;

// prevent the initialization of the base class via the default initializer
- (id)init { 
    [self doesNotRecognizeSelector:_cmd];
    [self release];
    return nil;
}

- (id) initWithName: (NSString*) aName andCore: (Core*) aCore; {
    if (self = [super init]) {
		core = aCore;
		name = aName;
	}
	return self;
}

-(void) engage {
    [self doesNotRecognizeSelector:_cmd];
    // supposed to be implemented by subclass   
}

-(void) disengage {
    [self doesNotRecognizeSelector:_cmd];
    // supposed to be implemented by subclass
}

-(void) update {
    [self doesNotRecognizeSelector:_cmd];
    // supposed to be implemented by subclass
}

- (NSString *) entityType {
	[self doesNotRecognizeSelector:_cmd];
    // supposed to be implemented by subclass		
	return nil;
}


-(BOOL) isOfType: (NSString*) type {
    [self doesNotRecognizeSelector:_cmd];
    // supposed to be implemented by subclass
    return FALSE;
}

@end
