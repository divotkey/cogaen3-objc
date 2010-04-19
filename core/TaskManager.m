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
