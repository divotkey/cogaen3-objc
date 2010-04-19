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

#import "EaseInOut.h"


@implementation EaseInOut
@synthesize curValue, easeTime, targetValue;

- (void) reset: (double) value;
{
	curValue = value;
	targetValue = value;
	velocity = 0.0;	
}

- (void) update: (double) dt
{
	double omega = 2.0 / easeTime;
	double x = omega * dt;
	double exp = 1.0 / (1.0 + x + 0.48 * x * x * 0.235 * x * x * x);        
	
	double change = curValue - targetValue;
	double temp = (velocity + omega * change) * dt;
	velocity = (velocity - omega * temp) * exp;                   
	curValue = targetValue + (change + temp) * exp; 	
}

@end
