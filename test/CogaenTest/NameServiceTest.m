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
#import "NameService.h"
#import "NameServiceTest.h"


@implementation NameServiceTest

- (void) setUp
{
	core = [[Core alloc] initWithStandardServices];
}

- (void) tearDown
{
	[core release];
}


- (void) testGenerateName
{
	NameService* nameSrv = [NameService getInstance: core];
	STAssertTrue([[nameSrv getName] isEqualToString: [NameService name]], @"name of name service mismatch");
	
	NSAutoreleasePool* tempPool = [[NSAutoreleasePool alloc] init];
	NSString* name1 = [nameSrv generateName];
	NSString* name2 = [nameSrv newName];
	STAssertFalse([name1 isEqualToString: name2], @"name service does not generate unique names");

	// let's increase retain count of both name, both retain counts should be equal (estimated count = 2)
	[name1 retain];
	[name2 retain];	
	STAssertTrue([name1 retainCount] == [name2 retainCount], @"name service does not handle ownership of names correctly");

	// name2 should be in the current autorelease pool, let's check this and drain our current pool; retain count should differ now
	[tempPool drain];	
	STAssertTrue([name1 retainCount] < [name2 retainCount], @"name service does not handle ownership of names correctly");
	
	// name 2 must be released two times, because we have taken over ownership by calling 
	// 'newName' and additionally we have sent name1 a retain message
	[name1 release];
	[name2 release];
	[name2 release];
}

@end
