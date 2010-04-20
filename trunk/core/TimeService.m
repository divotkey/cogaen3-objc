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
