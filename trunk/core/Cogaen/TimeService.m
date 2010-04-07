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

#import "Core.h"
#import "NameService.h"
#import "GameTimer.h"
#import "TimeService.h"

static NSString* const SERVICE_NAME = @"cogaen.timeservice";

// The update method of Timer objects should not be called outside this service. 
// Therefor we use a category 'Hidden' to realize this behaviour.
// This way we emulate friend class functionality of c++.

@interface GameTimer (Hidden)
- (void) update: (double) dt;
@end


@implementation GameTimer (Hidden)

- (void) update: (double) dt
{
	if (!paused) {
		deltaTime = scale * dt;
		time += deltaTime;
	}
}

@end;

@implementation TimeService

+ (TimeService*) getInstance: (Core*) core
{
	return  [core getService: SERVICE_NAME];
}

+ (NSString*) name
{
	return SERVICE_NAME;
}


- (id) init
{
	if (self = [super init]) {
		timers = [[NSMutableDictionary alloc] init];
	}
	
	return self;	
}

- (void) dealloc
{
	[timers release];
	[super dealloc];
}

- (NSString*) getName
{
	return [TimeService name];
}

- (void) initialize: (Core *) aCore
{
	core = aCore;
	nameService = [NameService getInstance: core];
}

- (BOOL) hasTimer: (NSString*) name
{
	return [timers objectForKey: name] != nil;
}

- (GameTimer*) createTimer
{
	return [self createTimer: [nameService generateName]];
}

- (GameTimer*) createTimer: (NSString*) name
{
	if ( [self hasTimer: name] ) {
		[NSException raise: @"UnambiguousNameException" format: @"timer with name '%@' already exists", name];
	}
	
	GameTimer* newTimer = [[[GameTimer alloc] initWithName: name] autorelease];
	[timers setObject: newTimer forKey: name];
	[newTimer setScale: 1.0];
	return newTimer;
}

- (GameTimer*) getTimer: (NSString*) name
{
	return [timers objectForKey: name];
}

- (void) update
{
	double dt = [core deltaTime];	
	NSEnumerator *enumerator = [timers objectEnumerator];
	
	for (GameTimer* timer = [enumerator nextObject]; timer != nil; timer = [enumerator nextObject]) {
		[timer update: dt];
	}	
}

@end
