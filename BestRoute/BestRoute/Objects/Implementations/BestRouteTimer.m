//
//  BestRouteTimer.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteTimer.h"

@implementation BestRouteTimer
@synthesize
start,
end;

-(id)init {
    if ( self = [ super init ] ) {
        //self.start = [ [ NSDate alloc ] init ];
        //self.end   = [ [ NSDate alloc ] init ];
    }
    return self;
}

// Starts the timer by creating a new NSDate and assigning to start
- (void) startTiming {
    NSLog(@"Timing started");
    start = [ NSDate date ];
}

// Stops the timer by creating a new NSDate and assigning to stop
- (void) stopTiming {
    NSLog(@"Timing Ended");
    end = [ NSDate date ];
}

// Returns in minutes the elapsed time between start and stop
- (double) elapsedTime {
    return [ end timeIntervalSinceDate:start ];
}

@end
