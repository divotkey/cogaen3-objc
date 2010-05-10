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
static NSString* const LOGGING_SROUCE = @"EntityManager";


@interface EntityManager ()

- (void) engageEntity: (AbstractEntity*) entity;
- (void) disengageEntity: (AbstractEntity*) entity;

@end


@implementation EntityManager

- (id) init {
	if( (self = [super init]) ) {
		entities = [[NSMutableDictionary alloc] init];
		newEntities = [[NSMutableArray alloc] init];
		removedEntities = [[NSMutableArray alloc] init];
		engagedEntities = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void) dealloc
{
	[engagedEntities release];
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
	// engage new entities
	for(AbstractEntity* entity in newEntities) {
		[self engageEntity: entity];
	}
	[newEntities removeAllObjects];

	// disengage and remove old entities
	for(AbstractEntity* entity in removedEntities) {
		[self disengageEntity: entity];
		[entities removeObjectForKey: [entity name]];
	}
	[removedEntities removeAllObjects];

	// update engaged entities
	for(AbstractEntity* entity in engagedEntities) {
		[entity update];
	}	
}

- (BOOL) hasEntity: (NSString*) name {
	return [entities objectForKey:name] != nil;
}

-(void) addEntity: (AbstractEntity*) entity {
	if ([entities objectForKey: [entity name]] != nil) {
		[NSException raise:@"EntityAlreadyExistsException" format:@"entity with name %@ already exists", [entity name]];
	}
	[entities setObject:entity forKey:[entity name]];
	[newEntities addObject:entity];
}

-(void) removeEntity: (AbstractEntity*) entity {
	// we use removeEntityWithName in order to ensure that an
	// exception is thrown if specified entity does not exist
	[self removeEntityWithName:[entity name]];
}

-(void) removeEntityWithName: (NSString*) entityName {
	AbstractEntity* entity = [self getEntity: entityName];
	if (![removedEntities containsObject:entity]) {
		[removedEntities addObject:entity];
	}
}

-(AbstractEntity*) getEntity: (NSString*) entityName {
	AbstractEntity* entity = [entities objectForKey: entityName];
	if (entity == nil) {
		[NSException raise:@"EntityDoesNotExistException" format:@"Entity with name %@ does not exist", entityName];
	}
	return entity;
}

- (void)removeAllEntities {
	for(NSString* entityName in entities) {
		[self removeEntityWithName:entityName];
	}
}

-(int) numOfEntities {
	return [entities count];
}

+ (EntityManager*) getInstance: (Core*) core {
	return (EntityManager*) [core getService: SERVICE_NAME];
}

+(NSString*) name {
	return SERVICE_NAME;
}

// private category:

- (void) engageEntity: (AbstractEntity*) entity {
	[entity engage];
	[engagedEntities addObject: entity];

	EntityCreatedEvent *entityCreated = [[EntityCreatedEvent alloc] initWithEntityID:entity.name entityType:[entity entityType]];
	[eventManager enqueueEvent:entityCreated];
	[entityCreated release];
	
	[logger logInfo: [NSString stringWithFormat: @"Engaged entity %@.", entity.name]  fromSource: LOGGING_SROUCE];
}

- (void) disengageEntity: (AbstractEntity*) entity {
	// disengage entity
	[entity disengage];
	[engagedEntities removeObject: entity];
		
	// euqneue EntityDestroyed event
	EntityDestroyedEvent *entityDestroyed = [[EntityDestroyedEvent alloc] initWithEntityID:entity.name];
	[eventManager enqueueEvent:entityDestroyed];
	[entityDestroyed release];

	// add log entry
	[logger logInfo: [NSString stringWithFormat: @"Disengaged entity %@.", entity.name]  fromSource: LOGGING_SROUCE];	
}

@end
