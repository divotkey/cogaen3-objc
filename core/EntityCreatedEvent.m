//
//  CreateEntityEvent.m
//  Squaby
//
//  Created by Philipp Rakuschan on 07/04/2010.
//  Copyright 2010 plan.b-Attersee GmbH. All rights reserved.
//

#import "EntityCreatedEvent.h"


@implementation EntityCreatedEvent

@synthesize entityID, entityType;

- (id)initWithEntityID:(NSString *)eid entityType:(NSString *)etype {
	if ( (self = [super init]) ) {
		self.entityID = eid; // automatically retained because of property with retain attribute
		self.entityType = etype;
	}
	return self;
}

- (void)dealloc {
	[entityID release];
	[entityType release];
	
	[super dealloc];
}

+ (void)initialize {
	if (EVENT_TYPE == nil) {
		EVENT_TYPE = [[EventType alloc] initWithName: @"EntityCreatedEvent"]; // where is it released?
	}
}

+ (EventType*) eventType
{
	return EVENT_TYPE;
}

- (const EventType*) eventType {
	return EVENT_TYPE;
}

@end
