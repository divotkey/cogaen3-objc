//
//  CreateEntityEvent.h
//  Squaby
//
//  Created by Philipp Rakuschan on 07/04/2010.
//  Copyright 2010 plan.b-Attersee GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventType.h"
#import "AbstractEvent.h"


@interface EntityCreatedEvent : AbstractEvent {
	NSString *entityID;
	NSString *entityType;
}

@property (retain) NSString *entityID;
@property (retain) NSString *entityType;

- (id)initWithEntityID:(NSString *)eid entityType:(NSString *)etype;

+ (void)initialize;

@end
