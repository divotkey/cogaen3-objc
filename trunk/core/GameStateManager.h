//
//  GameStateManager.h
//  Cogaen3
//
//  Created by Martina Karrer on 19.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "EventListener.h"

@class GameState;
@class EventType;
@class AbstractEvent;

@interface GameStateManager : NSObject <Service, EventListener> {
	
@private
	
	Core*					core;
	NSMutableDictionary*	states;
	GameState*				currentState;
	NSMutableArray*			transitions;
}

+ (GameStateManager*) getInstance: (Core*) core;
- (void) initialize: (Core*) aCore;

- (void) addGameState: (GameState*) aState;
- (GameState*) getGameState: (NSString*) nameOfState;
- (BOOL) hasGameState: (GameState*) aState;

- (void) setCurrentGameState: (NSString*) newState;
- (void) addTransitionFromState: (NSString*) preState toState: (NSString*) postState withEventType: (EventType*) anEventType;

- (void) handleEvent: (AbstractEvent*) anEvent;

@end
