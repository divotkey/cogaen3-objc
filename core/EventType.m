/* 
 -----------------------------------------------------------------------------
 Cogaen - Component-based Game Engine (v3)
 -----------------------------------------------------------------------------
 This software is developed by the Cogaen Development Team. Please have a 
 look at our project home page for further details: http://www.cogaen.org
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright (c) 2010 Roman Divotkey
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
