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
		suspended = [[NSMutableArray alloc] init];
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
		suspended = [[NSMutableArray alloc] init];
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
	[suspended release];
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

- (void) suspendService: (NSString*) name {
	
	id <Service> serviceToSuspend = nil;
	for (id <Service> service in updateables) {
		if ([[service getName] isEqual: name]) {
			serviceToSuspend = service;
			break;
		}
	}
	
	if (serviceToSuspend != nil) {
		[updateables removeObject: serviceToSuspend];
		[suspended addObject: serviceToSuspend];

		LoggingService* logger = [LoggingService getInstance: self];		
		NSString *msg = [[NSString alloc] initWithFormat: @"service %@ suspended", [serviceToSuspend getName]];
		[logger logInfo: msg fromSource: LOGGIN_SOURCE];
		[msg release];
	}
}

- (void) resumeService: (NSString*) name {
	id <Service> serviceToResume = nil;
	for (id <Service> service in suspended) {
		if ([[service getName] isEqual: name]) {
			serviceToResume = service;
			break;
		}
	}	
	
	if (serviceToResume != nil) {
		[suspended removeObject: serviceToResume];
		[updateables addObject: serviceToResume];
		
		LoggingService* logger = [LoggingService getInstance: self];		
		NSString *msg = [[NSString alloc] initWithFormat: @"service %@ resumed", [serviceToResume getName]];
		[logger logInfo: msg fromSource: LOGGIN_SOURCE];
		[msg release];
	}	
}

@end