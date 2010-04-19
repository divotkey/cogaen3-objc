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

#import "EntityManager.h"
#import "Core.h"
#import "LoggingService.h"
#import "EventManager.h"
#import "AbstractEntity.h"
#import "EntityCreatedEvent.h"
#import "EntityDestroyedEvent.h"

static NSString* const SERVICE_NAME = @"cogaen.entitymanager";


@interface EntityManager ()

- (void) engageEntity: (AbstractEntity*) entity;
- (void) disengageEntity: (AbstractEntity*) entity;

@end


@implementation EntityManager

- (id) init {
	if( (self = [super init]) ) {
		newEntities = [[NSMutableArray alloc] init];
		removedEntities = [[NSMutableArray alloc] init];
		entities = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


- (void) dealloc
{
	[newEntities release];
	[removedEntities release];
	[entities release];
	[super dealloc];
}

- (void) initialize: (Core*) aCore {
	core = aCore;
	logger = [LoggingService getInstance: core];
	eventManager = [EventManager getInstance: core];
}

- (NSString*) getName {
	return SERVICE_NAME;
}

- (void) update {
	for(AbstractEntity* entity in newEntities) {
		[self engageEntity: entity];
	}
	[newEntities removeAllObjects];
	
	for(AbstractEntity* entity in removedEntities) {
		[self disengageEntity: entity];
	}
	[removedEntities removeAllObjects];
	
	NSEnumerator *enumerator = [entities objectEnumerator];
	for (AbstractEntity* entity = [enumerator nextObject]; entity != nil; entity = [enumerator nextObject]) {
		[entity update];
	}
}

-(void) addEntity: (AbstractEntity*) entity {
	[newEntities addObject: entity];
}

-(void) removeEntity: (AbstractEntity*) entity {
	[removedEntities addObject:entity];
}

-(void) removeEntityWithName: (NSString*) entityName {
	[removedEntities addObject:[self getEntity: entityName]];
}

-(AbstractEntity*) getEntity: (NSString*) entityName {
	return [entities objectForKey: entityName];
}

-(int) numOfEntities {
	return [entities count];
}

+ (EntityManager*) getInstance: (Core*) core {
	return (EntityManager*) [core getService: SERVICE_NAME];
}

// private category:

- (void) engageEntity: (AbstractEntity*) entity {
	if(![entities objectForKey: entity.name]) { // does entities already contain an entity with this name?
		[entities setObject: entity forKey: entity.name];
		[entity engage];
	}
	else {
		@throw [NSException exceptionWithName: [NSString stringWithFormat: @"Unable to add the entity %@.", entity.name] 
									   reason:@"An entity with the same name already exists." userInfo:nil]; 
	}
	
	[logger logInfo: [NSString stringWithFormat: @"Engaged entity %@.", entity.name]  fromSource: SERVICE_NAME];
	EntityCreatedEvent *ece = [[EntityCreatedEvent alloc] initWithEntityID:entity.name entityType:[entity entityType]];
	[eventManager enqueueEvent:ece];
	[ece release];
}

- (void) disengageEntity: (AbstractEntity*) entity {
	if([entities objectForKey: entity.name]) { // does entities contain an entity with this name?
		[entities removeObjectForKey: entity.name];
		[entity disengage];
	}
	else {
		@throw [NSException exceptionWithName: [NSString stringWithFormat: @"Unable to remove entity %@.", entity.name] 
									   reason:@"No entity with this name."  userInfo:nil]; 
	}
	
	[logger logInfo: [NSString stringWithFormat: @"Disengaged entity %@.", entity.name]  fromSource: SERVICE_NAME];
	EntityDestroyedEvent *ede = [[EntityDestroyedEvent alloc] initWithEntityID:entity.name];
	[eventManager enqueueEvent:ede];
	[ede release];
}



@end