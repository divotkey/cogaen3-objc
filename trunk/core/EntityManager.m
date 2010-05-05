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

- (void)removeAllEntities {
	[newEntities removeAllObjects];
	
	for (AbstractEntity *e in removedEntities) {
		[e disengage];
	}
	[removedEntities removeAllObjects];
	
	NSArray *keys = [entities allKeys];
	for (NSString *key in keys) {
		AbstractEntity *e = [entities objectForKey:key];
		[e disengage];
	}
	[entities removeAllObjects];
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
