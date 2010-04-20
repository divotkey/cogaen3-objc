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

#import "TaskManager.h"
#import "AbstractTask.h"
#import "Core.h"
#import "LoggingService.h"


static NSString* const SERVICE_NAME = @"cogaen.taskmanager";

@implementation TaskManager

- (id) init
{
	if( (self = [super init]) ) {
		tasks = [[NSMutableDictionary alloc] init];
		newTasks = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[tasks release];
	[newTasks release];	
}


+ (TaskManager*) getInstance: (Core*) core;
{
	return (TaskManager*) [core getService: SERVICE_NAME];
}


- (void) initialize: (Core*) aCore 
{
	core = aCore;
	logger = [LoggingService getInstance: core];
}


- (NSString*) getName
{
	return SERVICE_NAME;
}


- (void) update
{
	// add new tasks
	for(AbstractTask* newTask in newTasks) {
		[tasks setObject: newTask forKey: [newTask name]];
	}
	[newTasks removeAllObjects];
	
	// update all task which are not dead
	NSArray* taskObjects = [tasks allValues];
	for(AbstractTask* task in taskObjects) {
		if([task isDead]) {
			[tasks removeObjectForKey: [task name]];
			[logger logInfo: [NSString stringWithFormat: @"Task %@ died.", [task name]] fromSource: SERVICE_NAME];
		}
		else if(![task  isPaused]) {
			[task update];
		}
	}
	
}


- (void) attachTask: (AbstractTask*) aTask
{
	if([self getTask: [aTask name]] != nil) {
		@throw [NSException exceptionWithName:  @"Unable to attach task."
									   reason: [NSString stringWithFormat: @"Task with name %@ already attached.", [aTask name]]  userInfo:nil];  
	}
	[newTasks addObject: aTask];
	[logger logInfo: [NSString stringWithFormat: @"Task %@ attached.", [aTask name]]  fromSource: SERVICE_NAME];
}


- (AbstractTask*) getTask: (NSString*) nameOfTask
{
	AbstractTask* task = [tasks objectForKey: nameOfTask];
	if(task == nil) {
		for(task in newTasks) {
			if([[task name] isEqual: nameOfTask]) {
				return task;
			}
		}
	}
	return task;
}


- (void) killTask: (NSString*) nameOfTask
{
	AbstractTask* task = [self getTask: nameOfTask];
	if(task != nil) {
		[task kill];
	}
}

@end
