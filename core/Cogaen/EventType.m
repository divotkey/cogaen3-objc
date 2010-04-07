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

#import "EventType.h"

@interface EventType()
	
- (BOOL) equalNames: (EventType*) otherEventType;

@end

@implementation EventType

@synthesize typeId;
@synthesize name;


+ (id) typeWithString: (NSString*) aName
{
	return [[[EventType alloc] initWithName: aName] autorelease];
}

- (id) init {
	if(self = [super init]) {
		name = [[NSString alloc] init];
		typeId = 0;
	}
	return self;
}

- (id) initWithName: aName {
	if(self = [super init]) {
		name = [[aName lowercaseString] retain];
		typeId = [name hash];
	}
	return self;
}

- (void) dealloc
{
	[name release];
	[super dealloc];
}

- (BOOL) isEqual: (id) anObject {

	if (anObject == self) {
		return YES; // identical
	}
	
    if (!anObject || ![anObject isKindOfClass:[self class]]) { 
        return NO; // other == nil OR not the same class
	}
	
    if (![name isEqual:[(EventType*) anObject name]]) {
		return NO;
	}
	
	if(typeId != [(EventType*) anObject typeId]) {
		return NO;
	}
	
	// also very unlikely equal strings could result in the same hash code,
	// let's test this only in 'debug' mode
	NSAssert([self equalNames: anObject], @"event type names differ but result in identical hash codes, choose a different name");
	
	return YES;
}

- (NSUInteger) hash {
	return typeId;
}
	
- (BOOL) equalNames: (EventType*) otherEventType {
	return ([name isEqualToString:[otherEventType name]]);
}

- (id) copyWithZone: (NSZone *) zone {
    return [self retain];
}

@end
