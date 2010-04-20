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

#import "Core.h"
#import "EventListener.h"
#import "EventType.h"
#import "AbstractEvent.h"
#import "EventManager.h"


static NSString* const SERVICE_NAME = @"cogaen.eventmanager";

@interface EventManager()

- (void) fireEvent: (AbstractEvent*) anEvent;

@end


@implementation EventManager


-(id) init
{
	if(self = [super init]) {
		listeners = [[NSMutableDictionary alloc] init];
		handledListeners = [[NSMutableArray alloc] init];
		
		events[0] = [[NSMutableArray alloc] init];
		events[1] = [[NSMutableArray alloc] init];
		currentEventList = 0;
		currentEventType = nil;
	}
	return self;
}

- (void) dealloc
{	
	[listeners release];
	[handledListeners release];
	[events[0] release];
	[events[1] release];
	
	[super dealloc];
}


+ (EventManager*) getInstance: (Core*) core
{
	return (EventManager*) [core getService: SERVICE_NAME];
}

- (void) initialize: (Core*) aCore 
{
	core = aCore;
}

- (NSString*) getName
{
	return SERVICE_NAME;
}


- (void) update
{
	// calc new currentList index
	int idx = currentEventList++;
	currentEventList %= 2; 
	
	// fire Events
	for(AbstractEvent* event in events[idx]) {
		[self fireEvent: event];
	}
	
	[events[idx] removeAllObjects];
}


- (BOOL) hasListener: (id <EventListener>) aListener forType: (EventType*) anEventType
{
	NSMutableArray* typeListeners = [listeners objectForKey: anEventType];
	if (typeListeners != nil) {
		return [typeListeners containsObject: aListener];
	}
	return FALSE;
}


- (void) addListener: (id <EventListener>) aListener forType: (EventType*) anEventType
{	
	NSMutableArray* typeListeners = [listeners objectForKey: anEventType];
	
	if(typeListeners == nil) {
		typeListeners = [[NSMutableArray alloc] init];
		[listeners setObject: typeListeners forKey: anEventType];
		[typeListeners addObject: aListener];
		[typeListeners release];
	}
	else if(![typeListeners containsObject: aListener] && (![anEventType isEqual: currentEventType] || ![handledListeners containsObject: aListener])) {
		[typeListeners addObject: aListener];
	}	
}


-(void) removeListener: (id <EventListener>) aListener forType: (EventType*) anEventType
{
	NSMutableArray* typeListeners = [listeners objectForKey: anEventType];
	
	if(typeListeners != nil) {
		[typeListeners removeObject: aListener];
	}
	
	if([anEventType isEqual: currentEventType]) {
		[handledListeners removeObject: aListener];
	}
}


- (void) removeListener: (id <EventListener>) aListener
{
	// This code is inefficient in terms of memory usage, because each time we allocate a new NSEnumator object
	// which is attached to the current autorelease pool
	/*
	NSEnumerator *enumerator = [listeners objectEnumerator];
	for (NSMutableArray* typeListeners = [enumerator nextObject]; typeListeners != nil; typeListeners = [enumerator nextObject]) {
		[typeListeners removeObject: aListener];
	}
	[handledListeners removeObject: aListener];	
	*/
	
	// This version should fulfill our needs much better.
	for (EventType* type in listeners) {
		[self removeListener: aListener forType: type];
	}	
}


- (void) enqueueEvent: (AbstractEvent*) anEvent
{
	[events[currentEventList] addObject: anEvent];
}


- (void) fireEvent: (AbstractEvent*) anEvent
{
	NSMutableArray* typeListeners = [listeners objectForKey: [anEvent eventType]];
	
	if(typeListeners == nil) {
		return; // no listeners for this event
	}
	
	currentEventType = [anEvent eventType];
	
	int size = [typeListeners count]; 
	while(size--) {
		id <EventListener> listener = [typeListeners lastObject];
		[handledListeners addObject: listener];
		[typeListeners removeLastObject];
		[listener handleEvent: anEvent];
	}
	
	size = [handledListeners count];
	while (size--) {
		[typeListeners addObject: [handledListeners lastObject]];
		[handledListeners removeLastObject];
	}
	
	currentEventType = nil;
}

@end
