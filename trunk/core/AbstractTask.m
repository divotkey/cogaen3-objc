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

#import "AbstractTask.h"
#import "Core.h"
#import "NameService.h"


@implementation AbstractTask

@synthesize name;
@synthesize core;
@synthesize paused;
@synthesize dead;

- (id) initWithName: (NSString*) aName andCore: (Core*) aCore
{
	if(self = [super init]) {
		name = aName;
		core = aCore;
		paused = FALSE;
		dead = FALSE;
	}
	return self;
}

- (id) initWithCore: (Core*) aCore
{
	return [self initWithName: [[NameService getInstance: aCore] generateName] andCore: aCore];
}

- (void) update
{
	// intentionally left empty
	// supposed to be implemented by subclass
}


- (void) kill
{
	dead = TRUE;
}

@end