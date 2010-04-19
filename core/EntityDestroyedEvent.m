//
//  EntityDestroyedEvent.m
//  Squaby
//
//  Created by Philipp Rakuschan on 07/04/2010.
//

#import "EntityDestroyedEvent.h"

@implementation EntityDestroyedEvent

@synthesize entityID;

- (id)initWithEntityID:(NSString *)eid {
	if ( (self = [super init]) ) {
		self.entityID = eid;
	}
	return self;
}

- (void)dealloc {
	[entityID release];
	
	[super dealloc];
}

+ (void)initialize {
	if (EVENT_TYPE == nil) {
	EVENT_TYPE = [[EventType alloc] initWithName: @"EntityDestroyedEvent"]; // where is it released?
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
