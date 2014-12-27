//
//  BestRouteTimer.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BestRouteTimer : NSObject {
    NSDate *start;
    NSDate *end;
}

/*Date representing time trip started*/
@property NSDate *start;

/*Date representing time trip ended*/
@property NSDate *end;

// Starts the timer by creating a new NSDate and assigning to start
- (void) startTiming;

// Stops the timer by creating a new NSDate and assigning to stop
- (void) stopTiming;

// Returns in minutes the elapsed time between start and stop
- (double) elapsedTime;

@end
