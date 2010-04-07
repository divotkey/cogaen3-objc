//
//  GameState.h
//  Cogaen3
//
//  Created by Martina Karrer on 19.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameState

- (NSString*) name;
- (void) onEnter;
- (void) onExit;

@end
