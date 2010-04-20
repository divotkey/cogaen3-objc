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
#import "LoggingService.h"


#define LOGLEVEL_DEBUG 7
#define LOGLEVEL_INFO 6
#define LOGLEVEL_NOTICE 5
#define LOGLEVEL_WARNING 4
#define LOGLEVEL_ERROR 3
#define LOGLEVEL_CRITICAL 2
#define LOGLEVEL_ALERT 1
#define LOGLEVEL_EMERGENCY 0

static NSString* const SERVICE_NAME = @"cogaen.loggingservice";

@implementation LoggingService


- (id) init {
	
	if (self = [super init]) {
		logLevel = LOGLEVEL_DEBUG;
	}
	
	return self;	
}


- (id) initWithLevel: (int) level {
	if (self = [super init]) {
		logLevel = level;
	}
	
	return self;		
}

- (NSString*) getName {
	return [LoggingService name];
}

- (void) initialize: (Core *) aCore {
	core = aCore;
}

- (void) log: (NSString*) message fromSource: (NSString*) source atLevel: (int) level {
	if (logLevel < level) {
		return;
	}
	
	NSMutableString* str = [[NSMutableString alloc] init];
	
	switch (level) {
		case LOGLEVEL_EMERGENCY:
			[str appendString: @"EMERGENCY "];
			break;
		case LOGLEVEL_ALERT: 
			[str appendString: @"ALERT "];
			break;
		case LOGLEVEL_CRITICAL:
			[str appendString: @"CRITICAL "];
			break;
		case LOGLEVEL_ERROR:
			[str appendString: @"ERROR "];
			break;
		case LOGLEVEL_WARNING:
			[str appendString: @"WARNING "];
			break;
		case LOGLEVEL_INFO:
			[str appendString: @"INFO "];
			break;
		case LOGLEVEL_DEBUG:
				[str appendString: @"DEBUG "];
			break;
			
		default:
			[str appendString: @"UNDEFINED LOG LEVEL "];
			break;
	}
	
	if (source != nil) {
		[str appendFormat: @"[%@]", source];
	}
	
	if (message != nil) {
		[str appendFormat: @": %@", message];
	}
	
	NSLog(@"%@", str);	
	[str release];
}

- (void) logDebug: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_DEBUG];
}

- (void) logInfo: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_INFO];
}

- (void) logNotice: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_NOTICE];
}

- (void) logWarning: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_WARNING];
}

- (void) logError: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_ERROR];
}

- (void) logCritical: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_CRITICAL];
}

- (void) logEmergency: (NSString*) message fromSource: (NSString*) source {
	[self log: message fromSource: source atLevel: LOGLEVEL_EMERGENCY];
}

- (void) setLevel: (int) level {
	logLevel = level; 
}

+ (LoggingService*) getInstance: (Core*) core {
	return [core getService: SERVICE_NAME];
}

+ (NSString*) name
{
	return SERVICE_NAME;
}

+ (int) LEVEL_DEBUG {
	return LOGLEVEL_DEBUG;
}

+ (int) LEVEL_INFO {
	return LOGLEVEL_INFO;
}

+ (int) LEVEL_NOTICE {
	return LOGLEVEL_NOTICE;
}

+ (int) LEVEL_WARNING {
	return LOGLEVEL_WARNING;
}

+ (int) LEVEL_ERROR {
	return LOGLEVEL_ERROR;
}

+ (int) LEVEL_CRITICAL; {
	return LOGLEVEL_CRITICAL;
}

+ (int) LEVEL_ALERT {
	return LOGLEVEL_ALERT;
}

+ (int) LEVEL_EMERGENCY {
	return LOGLEVEL_EMERGENCY;
}

@end
