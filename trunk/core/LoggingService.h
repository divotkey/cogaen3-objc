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

#import <Foundation/Foundation.h>
#import "Service.h"

@class Core;

@interface LoggingService : NSObject <Service> {
	Core* core;
	int logLevel;
}

- (id) initWithLevel: (int) level;
- (void) log: (NSString*) message fromSource: (NSString*) source atLevel: (int) level;
- (void) setLevel: (int) level;
- (void) logDebug: (NSString*) message fromSource: (NSString*) source;
- (void) logInfo: (NSString*) message fromSource: (NSString*) source;
- (void) logNotice: (NSString*) message fromSource: (NSString*) source;
- (void) logWarning: (NSString*) message fromSource: (NSString*) source;
- (void) logError: (NSString*) message fromSource: (NSString*) source;
- (void) logCritical: (NSString*) message fromSource: (NSString*) source;
- (void) logEmergency: (NSString*) message fromSource: (NSString*) source;

+ (LoggingService*) getInstance: (Core*) core;
+ (NSString*) name;
+ (int) LEVEL_DEBUG;
+ (int) LEVEL_INFO;
+ (int) LEVEL_NOTICE;
+ (int) LEVEL_WARNING;
+ (int) LEVEL_ERROR;
+ (int) LEVEL_CRITICAL;
+ (int) LEVEL_ALERT;
+ (int) LEVEL_EMERGENCY;
@end
