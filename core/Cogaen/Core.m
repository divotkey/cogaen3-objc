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

#import "LoggingService.h"
#import "NameService.h"
#import "TimeSErvice.h"
#import "EventManager.h"
#import "EntityManager.h"
#import "Core.h"

static NSString* const LOGGIN_SOURCE = @"core";

@interface Core()

- (void) installServiceAndRelease: (id <Service>) aService;

@end



@implementation Core

@synthesize time;
@synthesize deltaTime;

- (id) init
{
	if (self = [super init]) {
		services = [[NSMutableDictionary alloc] init];
		updateables = [[NSMutableArray alloc] init];
		time = 0.0;
		deltaTime = 0.0;
	}
	
	return self;
}

- (id) initWithStandardServices
{
	if (self = [super init]) {
		services = [[NSMutableDictionary alloc] init];
		updateables = [[NSMutableArray alloc] init];		
		time = 0.0;
		deltaTime = 0.0;
		
		// install standard services		
		[self installServiceAndRelease: [[LoggingService alloc] init]];
		[self installServiceAndRelease: [[NameService alloc] init]];
		[self installServiceAndRelease: [[TimeService alloc] init]];
		[self installServiceAndRelease: [[EventManager alloc] init]];
		[self installServiceAndRelease: [[EntityManager alloc] init]];
	}
	
	return self;
	
}

- (void) dealloc {
	[updateables release];
	[services release];
	[super dealloc];
}

- (void) installServiceAndRelease: (id <Service>) aService
{
	[self installService: aService];
	[aService release];
}

- (void) installService: (id <Service>) service {
	[services setObject: service forKey: [service getName]];
	if ([service respondsToSelector:@selector(update)] ) {
		[updateables addObject: service];
	}
	
	[service initialize: self];
	
	// log successful initialization of service (debug level)	
	if ([self hasService: [LoggingService name]]) {
		LoggingService* logger = [LoggingService getInstance: self];
		NSString *msg;
		if ([service respondsToSelector:@selector(update)] ) {
			msg = [[NSString alloc] initWithFormat: @"installed updateable service '%@'", [service getName]];
		} else {
			msg = [[NSString alloc] initWithFormat: @"installed service '%@'", [service getName]];			
		}
		[logger logDebug: msg fromSource: LOGGIN_SOURCE];
		[msg release];
	}
}

- (id <Service>) getService: (NSString*) name {
	id <Service> srv = [services objectForKey: name];
	if (srv == nil) {
		[NSException raise: @"ServiceNotFoundException" format: @"service with name '%@' not found", name];
	}
	
	return srv;
}

- (BOOL) hasService: (NSString*) name
{
	return [services objectForKey: name] != nil;
}
							
- (void) update: (double) dt {
	time += dt;
	deltaTime = dt;
	
	for (id <Service> service in updateables) {
		[service update];
	}
}

@end
