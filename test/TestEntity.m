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

#import "TestEntity.h"

@implementation TestEntity

@synthesize cntUpdate, cntEngage, cntDisengage;

- (id) initWithName: (NSString*) aName andCore: (Core*) aCore andType: (NSString*) aType {
    if (self = [super initWithName: aName andCore: aCore]) {
		type = aType;
		[type retain];
		cntUpdate = 0;
		cntEngage = 0;
		cntDisengage = 0;
	}
	return self;
}

- (void) dealloc {
	[type release];
	[super dealloc];
}

- (void) reset {
	cntUpdate = 0;
	cntEngage = 0;
	cntDisengage = 0;
}

- (NSString *) entityType {
	return type;
}

-(BOOL) isOfType: (NSString*) aType {
	return [type isEqualToString: aType];
}

-(void) engage {
	cntEngage++;
}

-(void) disengage {
	cntDisengage++;
}

-(void) update {
	cntUpdate++;
}

@end
