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
#import "EntityDestroyedEvent.h"

static EventType* EVENT_TYPE = nil;

@implementation EntityDestroyedEvent

@synthesize entityID;

- (id) initWithEntityID: (NSString *) eid {
	if ( (self = [super init]) ) {
		entityID = eid;
		[entityID retain];
	}
	return self;
}

- (void)dealloc {
	[entityID release];	
	[super dealloc];
}

+ (void) initialize {
	if (EVENT_TYPE == nil) {
	EVENT_TYPE = [[EventType alloc] initWithName: @"EntityDestroyedEvent"]; // where is it released?
	}
}

+ (EventType*) eventType
{
	return EVENT_TYPE;
}

- (const EventType*) eventType {
	return EVENT_TYPE;
}

@end
