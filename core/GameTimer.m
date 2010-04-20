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

#import "GameTimer.h"

@implementation GameTimer

@synthesize name;
@synthesize paused;
@synthesize time;
@synthesize deltaTime;
@synthesize scale;

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	[self release];
	return nil;
}

- (id) initWithName: (NSString*) aName {
	if (self = [super init]) {
		scale = 1.0;
		paused = FALSE;
		time = 0.0;
		deltaTime = 0.0;
		name = aName;
		[name retain];
	}
	
	return self;		
}

- (void) reset {
	time = 0.0;
	deltaTime = 0.0;
}

- (void) update: (double) dt {
	if (paused == TRUE) {
		return;
	}
	
	deltaTime = scale * dt;
	time += deltaTime;
}

- (void) dealloc
{
	[name release];
	[super dealloc];
}

@end
