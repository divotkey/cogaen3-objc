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

#import <Foundation/Foundation.h>
#import "Service.h"
#import "EventListener.h"

@class Core;
@class EventType;
@class AbstractEvent;

@interface EventManager : NSObject <Service> {
	
	Core*					core;	
	NSMutableDictionary*	listeners;
	NSMutableArray*			handledListeners;	
	NSMutableArray*			events[2];
	int						currentEventList;
	EventType*				currentEventType;
}

+ (EventManager*) getInstance: (Core*) core;
- (void) initialize: (Core*) aCore;
- (NSString*) getName;
- (void) update;

- (void) addListener: (id <EventListener>) aListener forType: (EventType*) anEventType;
- (void) removeListener: (id <EventListener>) aListener forType: (EventType*) anEventType;
- (void) removeListener: (id <EventListener>) aListener;
- (BOOL) hasListener: (id <EventListener>) aListener forType: (EventType*) anEventType;

- (void) enqueueEvent: (AbstractEvent*) anEvent;

// PRIVATE:
// -(void) fireEvent: (Event*) event;
// -(void) clearEventQueue: (int) idx;
// -(void) swapEventList;

@end