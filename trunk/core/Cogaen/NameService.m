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

#import "NameService.h"
#import "Core.h"

static NSString* const SERVICE_NAME = @"cogaen.nameservice";

@implementation NameService

- (id) init
{
	if (self = [super init]) {
		cnt = 0;
	}
	
	return self;	
}

+ (NameService*) getInstance: (Core*) core
{
	return [core getService: SERVICE_NAME];
}

+ (NSString*) name
{
	return SERVICE_NAME;
}

- (NSString*) getName {
	return [NameService name];
}

- (void) initialize: (Core*) aCore {
	core = aCore;
}

- (NSString*) newName
{
	return [[NSString alloc] initWithFormat: @"%d_anonymous", ++cnt];	
}

- (NSString*) generateName
{
	return [[self newName] autorelease];
}

@end
