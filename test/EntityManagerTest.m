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

#import "Core.h"
#import "EntityManager.h"
#import "TestEntity.h"
#import "EntityManagerTest.h"


@implementation EntityManagerTest

- (void) setUp
{
	core = [[Core alloc] initWithStandardServices];
}

- (void) tearDown
{
	[core release];
}

- (void) testGetName 
{
	EntityManager* entMngr = [EntityManager getInstance: core];
	
	// ensure wie get the right instance of EntityManager and
	// the returned service name is valid
	STAssertNotNil(entMngr, @"returned service is nil");
	STAssertNotNil([entMngr getName], @"service name is nil");
	STAssertTrue([[entMngr getName] isEqualToString: [EntityManager name]], @"service name mismatch");
}

- (void) testAddEntity {
	EntityManager* entMngr = [EntityManager getInstance: core];
	TestEntity* entity1 = [[TestEntity alloc] initWithName: @"entity1" andCore: core];
	TestEntity* entity2 = [[TestEntity alloc] initWithName: @"entity2" andCore: core];
	TestEntity* entity3 = [[TestEntity alloc] initWithName: @"entity3" andCore: core];
	
	// ensure entity does not exist
	STAssertFalse( [entMngr hasEntity: [entity1 name]], @"hasEntity failes");
	
	// add entity; entity should not be engaged; hasEntity must return true;
	// getEntity must return newly created entity;
	[entMngr addEntity: entity1];
	STAssertTrue( [entity1 cntEngage] == 0, @"added entity should not be engaged");
	STAssertTrue( [entMngr hasEntity: [entity1 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity1 name]] == entity1, @"getEntity does not return expected entity instance");
	
	// perform update; entity should be engaged
	[core update: 0.1];
	STAssertTrue( [entity1 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity1 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity1 name]] == entity1, @"getEntity does not return expected entity instance");
	
	// add two entities at conce and perform tests
	[entMngr addEntity: entity2];
	[entMngr addEntity: entity3];
	STAssertTrue( [entity2 cntEngage] == 0, @"added entity should not be engaged");
	STAssertTrue( [entMngr hasEntity: [entity2 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity2 name]] == entity2, @"getEntity does not return expected entity instance");
	
	STAssertTrue( [entity3 cntEngage] == 0, @"added entity should not be engaged");
	STAssertTrue( [entMngr hasEntity: [entity3 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity3 name]] == entity3, @"getEntity does not return expected entity instance");
	
	[core update: 0.1];
	STAssertTrue( [entity2 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity2 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity2 name]] == entity2, @"getEntity does not return expected entity instance");
	
	STAssertTrue( [entity3 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity3 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity3 name]] == entity3, @"getEntity does not return expected entity instance");
	
	// post condition after all test
	STAssertTrue( [entity1 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity1 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity1 name]] == entity1, @"getEntity does not return expected entity instance");
	
	STAssertTrue( [entity2 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity2 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity2 name]] == entity2, @"getEntity does not return expected entity instance");
	
	STAssertTrue( [entity3 cntEngage] == 1, @"engage counter mismatch");
	STAssertTrue( [entMngr hasEntity: [entity3 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue( [entMngr getEntity: [entity3 name]] == entity3, @"getEntity does not return expected entity instance");	
	
	[entity1 release];
	[entity2 release];
	[entity3 release];
}

- (void) testAddEntityTwice {
	EntityManager* entMngr = [EntityManager getInstance: core];
	TestEntity* entity1 = [[TestEntity alloc] initWithName: @"entity1" andCore: core];
	TestEntity* entity2 = [[TestEntity alloc] initWithName: @"entity2" andCore: core];

	// add entity; perform update, add same entity again; should result in an exception
	[entMngr addEntity: entity1];
	[core update: 0.1];
	
	@try {
		[entMngr addEntity:entity1];
		STFail(@"addEntity must throw an excetion if given entity already exists");
	}
	@catch (NSException *exception) {
		// do nothing, exception is expected
	}
	
	// add entity twice without update; should result in an exception
	[entMngr addEntity:entity2];
	@try {
		[entMngr addEntity:entity2];
		STFail(@"addEntity must throw an excetion if given entity already exists");
	}
	@catch (NSException *exception) {
		// do nothing, exception is expected
	}
	
	[entity1 release];
	[entity2 release];
}

- (void) testGetEntity {
	EntityManager* entMngr = [EntityManager getInstance: core];
	TestEntity* entity1 = [[TestEntity alloc] initWithName: @"entity1" andCore: core];	
	
	// ask for unknown entity; hasEntity must return false, getEntity must throw an exception
	STAssertFalse( [entMngr hasEntity: [entity1 name]], @"hasEntity returns true for unknown entity");
	@try {
		[entMngr getEntity: [entity1 name]];
		STFail(@"getEntity doesn't throw an exception");
	}
	@catch (NSException *exception) {
		// do nothing, exception is expected
	}
	
	// add entity without update; hasEntity must return true, getEntity must return newly added entity
	[entMngr addEntity:entity1];
	STAssertTrue([entMngr hasEntity: [entity1 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue([entMngr getEntity: [entity1 name]] == entity1, @"getEntity does not return correct entity instance");
	
	// perform update; hasEntity must return true, getEntity must return newly added entity
	[core update:0.1];
	STAssertTrue([entMngr hasEntity: [entity1 name]], @"hasEntity returns false for newly added entity");
	STAssertTrue([entMngr getEntity: [entity1 name]] == entity1, @"getEntity does not return correct entity instance");	
	
	[entity1 release];
}

- (void) testRemoveEntity {
	EntityManager* entMngr = [EntityManager getInstance: core];
	TestEntity* entity1 = [[TestEntity alloc] initWithName: @"entity1" andCore: core];
	TestEntity* entity2 = [[TestEntity alloc] initWithName: @"entity2" andCore: core];
	TestEntity* entity3 = [[TestEntity alloc] initWithName: @"entity3" andCore: core];
	
	// add entities and update core, entities should be engaged
	[entMngr addEntity:entity1];
	[entMngr addEntity:entity2];
	[entMngr addEntity:entity3];
	[core update:0.1];
	
	// remove entity1 and entity2; entities should not be removed or disengaged until update
	// use "remove by entity instance" and "remove by name"
	[entMngr removeEntityWithName: [entity1 name]];
	[entMngr removeEntity: entity2];
	
	STAssertTrue([entity1 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity2 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity3 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity1 cntDisengage] == 0, @"disengage count for entity mismatch");
	STAssertTrue([entity2 cntDisengage] == 0, @"disengage count for entity mismatch");
	STAssertTrue([entity3 cntDisengage] == 0, @"disengage count for entity mismatch");	
	STAssertTrue([entMngr hasEntity: [entity1 name]], @"hasEntity returns false, but shouldn't");
	STAssertTrue([entMngr hasEntity: [entity2 name]], @"hasEntity returns false, but shouldn't");
	STAssertTrue([entMngr hasEntity: [entity3 name]], @"hasEntity returns false, but shouldn't");
	STAssertTrue([entMngr getEntity: [entity1 name]] == entity1, @"getEntity doesn't return expected entity instance");
	STAssertTrue([entMngr getEntity: [entity2 name]] == entity2, @"getEntity doesn't return expected entity instance");
	STAssertTrue([entMngr getEntity: [entity3 name]] == entity3, @"getEntity doesn't return expected entity instance");
	
	[core update: 0.1];
	STAssertTrue([entity1 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity2 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity3 cntEngage] == 1, @"engage count for entity mismatch");
	STAssertTrue([entity1 cntDisengage] == 1, @"disengage count for entity mismatch");
	STAssertTrue([entity2 cntDisengage] == 1, @"disengage count for entity mismatch");
	STAssertTrue([entity3 cntDisengage] == 0, @"disengage count for entity mismatch");	
	STAssertFalse([entMngr hasEntity: [entity1 name]], @"hasEntity returns false, but shouldn't");
	STAssertFalse([entMngr hasEntity: [entity2 name]], @"hasEntity returns false, but shouldn't");
	STAssertTrue([entMngr hasEntity: [entity3 name]], @"hasEntity returns false, but shouldn't");
	
	
	[entity1 release];
	[entity2 release];
	[entity3 release];		
}

- (void) testEntityOwnership {
	EntityManager* entMngr = [EntityManager getInstance: core];
	TestEntity* entity1 = [[TestEntity alloc] initWithName: @"entity1" andCore: core];	
	
	// add entity and do not perform update; retain count must be increased
	int retainCnt = [entity1 retainCount];
	[entMngr addEntity:entity1];
	STAssertTrue(retainCnt < [entity1 retainCount], @"EntityManager does not take over ownership of newly added entity");
	
	// remove entity and perform update; retain count must return to initial value
	[entMngr removeEntity: entity1];
	[core update: 0.1];
	STAssertTrue(retainCnt == [entity1 retainCount], @"EntityManager does not call release on removed entity");	
	
	// add entity and perform update; retain count must be increased
	[entMngr addEntity:entity1];
	STAssertTrue(retainCnt < [entity1 retainCount], @"EntityManager does not take over ownership of newly added entity");
	
	// remove entity and perform update; retain count must return to initial value
	[entMngr removeEntity: entity1];
	[core update: 0.1];
	STAssertTrue(retainCnt == [entity1 retainCount], @"EntityManager does not call release on removed entity");
	
	[entity1 release];	
}

@end
