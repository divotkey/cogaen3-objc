//
//  GameStateManager.m
//  Cogaen3
//
//  Created by Martina Karrer on 19.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameStateManager.h"
#import "GameState.h"
#import "EventManager.h"
#import "EventType.h"
#import "AbstractEvent.h"
#import "Core.h"




@interface Transition: NSObject
{
	GameState*		preState;
	GameState*		postState;
	EventType*		eventType;
}

@property(readonly) GameState* preState;
@property(readonly) GameState* postState;
@property(readonly) EventType* eventType;

- (id) initWithPreState: (GameState*) aPreState postState: (GameState*) aPostState withEventType: (EventType*) anEventType;

@end


@implementation Transition

@synthesize preState;
@synthesize postState;
@synthesize eventType;

- (id) initWithPreState: (GameState*) aPreState postState: (GameState*) aPostState withEventType: (EventType*) anEventType
{
	if(self = [super init]) {
		preState = aPreState;
		postState = aPostState;
		eventType = anEventType;
	}
	return self;
}

@end




static NSString* const SERVICE_NAME = @"cogaen.gamestatemanager";


@interface GameStateManager() 

	- (void) switchStateTo: (GameState*) newState;
	- (BOOL) hasTransitionFromState: (GameState*) preState withEventType: (EventType*) anEventType;
	
@end


@implementation GameStateManager

- (id) init 
{
	if(self = [super init]) {
		states = [[NSMutableDictionary alloc] init];
		transitions = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
	[states release];
	[transitions release];
}


+ (GameStateManager*) getInstance: (Core*) core
{
	return (GameStateManager*) [core getService: SERVICE_NAME];
}


- (void) initialize: (Core*) aCore 
{
	core = aCore;
}


- (NSString*) getName
{
	return SERVICE_NAME;
}

- (void) addGameState: (GameState*) aState 
{
	[states setObject: aState forKey: [aState name]];
}


- (GameState*) getGameState: (NSString*) nameOfState  
{
	return [states objectForKey: nameOfState];
}

		   
- (BOOL) hasGameState: (GameState*) aState  
{
	return ([states objectForKey: [aState name]] != nil);
}


- (void) setCurrentGameState: (NSString*) newState  
{
	[self switchStateTo: [self getGameState: newState]];
}


- (void) addTransitionFromState: (NSString*) preStateName toState: (NSString*) postStateName withEventType: (EventType*) anEventType  
{
	
	GameState* preState  = [self getGameState: preStateName];
	GameState* postState = [self getGameState: postStateName];
	
	// check if a transition with the same preState and the same EventType already exists
	if([self hasTransitionFromState: preState withEventType: anEventType]) {
		@throw [NSException exceptionWithName: @"Unable to add transition." 
								reason: [NSString stringWithFormat: @"A transition with preState %@ and EventType %@ already exists.", preStateName, [anEventType name]]  userInfo:nil]; 
	}
	
	// add new transition
	Transition* newTransiton = [[Transition alloc] initWithPreState: preState postState: postState withEventType: anEventType];
	[transitions addObject: newTransiton];
	[newTransiton release];
	
	// add manager as listener for corresponding transition event
	EventManager* eventManager = [EventManager getInstance: core];
	if(![eventManager hasListener: self forType: anEventType]) {
		[eventManager addListener: self forType: anEventType];
	}
}


- (void) handleEvent: (AbstractEvent*) anEvent  
{
	for(Transition* transition in transitions) {
		if(([transition preState] == currentState) && [[transition eventType] isEqual: [anEvent eventType]]) {
			[self switchStateTo: [transition postState]];
		}
	}
}


- (void) switchStateTo: (GameState*) newState 
{
	if(currentState != nil) {
		[currentState onExit];
	}
	currentState = newState;
	[currentState onEnter];
}


- (BOOL) hasTransitionFromState: (GameState*) preState withEventType: (EventType*) anEventType
{
	for(Transition* transition in transitions) {
		return ([[transition preState] isEqual: preState] && [[transition eventType] isEqual: anEventType]);
	}
	return FALSE;
}

@end
