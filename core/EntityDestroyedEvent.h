//
//  EntityDestroyedEvent.h
//  Squaby
//
//  Created by Philipp Rakuschan on 07/04/2010.
//

#import <Foundation/Foundation.h>
#import "EventType.h"
#import "AbstractEvent.h"

@interface EntityDestroyedEvent : AbstractEvent {
	NSString *entityID;
}

@property (retain) NSString *entityID;

- (id)initWithEntityID:(NSString *)eid;

+ (void)initialize;

@end
