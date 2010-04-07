/*
 ---------------------------------------------------------------------------
 Cogaen - Component-based Game Engine (v3)
 ---------------------------------------------------------------------------
 This software is developed by the Cogaen Development Team. Please have a 
 look at our project page (www.cogaen.org) for further details.
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright (c) 2010 Roman Divotkey. All rights reserved.
 
 This file is part of Cogaen.
 
 Cogaen is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 
 (at your option) any later version.
 
 Cogaen is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with Cogaen.  If not, see <http://www.gnu.org/licenses/>.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
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
